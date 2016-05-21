/**
 *	@file BxDownloadStream.m
 *	@namespace iBXData
 *
 *	@details Загрузка данных из Веб-ресурса по ссылке url
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadStream.h"
#import "BxData.h"
#import "BxCommon.h"

NSString *const BxDownloadStreamHTTPErrorStatusCodeKey = @"HTTPErrorStatusCode";

@implementation BxDownloadStreamException

- (void) dealloc
{
    self.data = nil;
    [super dealloc];
}

@end

@interface BxDownloadStream ()

@property (nonatomic, copy) BxDownloadStreamHandler handler;
@property (nonatomic, copy) BxDownloadStreamHttpResponseHandler responseHandler;

@end

@implementation BxDownloadStream

- (void) main: (NSURLRequest *) request
{
	[BxDownloadUtils setNetworkActivity: YES];
	_loadingData = [[NSMutableData alloc] initWithLength: 0];
	_urlDownload = [[NSURLConnection alloc]
                   initWithRequest:request delegate:self startImmediately:YES];
}

- (void) startThread: (NSURLRequest *) request
{
	[self performSelectorOnMainThread: @selector(main:)
						   withObject: request waitUntilDone: YES];
}

- (void) start: (NSURLRequest *) request responseHandler: (BxDownloadStreamHttpResponseHandler) responseHandler
       handler: (BxDownloadStreamHandler) handler
{
    self.handler = handler;
    self.responseHandler = responseHandler;
    [self startThread: request];
}

- (id) init{
    self = [super init];
	if ( self ){
        _isCanceled = NO;
        _isStopped = NO;
		//condition = [[NSCondition alloc] init];
	}
	return self;
}

- (void) setProgress: (float) maxProgress delegate: (id<BxDownloadProgress>) delegate
{
	_maxProgress = maxProgress;
    [_progress autorelease];
	_progress = [delegate retain];
}

- (NSData*) getData
{
	return _loadingData;
}

#pragma mark NSURLConnection delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //NSLog(@"send Headers: %@", [(NSURLRequest*)request allHTTPHeaderFields], nil);
    //NSLog(@"redirect Headers: %@", [(NSHTTPURLResponse*)response allHeaderFields], nil);
	return request;
}

- (void) stopingWithError: (NSError*) error data: (NSData*) data
{
    if (_isStopped){
        return;
    }
    _isStopped = YES;
	[BxDownloadUtils setNetworkActivity: NO];
    if (self.handler) {
        self.handler(error, data);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//NSLog(@"[download] data response!");
	_progressScale = 0;
	NSInteger statusCode = 200;
	if ([response isKindOfClass: NSHTTPURLResponse.class]) {
		statusCode = [(NSHTTPURLResponse*)response statusCode];
	}
    //NSLog(@"All Headers: %@", [(NSHTTPURLResponse*)response allHeaderFields], nil);
	if (statusCode >= 200 && statusCode < 400){
		if (DPisValid(_progress)){
			_progressScale = [[self class] getProgressScaleWith: response maxProgress: _maxProgress];
		}
        if ([response isKindOfClass:[NSHTTPURLResponse self]] && self.responseHandler) {
            self.responseHandler([(NSHTTPURLResponse *)response allHeaderFields]);
        }
	} else {
		NSString * msg = BxHTTPMessageFromStatus(statusCode);
		NSDictionary * dictErrors = [NSDictionary dictionaryWithObject: msg forKey: NSLocalizedDescriptionKey];
		//NSURLErrorKey
		NSError * error = [[[NSError alloc] initWithDomain: BxDownloadStreamHTTPErrorStatusCodeKey//NSURLErrorDomain
                                                      code: statusCode userInfo: dictErrors] autorelease];
		[self stopingWithError: error data: nil];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receiveData
{
	DPincPosition(_progress, _progressScale * receiveData.length);
	[_loadingData appendData: receiveData]; // присоединяем свежие данные, полученные по интернету
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"[download] data transfer finished!");
    @synchronized(self){
        if (!_isCanceled) {
            [self stopingWithError: nil data: _loadingData];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error1
{
    if (error1.code == NSURLErrorCancelled) {
        return;
    }
    @synchronized(self){
        if (_isCanceled) {
            return;
        }
        if (error1.code == NSURLErrorCancelled)
        {
            [_loadingData release];
            _loadingData = nil;
            error1 = nil;
        } else {
            // ошибка получения данных RSS
            NSLog(@"[download] Error while loading data content feed!");
            NSLog(@"[download] Error code: %ld", (long)[error1 code]);
            NSLog(@"[download] Error description: %@", [error1 localizedDescription]);
        }
        [self stopingWithError: error1 data: _loadingData];
    }
}

- (void) dealloc
{
    self.responseHandler = nil;
    self.handler = nil;
	[_urlDownload autorelease];
    _urlDownload = nil;
	[_loadingData autorelease];
    _loadingData = nil;
    [_progress autorelease];
    _progress = nil;
	[super dealloc];
}

+ (NSData *) loadFromUrl: (NSString*) url
{
	return [self loadFromUrl: url maxProgress: 1.0 delegate: nil];
}

+ (NSData *) loadFromUrl: (NSString*) url timeoutInterval:(NSTimeInterval)timeoutInterval
{
	NSURL * currentUrl = [[NSURL alloc] initWithString: url];
	NSURLRequest * request = [NSURLRequest requestWithURL: currentUrl
											  cachePolicy: NSURLRequestUseProtocolCachePolicy // всегда кешируется, но в данном контексте это ничего не означает//NSURLRequestReturnCacheDataElseLoad
										  timeoutInterval: timeoutInterval ];
	[currentUrl release];
	if (request){
		return [BxDownloadStream loadFromRequest: request maxProgress: 1.0f delegate: nil];
	} else {
		return nil;
	}
    
}

+ (NSData *) loadFromRequest: (NSURLRequest *) request
                 maxProgress: (float) maxProgress
                    delegate: (id<BxDownloadProgress>) delegate
                      stream: (BxDownloadStream **) stream;
{
	*stream = [[self alloc] init];
	
	[*stream setProgress: maxProgress delegate: delegate];
    __block NSError *resultError = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	[*stream start: request responseHandler: nil
           handler:
     ^(NSError *error, NSData *data) {
        resultError = [error retain];
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);
    
	NSData * result = [[[*stream getData] retain] autorelease];
    @synchronized(*stream){
        [*stream release];
        *stream = nil;
    }
	if (resultError){
		BxDownloadStreamException * exception = [BxDownloadStreamException exceptionWith: [resultError autorelease]];
        exception.data = result;
        @throw exception;
	}
	return result;
}

+ (NSData *) loadFromRequest: (NSURLRequest *) request
                 maxProgress: (float) maxProgress
                    delegate: (id<BxDownloadProgress>) delegate
{
	BxDownloadStream * stream = nil;
	return [self loadFromRequest: request
                     maxProgress: maxProgress
                        delegate: delegate
                          stream: &stream];
}

+ (NSData *) loadFromUrl: (NSString*) url
             maxProgress: (float) maxProgress
                delegate: (id<BxDownloadProgress>) delegate
{
	NSURLRequest * request = [BxDownloadUtils getRequestFrom: url];
	if (request){
		return [self loadFromRequest: request
                         maxProgress: maxProgress
                            delegate: delegate];
	} else {
		return nil;
	};
}

+ (float) getProgressScaleWith: (NSURLResponse *)response maxProgress: (float) maxProgress
{
	float result = 0;
	float size = [response expectedContentLength]; // работает даже с локальными данными в отличае от закоментированного подхода
	result = maxProgress;
	if (size > 0)
		result /= size;
	else
		result = 0;
	//}
	return result;
}

+ (NSDictionary *) getAllHeaderFieldsFrom: (NSString*)url
{
    __block BxDownloadStream * stream = [[self alloc] init];
    __block NSDictionary * result = nil;
    __block NSError *resultError = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	[stream start: [BxDownloadUtils getRequestFrom: url]
  responseHandler:
     ^(NSDictionary * allHeaderData){
         result = [allHeaderData retain];
         [stream cancel];
     }
          handler:
     ^(NSError *error, NSData *data) {
         resultError = [error retain];
         dispatch_semaphore_signal(sema);
     }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);
    result = [result autorelease];
    @synchronized(stream){
        [stream release];
        stream = nil;
    }
	if (resultError){
		@throw [BxDownloadStreamException exceptionWith: [resultError autorelease]];
	}
	return result;
}

- (void) cancel
{
    if (!_isCanceled) {
        @synchronized (self)
        {
            if (!_isCanceled) {
                _isCanceled = YES;
                [_urlDownload cancel];
                [_loadingData release];
                _loadingData = nil;
                [self stopingWithError: nil data: nil];
            }
        }
    }
    
}

@end

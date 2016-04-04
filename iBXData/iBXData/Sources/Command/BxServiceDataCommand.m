/**
 *	@file BxServiceDataCommand.m
 *	@namespace iBXData
 *
 *	@details Команда, выполняющая действие на серевере, через веб-сервис
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxServiceDataCommand.h"
#import "BxData.h"

static NSString const* FNServiceDataCommandData = @"data";
static NSString const* FNServiceDataCommandURL = @"url";
static NSString const* FNServiceDataCommandCaption = @"caption";

@interface BxServiceDataCommand  ()

@property (nonatomic, retain, nonnull) NSString * url;
@property (nonatomic, retain, nullable) NSDictionary * result;
@property (nonatomic, retain, nullable) NSDictionary * rawResult;
@property (nonatomic, retain, nullable) id data;

@end

@implementation BxServiceDataCommand

- (nonnull instancetype) initWithUrl: (NSString*) url
              data: (id) data
            method: (BxServiceMethod) method
           caption: (NSString*) caption
{
    self = [self init];
	if (self) {
		self.url = url;
        self.data = nil;
        if (data){
            //if (method1 == BxServiceMethodGET) {
            //    [NSException raise: @"NotSupportException" format: @"From GET method operation not support with not nil data"];
            //}
            if ([data isKindOfClass: NSDictionary.class]) {
                self.data = [NSMutableDictionary dictionaryWithDictionary: data];
            } else if ([data isKindOfClass: NSArray.class]) {
                self.data = [NSMutableArray arrayWithArray: data];
            }
        }
        _method = method;
		_caption = [caption retain];
	}
	return self;
}

- (nonnull instancetype) initWithUrl: (NSString*) url
              data: (id) data
           caption: (NSString*) caption
{
    self = [self initWithUrl: url
                        data: data
                      method: (data == nil) ? BxServiceMethodGET : BxServiceMethodPOST
                     caption: caption];
	if (self) {
		//
	}
	return self;
}

//! @override
- (NSString*) getCaption
{
	return _caption;
}

//! @override
- (NSString*) getName
{
	return @"ServiceDataCommand";
}

- (NSURL *) getCurrentUrl
{
	return [NSURL URLWithString: _url];
}

- (void) updateRequest: (NSMutableURLRequest*) request
{
	if (_requestBody) {
		NSData * bodyData = [_requestBody dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES];
		[request setHTTPBody: bodyData];
		[request setValue: [NSString stringWithFormat:@"%d", (int)[bodyData length], nil] forHTTPHeaderField:@"Content-Length"];
		//[request setValue: @"application/post" forHTTPHeaderField:@"Content-Type"];
        
        if (_method == BxServiceMethodPOST) {
            [request setHTTPMethod: @"POST"];
        } else if (_method == BxServiceMethodPUT) {
            [request setHTTPMethod: @"PUT"];
        } else if (_method == BxServiceMethodGET) {
            [request setHTTPMethod: @"GET"];
        } else if (_method == BxServiceMethodDELETE) {
            [request setHTTPMethod: @"DELETE"];
        } else {
            [self.class errorWithCode: 0 message: @"Данный метод HTTP с телом заголовка не поддерживается"];
        }
	} else {
        if (_method == BxServiceMethodGET) {
            [request setHTTPMethod: @"GET"];
        } else if (_method == BxServiceMethodDELETE) {
            [request setHTTPMethod: @"DELETE"];
        } else {
            [self.class errorWithCode: 0 message: @"Данный метод HTTP без тела заголовка не поддерживается"];
        }
	}
}

- (NSDictionary*) checkResult: (NSDictionary*) dataResult
{
    return dataResult;
}

- (NSString *) getRequestBody
{
    return [_parser getStringFrom: _data];
}

//! @override
- (void) execute
{
    if (!_parser) {
        [self.class errorWithCode: 0 message: @"Не установлен парсер для команды"];
    }

	self.rawResult = nil;
	self.result = nil;
    [_requestBody autorelease];
	_requestBody = nil;
    
    _isCanceled = NO;
	NSLog(@"Start COMMAND: %@ (%@)", _caption, _url);
	if (_data) {
		_requestBody = [[self getRequestBody] retain];
        NSLog(@"request: %@", _requestBody);
	}
	
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [self getCurrentUrl]
															cachePolicy: NSURLRequestUseProtocolCachePolicy // всегда кешируется, но в данном контексте это ничего не означает//NSURLRequestReturnCacheDataElseLoad
														timeoutInterval: 60.0 ];
	[self updateRequest: request];
	NSData * data = nil;
    
    if (_mockResourceFileName) {
        data = [NSData dataWithResourceFileName: _mockResourceFileName];
        if (data) {
            NSLog(@"Loading from mockup file (%@) and sleep (%2.2f sec)", _mockResourceFileName, _mockDelay);
            [NSThread sleepForTimeInterval: self.mockDelay];
        }
    }
	
    @try {
        if (!data){
            NSLog(@"Loading from real service with request (%@)", request);
            data = [BxDownloadStream loadFromRequest: request
                                         maxProgress: 1.0f
                                            delegate: nil
                                              stream: &_stream];
        }
    }
    @catch (BxDownloadStreamException *exception) {
        @try {
            self.rawResult = [_parser dataFromData: data];
            @throw exception;
        }
        @catch (NSException *_exception_) {
            @throw exception;
        }
    }
	
    if (self.isCanceled) {
        self.rawResult = nil;
        self.result = nil;
        return;
    }
    
	//NSString * outString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	//NSLog(outString, nil);
	//[outString release];
	
	NSDictionary * rawResult = [_parser dataFromData: data];
	//NSLog(@"result: %@", rawResult, nil);
	
    self.rawResult = rawResult;
	self.result = [self checkResult: rawResult];
    
}

//! override
- (NSMutableDictionary*) saveToData
{
	NSMutableDictionary * returnedResult = [NSMutableDictionary dictionaryWithCapacity: 4];
	if (_data) {
		[returnedResult setObject: _data forKey: FNServiceDataCommandData];
	}
	if (_url) {
		[returnedResult setObject: _url forKey: FNServiceDataCommandURL];
	}
	if (_caption) {
		[returnedResult setObject: _caption forKey: FNServiceDataCommandCaption];
	}
	return returnedResult;
}

//! override
- (void) loadFromData: (NSMutableDictionary*) rawData
{
	self.data = rawData[FNServiceDataCommandData];
	self.url = rawData[FNServiceDataCommandURL];
    [_caption autorelease];
	_caption = [rawData[FNServiceDataCommandCaption] retain];
}

- (void) dealloc
{
	[_url autorelease];
    _url = nil;
	[_requestBody autorelease];
    _requestBody = nil;
	[_caption autorelease];
    _caption = nil;
	[_parser autorelease];
    _parser = nil;
    self.data = nil;
	self.result = nil;
	self.rawResult = nil;
    self.mockResourceFileName = nil;
	[super dealloc];
}

- (void)cancelOnDownloadStream
{
    if (_stream) {
        @synchronized(_stream){
            if (_stream) {
                [_stream cancel];
            }
        }
    }
}

//! @override
- (void)cancel
{
    if (!_isCanceled)
        _isCanceled = YES;
    [self cancelOnDownloadStream];
}

@end

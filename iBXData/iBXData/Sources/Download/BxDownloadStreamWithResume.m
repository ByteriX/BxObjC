/**
 *	@file BxDownloadStreamWithResume.m
 *	@namespace iBXData
 *
 *	@details Загрузка ресурсов с дозакачкой из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadStreamWithResume.h"
#import "BxData.h"
#import "BxCommon.h"

NSString *const BxDownloadStreamWithResumeHTTPErrorStatusCodeKey = @"HTTPErrorStatusCode";

@implementation BxDownloadStreamWithResume

- (void) main
{
	self.urlDownload = [[[NSURLConnection alloc] initWithRequest: _request
                                                        delegate: self
                                                startImmediately: YES] autorelease];
}

- (void) startThread
{
	[self performSelectorOnMainThread: @selector(main)
						   withObject: nil waitUntilDone: YES];
}

- (void) start: (NSURLRequest *) request
{
    [BxDownloadUtils setNetworkActivity: YES];
	NSAutoreleasePool * arPool = [[NSAutoreleasePool alloc] init];
    [BxFileSystem initDirectories: [_filePath stringByDeletingLastPathComponent]];
    self.error = nil;
    [_fileStream close];
    self.fileStream = nil;
    _progressScale = 0;
    _startPosition = 0;
    _dataPacketBytesCount = 0;
    self.request = [[request mutableCopy] autorelease];
	[_condition lock];
	//[NSThread detachNewThreadSelector: @selector(startThread:) toTarget:self withObject:request];
	[self startThread];
	[_condition wait];
	[_condition unlock];
	[arPool release];
}

- (id) init{
    self = [super init];
	if ( self ){
		_condition = [[NSCondition alloc] init];
        _isStopped = NO;
	}
	return self;
}

- (void) setProgress: (float) maxProgress delegate: (id<BxDownloadProgress>) delegate
{
	_maxProgress = maxProgress;
    [_progress autorelease];
	_progress = [delegate retain];
}

- (NSError*) getError
{
	return _error;
}

#pragma mark NSURLConnection delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request1 redirectResponse:(NSURLResponse *)response
{
    //NSLog(@"send Headers: %@", [(NSURLRequest*)_request allHTTPHeaderFields], nil);
    //NSLog(@"redirect Headers: %@", [(NSHTTPURLResponse*)_response allHeaderFields], nil);
	return request1;
}

- (void) updateFileAttribute
{
    if (_modifiedDate) {
        NSError * fileModifyDateError = nil;
        NSDictionary * fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath: _filePath error: &fileModifyDateError];
        if (!fileModifyDateError) {
            NSMutableDictionary * outFileAttribute = [NSMutableDictionary dictionaryWithDictionary:fileAttribute];
            [outFileAttribute setObject: _modifiedDate forKey: NSFileCreationDate];
            [[NSFileManager defaultManager] setAttributes: outFileAttribute ofItemAtPath: _filePath error:&fileModifyDateError];
        }
        if (fileModifyDateError) {
            NSLog(@"Error with save file: %@", fileModifyDateError);
        }
    }
}

- (void) stoping
{
    if (_isStopped){
        return;
    }
    _isStopped = YES;
	[BxDownloadUtils setNetworkActivity: NO];
	[_condition lock];
	[_condition signal];
	[_condition unlock];
    [_fileStream close];
    self.fileStream = nil;
    if (_modifiedDate) {
        [self updateFileAttribute];
        self.modifiedDate = nil;
    }
}

- (void) stopingWithError: (NSError*) localError
{
	self.error = localError;
    [_urlDownload cancel];
    [self stoping];
}

- (void) stopingWithMessage: (NSString*) msg code: (NSInteger) code
{
	NSDictionary * dictErrors = [NSDictionary dictionaryWithObject: msg forKey: NSLocalizedDescriptionKey];
    //NSURLErrorKey
    NSError * localError = [[[NSError alloc] initWithDomain: BxDownloadStreamWithResumeHTTPErrorStatusCodeKey//NSURLErrorDomain
                                                       code: code userInfo: dictErrors] autorelease];
    [self stopingWithError: localError];
}

- (BxDownloadStreamWithResumeFileExistType) checkFileExist
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: _filePath]) {
        if (_modifiedDate) {
            NSError * fileModifyDateError = nil;
            NSDictionary * fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath: _filePath error: &fileModifyDateError];
            if (fileModifyDateError) {
                [self stopingWithError: fileModifyDateError];
                return BxDownloadStreamWithResumeFileExistTypeError;
            }
            NSDate * fileModifyDate = [fileAttribute objectForKey: NSFileCreationDate];
            if (!fileModifyDate) {
                [self stopingWithMessage: @"Неверный файл закачки" code: 0];
                return BxDownloadStreamWithResumeFileExistTypeError;
            } else {
                NSTimeInterval time = [_modifiedDate timeIntervalSinceDate: fileModifyDate];
                if (fabs(time) < 0.1) {
                    _startPosition = [[fileAttribute objectForKey: NSFileSize] unsignedLongLongValue];
                    [_urlDownload cancel];
                    return BxDownloadStreamWithResumeFileExistTypeResume;
                }
            }
        } else {
            NSError * removeError = nil;
            [[NSFileManager defaultManager] removeItemAtPath: _filePath error: &removeError];
            if (removeError) {
                [self stopingWithError: removeError];
                return BxDownloadStreamWithResumeFileExistTypeError;
            }
        }
    }
    return BxDownloadStreamWithResumeFileExistTypeNone;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//NSLog(@"[download] data response!");
    long long size = [response expectedContentLength];
	NSInteger statusCode = 200;
    self.modifiedDate = nil;
	if ([response isKindOfClass: NSHTTPURLResponse.class]) {
		statusCode = [(NSHTTPURLResponse*)response statusCode];
        NSDictionary *headers = [(NSHTTPURLResponse*)response allHeaderFields];
        @try {
            self.modifiedDate = [BxDownloadOldFileCasher getLastModifiedFromAllHeader: headers];
        }
        @catch (NSException *exception) {
            NSLog(@"Дозакачка невозможна, по причине невозможности получить с сервера дату последнего изменения файла");
        }
	}
    
    if (_startPosition == 0) {
        if (DPisValid(_progress)){
			_progressScale = [BxDownloadStream getProgressScaleWith: response maxProgress: _maxProgress];
        }
        BxDownloadStreamWithResumeFileExistType fileExist = [self checkFileExist];
        if (fileExist == BxDownloadStreamWithResumeFileExistTypeResume) {
            
            NSString * contentRangeHeader = [NSString stringWithFormat: @"bytes=%@-",
                                             [NSNumber numberWithLongLong: _startPosition], nil
                                             ];
            NSLog(@"Download with Content-Range: %@", contentRangeHeader);
            [_request setValue: contentRangeHeader forHTTPHeaderField: @"Range"];
            [self startThread];
            return;
        } else if (fileExist == BxDownloadStreamWithResumeFileExistTypeError) {
            return;
        }
    }
    
    self.fileStream = [NSOutputStream outputStreamToFileAtPath: self.filePath append: YES];
    assert(self.fileStream != nil);
    [self.fileStream open];
    [self updateFileAttribute];
    
    NSLog(@"Loading bytes: %@", [NSNumber numberWithLongLong: size]);
    NSLog(@"All Headers: %@", [(NSHTTPURLResponse*)response allHeaderFields]);
	if (statusCode >= 200 && statusCode < 400){
		if (DPisValid(_progress)){
            DPincPosition(_progress, _progressScale * _startPosition);
		}
	} else {
		NSString * msg = BxHTTPMessageFromStatus(statusCode);
        [self stopingWithMessage: msg code: statusCode];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receiveData
{
	DPincPosition(_progress, _progressScale * receiveData.length);
	
#pragma unused(connection)
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    assert(connection == self.urlDownload);
    
    dataLength = [receiveData length];
    dataBytes  = [receiveData bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            if (_fileStream.streamError) {
                [self stopingWithError: _fileStream.streamError];
            } else {
                [self stopingWithMessage: @"Ошибка записи в файл загрузки " code: 0];
            }
            return;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
    
    _dataPacketBytesCount += receiveData.length;
    
    if (_dataPacketBytesCount > 250000) { // сохраняем буффер
        _dataPacketBytesCount = 0;
        [_fileStream hasSpaceAvailable];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"[download] data transfer finished!");
	[self stoping];
    // Меняем даты и переименовываем файл:
    NSError * fileModifyDateError = nil;
    NSDictionary * fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath: _filePath error: &fileModifyDateError];
    if (!fileModifyDateError) {
        NSMutableDictionary * outFileAttribute = [NSMutableDictionary dictionaryWithDictionary:fileAttribute];
        [outFileAttribute setObject: [fileAttribute objectForKey: NSFileCreationDate] forKey: NSFileModificationDate];
        [outFileAttribute setObject: [NSDate date] forKey: NSFileCreationDate];
        [[NSFileManager defaultManager] setAttributes: outFileAttribute ofItemAtPath: _filePath error:&fileModifyDateError];
    }
    if (fileModifyDateError) {
        NSLog(@"Error with save file: %@", fileModifyDateError);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error1
{
	if (error1.code == NSURLErrorCancelled/* ||
                                           error1.code == NSURLErrorUnsupportedURL ||
                                           error1.code == NSURLErrorFileIsDirectory*/)
	{
		
	} else {
		// ошибка получения данных RSS
		NSLog(@"[download] Error while loading data content feed!");
		NSLog(@"[download] Error code: %li", (long)[error1 code]);
		NSLog(@"[download] Error description: %@", [error1 localizedDescription]);
		self.error = error1;
	}
    if (error1.code != NSURLErrorCancelled) {
        [self stoping];
    }
}

+ (void) loadFromRequest: (NSURLRequest *) request
             maxProgress: (float) maxProgress
                delegate: (id<BxDownloadProgress>) delegate
                filePath: (NSString*) filePath
                    stream: (BxDownloadStreamWithResume **) stream
{
	*stream = [[self.class alloc] init];
	(*stream).filePath = filePath;
	[*stream setProgress: maxProgress delegate: delegate];
	[*stream start: request];
	NSError * error = [[[*stream getError] retain] autorelease];
	[*stream release];
    *stream = nil;
	if (error){
		@throw [BxDownloadStreamException exceptionWith: error];
	}
}

+ (void) loadFromUrl: (NSString*) url
         maxProgress: (float) maxProgress
            delegate: (id<BxDownloadProgress>) delegate
            filePath: (NSString*) filePath
{
	NSURLRequest * request = [BxDownloadUtils getRequestFrom: url];
	if (request){
        BxDownloadStreamWithResume * stream = nil;
		[self loadFromRequest: request
                  maxProgress: maxProgress
                     delegate: delegate
                     filePath: filePath
                       stream: &stream];
	}
}

- (void) cancel
{
    [_urlDownload cancel];
    // удалить файл!
    [self stoping];
}

- (void) dealloc
{
	[_condition autorelease];
    _condition = nil;
    self.request = nil;
	self.urlDownload = nil;
	self.filePath = nil;
    self.fileStream = nil;
    self.error = nil;
    [_progress autorelease];
    _progress = nil;
	[super dealloc];
}

@end

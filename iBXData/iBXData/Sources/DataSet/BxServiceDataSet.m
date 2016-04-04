/**
 *	@file BxServiceDataSet.m
 *	@namespace iBXData
 *
 *	@details Хранилище данных, полученных через Веб-сервис
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxServiceDataSet.h"
#import "BxData.h"
#import "BxCommon.h"

@implementation BxServiceDataSet

//! @override
- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
{
    self = [super initWithTarget: target];
	if ( self ){
		_parser = [parser retain];
        _mockDelay = 0.0;
	}
	return self;
}

- (float) getPosition
{
	return _progressPosition;
}

- (void) setPosition: (float) position
{
	[super setProgress: position];
}

- (void) startFastFull
{
	//
}

- (BOOL) isActive
{
	return YES;
}

- (void) updateRequest: (NSMutableURLRequest*) request
{
	//
}

- (NSURL *) getCurrentUrl
{
	return [NSURL URLWithString: [self getRequestUrl]];
}

- (float) getMaxProgress
{
	return 1.0f;
}

- (NSURLRequestCachePolicy) getCachePolicy
{
    return NSURLRequestUseProtocolCachePolicy; // всегда кешируется, но в данном контексте это ничего не означает//NSURLRequestReturnCacheDataElseLoad
}

- (NSString*) getRequestUrl
{
    return _url;
}

- (NSString*) getRequestPost
{
    return _post;
}

//! @override
- (NSDictionary *) loadData
{
    if (!_parser) {
        [BxAbstractDataCommand errorWithCode: 0 message: @"Не установлен парсер для набора данных"];
    }
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [self getCurrentUrl]
															cachePolicy: [self getCachePolicy]
														timeoutInterval: 60.0 ];
	if ([self getRequestPost]) {
		NSData * bodyData = [[self getRequestPost] dataUsingEncoding: NSUTF8StringEncoding
                                                allowLossyConversion: YES];
		[request setHTTPBody: bodyData];
		[request setHTTPMethod: @"POST"];
		[request setValue: [NSString stringWithFormat:@"%d", (int)[bodyData length], nil] forHTTPHeaderField:@"Content-Length"];
		//[request setValue: @"application/post" forHTTPHeaderField:@"Content-Type"];
	} else {
		[request setHTTPMethod: @"GET"];
	}
    
	[self updateRequest: request];
    
    NSData * data = nil;
    
    if (_mockResourceFileName) {
        data = [NSData dataWithResourceFileName: _mockResourceFileName];
        if (data) {
            NSLog(@"Loading from mockup file (%@) and sleep (%2.2f sec)", _mockResourceFileName, _mockDelay);
            [NSThread sleepForTimeInterval: self.mockDelay];
        }
    }
    
    if (!data) {
        NSLog(@"Loading from real service with request (%@)", request);
        data = [BxDownloadStream loadFromRequest: request
                                     maxProgress: [self getMaxProgress]
                                        delegate: self
                                          stream: &_downloadStream];
    }
	/*NSString * outString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
     NSLog(outString, nil);
     [outString release];*/
    
    if (self.isCancel) {
        return nil;
    }
	
	if (data == nil) {
		[BxAbstractDataCommand errorWithCode: 0 message: StandartLocalString(@"Server did request a empty data set")];
	}
    
	NSDictionary * result = [_parser dataFromData: data];
	
	//NSLog(@"%@", result);
    return [self checkResult: result];
}

- (NSDictionary*) checkResult: (NSDictionary*) dataResult
{
    return dataResult;
}

- (void) toCancelOnStream
{
    if (_downloadStream) {
        @synchronized(_downloadStream){
            if (_downloadStream) {
                [_downloadStream cancel];
            }
        }
    }
}

//! @override
- (void) toCancel
{
    [super toCancel];
    [self toCancelOnStream];
}

//! @override
- (void) dealloc
{
	[_parser autorelease];
    _parser = nil;
	self.url = nil;
	self.post = nil;
    self.mockResourceFileName = nil;
	[super dealloc];
}

@end

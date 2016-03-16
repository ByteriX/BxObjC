/**
 *	@file BxAbstractDataParser.m
 *	@namespace iBXData
 *
 *	@details Абстрактный сериализатор/дисериализатор
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataParser.h"
#import "BxCommon.h"
#import "BxData.h"

@implementation BxParserException

@end

@implementation BxAbstractDataParser

- (NSDictionary*) dataFromData: (NSData*) data
{
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataParser method (dataFromData) is not implement"];
	return nil;
}

- (NSDictionary*) dataFromString: (NSString*) string
{
	return [self dataFromData: [string dataUsingEncoding: NSUTF8StringEncoding]];
}

- (NSData*) serializationData: (NSDictionary*) data
{
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataParser method (serializationData) is not implement"];
	return nil;
}

- (NSDictionary*) loadFromFile: (NSString*) filePath
{
	NSError * error = nil;
	NSDictionary * result = nil;
	NSData * data = [[NSData alloc] initWithContentsOfFile: filePath options: 0 error: &error];
	@try {
		if (error){
			@throw [BxException exceptionWith: error];
		}
		result = [self dataFromData: data];
	}
	@finally {
		[data release];
	}
	return result;
}

- (NSDictionary *) loadFromUrl: (NSString*) url post: (NSString*)post
{
	NSURL * currentUrl = [NSURL URLWithString: url];
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: currentUrl
															cachePolicy: NSURLRequestUseProtocolCachePolicy // всегда кешируется, но в данном контексте это ничего не означает//NSURLRequestReturnCacheDataElseLoad
														timeoutInterval: 60.0 ];
	if ( post && post.length > 0 ) {
		NSData * bodyData = [post dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES];
		[request setHTTPBody: bodyData];
		[request setHTTPMethod: @"POST"];
		[request addValue: [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length], nil] forHTTPHeaderField:@"Content-Length"];
	}
	NSData * data = [BxDownloadStream loadFromRequest: request
                                          maxProgress: 1.0f
                                             delegate: nil];
	return [self dataFromData: data];
}

- (NSDictionary *) loadFromUrl: (NSString*) url
{
	return [self loadFromUrl: url post: nil];
}

- (void) saveFrom: (NSDictionary*) data toPath: (NSString*) filePath
{
	NSData * result = [self serializationData: data];
    NSError * error = nil;
    [result writeToFile: filePath options: NSDataWritingAtomic error: &error];
	if (error){
		@throw [BxException exceptionWith: error];
	}
}

- (NSString*) getStringFrom: (NSDictionary*) data
{
	NSData * result = [self serializationData: data];
	return [[[NSString alloc] initWithData: result encoding: NSUTF8StringEncoding] autorelease];
}

@end

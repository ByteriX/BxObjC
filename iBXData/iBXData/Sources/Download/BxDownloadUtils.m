/**
 *	@file BxDownloadUtils.m
 *	@namespace iBXData
 *
 *	@details Хитрости для загрузки данных из Веб-ресурса
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadUtils.h"
#import <UIKit/UIKit.h>

@implementation BxDownloadUtils

static int networkActivityCount = 0;

+ (void) hideNetworkActivity
{
	[NSThread sleepForTimeInterval: 0.5];
	@synchronized (self){
		if (networkActivityCount <= 0) {
            networkActivityCount = 0;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	}
}

+ (void) setNetworkActivity: (BOOL) isNetworkActivity
{
	@synchronized (self){
		if (isNetworkActivity) {
			networkActivityCount++;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		} else {
			networkActivityCount--;
			[NSThread detachNewThreadSelector: @selector(hideNetworkActivity) toTarget: self withObject: nil];
		}
	}
}

+ (NSURLRequest*) getRequestFrom: (NSString*) url
{
	NSURL * currentUrl = [[NSURL alloc] initWithString: url];
	NSURLRequest * request = [NSURLRequest requestWithURL: currentUrl
                                              cachePolicy: NSURLRequestUseProtocolCachePolicy // всегда кешируется, но в данном контексте это ничего не означает//NSURLRequestReturnCacheDataElseLoad
                                          timeoutInterval: 60.0 ];
	[currentUrl release];
	return request;
}

@end

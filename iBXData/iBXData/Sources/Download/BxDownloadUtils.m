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
#import "BxCommon.h"

@implementation BxDownloadUtils

static int networkActivityCount = 0;

+ (void) hideNetworkActivity
{
    if IS_OS_13_OR_LATER {
        // networkActivityIndicatorVisible is deprecated
    } else {
        @synchronized (self){
            if (networkActivityCount <= 0) {
                networkActivityCount = 0;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
    }
}

+ (void) setNetworkActivity: (BOOL) isNetworkActivity
{
    if IS_OS_13_OR_LATER {
        // networkActivityIndicatorVisible is deprecated
    } else {
        @synchronized (self){
            if (isNetworkActivity) {
                networkActivityCount++;
                if ([NSThread isMainThread]) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    });
                }
            } else {
                networkActivityCount--;
                dispatch_after(0.5, dispatch_get_main_queue(), ^{
                    [BxDownloadUtils hideNetworkActivity];
                });
            }
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

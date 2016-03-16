/**
 *	@file BxDownloadUtils.h
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

#import <Foundation/Foundation.h>
#import "BxDownloadProgress.h"

@protocol BxDownloadStreamProtocol

- (void) cancel;

@optional

+ (void) loadFromUrl: (NSString*) url
         maxProgress: (float) maxProgress
            delegate: (id<BxDownloadProgress>) delegate
            filePath: (NSString*) filePath;

+ (NSData *) loadFromUrl: (NSString*) url
             maxProgress: (float) maxProgress
                delegate: (id<BxDownloadProgress>) delegate;

@end

//! Хитрости для загрузки данных из Веб-ресурса
@interface BxDownloadUtils : NSObject

+ (void) setNetworkActivity: (BOOL) isNetworkActivity;

+ (NSURLRequest*) getRequestFrom: (NSString*) url;

@end

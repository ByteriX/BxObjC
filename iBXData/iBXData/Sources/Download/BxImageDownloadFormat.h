/**
 *	@file BxImageDownloadFormat.h
 *	@namespace iBXData
 *
 *	@details Формат для изображений из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    BxImageFormatJPG,
    BxImageFormatPNG
} BxImageFormat;

@interface BxImageDownloadFormat : NSObject

@property (nonatomic, retain) NSString * apendixName;
@property (nonatomic) CGSize size;
@property (nonatomic) BxImageFormat imageFormat;

- (id) initWithImageFormat: (BxImageFormat) imageFormat size: (CGSize) size;
- (id) initWithImageFormat: (BxImageFormat) imageFormat size: (CGSize) size apendixName: (NSString*) apendixName;

@end

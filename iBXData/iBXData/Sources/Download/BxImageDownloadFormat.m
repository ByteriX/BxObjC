/**
 *	@file BxImageDownloadFormat.m
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

#import "BxImageDownloadFormat.h"

@implementation BxImageDownloadFormat

- (id) initWithImageFormat: (BxImageFormat) imageFormat size: (CGSize) size
{
    return [self initWithImageFormat: imageFormat size: size apendixName: nil];
}

- (id) initWithImageFormat: (BxImageFormat) imageFormat size: (CGSize) size apendixName: (NSString*) apendixName
{
    self = [self init];
    if (self) {
        if (apendixName) {
            self.apendixName = apendixName;
        } else {
            NSString * ext = @"BINARY";
            if (imageFormat == BxImageFormatJPG) {
                ext = @"JPG";
            } else if (imageFormat == BxImageFormatPNG) {
                ext = @"PNG";
            }
            self.apendixName = [NSString stringWithFormat: @"%d_%d.%@",
                                (int)size.width, (int)size.height, ext];
        }
        // для ретины размер удваиваем
        size.width *= [UIScreen mainScreen].scale;
        size.height *= [UIScreen mainScreen].scale;
        self.size = size;
        self.imageFormat = imageFormat;
    }
    return self;
}

- (void) dealloc
{
    self.apendixName = nil;
    [super dealloc];
}

@end

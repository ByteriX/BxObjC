/**
 *	@file BxDownloadOldFileImageCasher.m
 *	@namespace iBXData
 *
 *	@details Кешированная закачка для изображений из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadOldFileImageCasher.h"
#import "BxCommon.h"

@implementation BxDownloadOldFileImageCasher

- (id)init{
    self = [super init];
    if ( self ) {
		_formats = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addFormat: (BxImageDownloadFormat*) format
{
    [_formats addObject: format];
}

- (void) addImageFormat: (BxImageFormat) imageFormat size: (CGSize) size
{
    BxImageDownloadFormat * result = [[BxImageDownloadFormat alloc] initWithImageFormat: imageFormat size:size];
    [self addFormat: result];
    [result release];
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize {
    
    //If scaleFactor is not touched, no scaling will occur
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    
    //это Fit
    
    /*if (image.size.width > targetSize.width || image.size.height > targetSize.height)
     if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
     scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
     
     //Creating the rect where the scaled image is drawn in
     CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
     (targetSize.height -  image.size.height * scaleFactor) / 2,
     image.size.width * scaleFactor, image.size.height * scaleFactor);*/
    
    
    //это Fill
    
    if (targetSize.width / image.size.width < targetSize.height / image.size.height) {
        scaleFactor = targetSize.height / image.size.height;
    } else {
        scaleFactor = targetSize.width / image.size.width;
    }
    
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    UIGraphicsBeginImageContext(targetSize);
    
    //Draw the image into the rect
    [image drawInRect: rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // это простое обрезание
    //CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //UIImage *scaledImage = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    return scaledImage;
}

- (void) updateFormatsWithOriginalPath: (NSString*) originalPath
{
    for (BxImageDownloadFormat * format in _formats) {
        UIImage * image = [UIImage imageWithContentsOfStringURL: originalPath];
        image = [self.class scaleImage: image toSize: format.size];
        NSString * resultPath = [originalPath stringByAppendingString: format.apendixName];
        if (format.imageFormat == BxImageFormatJPG) {
            if (![UIImageJPEGRepresentation(image, 0.8) writeToURL: [NSURL URLWithString: resultPath]
                                                        atomically:YES])
            {
                NSLog(@"ERROR!!! JPEG");
            }
        } else if (format.imageFormat == BxImageFormatPNG) {
            if (![UIImagePNGRepresentation(image) writeToURL: [NSURL URLWithString: resultPath]
                                                  atomically:YES])
            {
                NSLog(@"ERROR!!! PNG");
            }
        } else {
            [NSException raise: @"IncorrectException" format: @"The image format is not saving to getDownloadedPathFrom"];
        }
    }
}

//! @override
- (NSString *) getDownloadedPathFrom: (NSString*) url errorConnection: (BOOL) errorConnection progress: (id<BxDownloadProgress>) progress
{
    NSString * cashedPath = nil;
    if ([self isCashed: url]) {
        cashedPath = [self getLocalDownloadedPathFrom: url];
    }
    NSString * originalPath = [super getDownloadedPathFrom: url errorConnection: errorConnection progress: progress];
    if ((!cashedPath) || (![cashedPath isEqualToString: originalPath])) {
        // обновляем нарезываемые картинки
        [self updateFormatsWithOriginalPath: originalPath];
    }
    return originalPath;
}

+ (NSString*) pathFromUrl: (NSString*) url
{
    NSURL * result = [NSURL URLWithString: url];
    return [result path];
}

+ (BOOL) isExistsUrl: (NSString*) url
{
    return [[NSFileManager defaultManager] fileExistsAtPath: [self pathFromUrl: url]];
}

- (NSString *) getDownloadedPathFrom: (NSString*) url errorConnection: (BOOL) errorConnection progress: (id<BxDownloadProgress>) progress formatIndex: (int) formatIndex
{
    if (formatIndex > _formats.count) {
        [NSException raise: @"IncorrectException" format: @"Index out of bounds in format from getDownloadedPathFrom"];
    }
    NSString * originalPath = [self getDownloadedPathFrom: url errorConnection: errorConnection progress: progress];
    if (formatIndex == 0) {
        return originalPath;
    }
    BxImageDownloadFormat * format = [_formats objectAtIndex: formatIndex - 1];
    NSString * resultPath = [originalPath stringByAppendingString: format.apendixName];
    if ([self.class isExistsUrl: resultPath]) {
        return resultPath;
    } else {
        return originalPath;
    }
}

- (NSString*) getLocalDownloadedPathFrom: (NSString*) url formatIndex: (int) formatIndex
{
    if (formatIndex > _formats.count) {
        [NSException raise: @"IncorrectException" format: @"Index out of bounds in format from getDownloadedPathFrom"];
    }
    NSString * originalPath = [self getLocalDownloadedPathFrom: url];
    if (formatIndex == 0) {
        return originalPath;
    }
    BxImageDownloadFormat * format = [_formats objectAtIndex: formatIndex - 1];
    NSString * resultPath = [originalPath stringByAppendingString: format.apendixName];
    if ([self.class isExistsUrl: resultPath]) {
        return resultPath;
    } else {
        return originalPath;
    }
}

- (void) dealloc
{
    [_formats autorelease];
    _formats = nil;
    [super dealloc];
}

@end

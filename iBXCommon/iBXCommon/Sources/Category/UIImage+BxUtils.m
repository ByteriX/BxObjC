/**
 *	@file UIImage+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для UIImage
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "UIImage+BxUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"

@implementation UIImage (BxUtils)

+ (UIImage*) imageWithContentsOfStringURL: (NSString*) url
{
    return [self imageWithContentsOfURL: [NSURL URLWithString: url]];
}

+ (UIImage*) imageWithContentsOfURL: (NSURL*) currentUrl
{
    if ([currentUrl isFileURL]) {
        return [UIImage imageWithContentsOfFile: [currentUrl path]];
    } else {
        return [UIImage imageWithData: [NSData dataWithContentsOfURL: currentUrl]];
    }
}

+ (UIImage*) imageFromBuffer: (CVImageBufferRef) imageBuffer
{
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    /*We release some components*/
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    
    /*We relase the CGImageRef*/
    CGImageRelease(newImage);
    
    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    return image;
}

+ (UIImage *)imageWithUIView:(UIView *)view
{
    CGSize screenShotSize = view.bounds.size;
    UIImage *img;
    UIGraphicsBeginImageContext(screenShotSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view drawLayer:view.layer inContext:ctx];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithAllUIView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)imageFromView:(UIView *)view
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [view bounds].size;
    /*
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    */
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the view's anchor point
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    // Apply the view's transform about the anchor point
    CGContextConcatCTM(context, [view transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    
    // Render the layer hierarchy to the current context
    [[view layer] renderInContext:context];
    
    // Restore the context
    CGContextRestoreGState(context);
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *) stretchableImageWithLeftAndRightCap: (NSInteger) leftAndRightCap
                                  topAndBottomCap: (NSInteger) topAndBottomCap
{
    UIImage * result = nil;
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        result = [self resizableImageWithCapInsets:UIEdgeInsetsMake(topAndBottomCap, leftAndRightCap, topAndBottomCap, leftAndRightCap)];
    } else {
        result = [self stretchableImageWithLeftCapWidth:leftAndRightCap topCapHeight:topAndBottomCap];
    }
    return result;
}
- (UIImage*)imageWithSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)imageWithMaxSize:(CGSize) inscribedSize;
{
    CGFloat scale;
    if (inscribedSize.height > self.size.height && inscribedSize.width > self.size.width) {
        return self;
    } else {
        scale = inscribedSize.width / self.size.width;
        CGFloat scaleY = inscribedSize.height / self.size.height;
        if (scale > scaleY) {
            scale = scaleY;
        }
    }
    CGSize newSize = self.size;
    newSize.width = truncf(newSize.width * scale);
    newSize.height = truncf(newSize.height * scale);
    return [self imageWithSize: newSize];
}

- (UIImage *)imageWithFitSize:(CGSize)targetSize {
    
    //If scaleFactor is not touched, no scaling will occur
    CGFloat scaleFactor = 1.0;
    
    if (targetSize.width / self.size.width < targetSize.height / self.size.height) {
        scaleFactor = targetSize.height / self.size.height;
    } else {
        scaleFactor = targetSize.width / self.size.width;
    }
    
    CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
                             (targetSize.height -  self.size.height * scaleFactor) / 2,
                             self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    UIGraphicsBeginImageContext(targetSize);
    
    //Draw the image into the rect
    [self drawInRect: rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *) blurOfStackWithRadius: (CGFloat) radius
{
    return [self stackBlur: (NSUInteger)radius];
}

- (UIImage *)blurWithRadius: (CGFloat) radius
{
    UIImage *sourceImage = self;
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue: inputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@(radius) forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    UIImage *image       = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

@end

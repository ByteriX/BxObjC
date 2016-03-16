/**
 *	@file UIImage+BxUtils+Prefix.m
 *	@namespace iBXCommon
 *
 *	@details Категория для UIImage для идентификации префиксов в названии изображения
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "UIImage+BxUtils+Prefix.h"
#import <objc/runtime.h>
#import "BxCommon.h"

@implementation UIImage (BxUtilsPrefix)

+ (void)load {
    if  (IS_568 && IS_OS_7_OR_LATER)
    {
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamed_H568_IOS7:)));
    } else if (IS_568 && (!IS_OS_7_OR_LATER)) {
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamed_H568:)));
    } else if (IS_568_GREATER) {
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamed_H_IOS8:)));
    } else if (IS_OS_7_OR_LATER) {
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamed_IOS7:)));
    }
}

+ (UIImage *)imageNamed_H568:(NSString *)imageName {
    return [UIImage imageNamed_H568: [self renameImageNameForH568:imageName]];
}

+ (UIImage *)imageNamed_IOS7:(NSString *)imageName {
    return [UIImage imageNamed_IOS7: [self renameImageNameForIos7:imageName]];
}

+ (UIImage *)imageNamed_H568_IOS7:(NSString *)imageName {
    return [UIImage imageNamed_H568_IOS7: [self renameImageNameForH568andIos7:imageName]];
}

+ (UIImage *)imageNamed_H_IOS8:(NSString *)imageName {
    return [UIImage imageNamed_H_IOS8: [self renameImageNameForH:imageName]];
}

+ (NSString *)renameImageName:(NSString *)imageName imageNameMutable: (NSMutableString *) imageNameMutable
{
    //Check if the image exists and load the new 568 if so or the original name if not
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType: @"png"];
    if (imagePath) {
        return imageNameMutable;
    } else {
        imagePath = [[NSBundle mainBundle] pathForResource:[imageNameMutable stringByAppendingString :@"@2x"] ofType:@"png"];
        if (imagePath) {
            return imageNameMutable;
        } else {
            imagePath = [[NSBundle mainBundle] pathForResource:[imageNameMutable stringByAppendingString :@"@3x"] ofType:@"png"];
            if (imagePath) {
                return imageNameMutable;
            } else {
                imagePath = [[NSBundle mainBundle] pathForResource:[imageNameMutable stringByAppendingString :@"@4x"] ofType:@"png"];
                if (imagePath) {
                    return imageNameMutable;
                }
            }
        }
    }
    return imageName;
}

+ (NSMutableString *)clearedImageName:(NSString *)imageName
{
    //imageName = [imageName stringByDeletingPathExtension];
    NSMutableString *imageNameMutable = [[imageName mutableCopy] autorelease];
    
    //Delete png extension
    NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
    if (extension.location != NSNotFound) {
        [imageNameMutable deleteCharactersInRange:extension];
    }
    [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
    [imageNameMutable replaceOccurrencesOfString:@"@3x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
    [imageNameMutable replaceOccurrencesOfString:@"@4x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
    return imageNameMutable;
}

+ (void) tryRenameWith: (NSString*) text imageNameMutable: (NSMutableString *) imageNameMutable
{
    NSUInteger position = imageNameMutable.length;

    /*NSRange retinaAtSymbol = [imageNameMutable rangeOfString:@"@2x"];
    if (retinaAtSymbol.location == NSNotFound) {
        retinaAtSymbol = [imageNameMutable rangeOfString:@"@3x"];

        [imageNameMutable appendFormat:@"%@@2x", text];
    } else {
        position = retinaAtSymbol.location;
    }*/
    [imageNameMutable insertString: text atIndex: position];
}

+ (NSString *)renameImageNameForH568:(NSString *)imageName
{
    return [self renameImageNameForH: imageName h: @"-568h"];
}

+ (NSString *)renameImageNameForH: (NSString *)imageName
                                h: (NSString*) h
{
    NSMutableString *imageNameMutable = [self clearedImageName: imageName];
    [self tryRenameWith: h imageNameMutable: imageNameMutable];
    return [self renameImageName: imageName imageNameMutable: imageNameMutable];
}

+ (NSString *) imageNameForH:(NSString *)imageName
                    variants: (NSArray*) variants
{
    if (!variants || variants.count < 1) {
        return imageName;
    }
    NSString * h = variants[0];
    NSString * result = [self renameImageNameForH: imageName h: h];
    if (result == imageName && variants.count > 1) {
        return [self imageNameForH: imageName
                          variants: [variants subarrayWithRange: NSMakeRange(1, variants.count - 1)]];
    }
    return result;
}

+ (NSString *)renameImageNameForH:(NSString *)imageName {
    NSString * result = imageName;
    if (IS_568) {
        return [self imageNameForH: imageName variants: [self addIos7VariantsTo: @[@"-568h"]]];
    } else if (IS_667) {
        return [self imageNameForH: imageName variants: [self addIos7VariantsTo: @[@"-667h", @"-568h"]]];
    }  else if (IS_736) {
        return [self imageNameForH: imageName variants: [self addIos7VariantsTo: @[@"-736h", @"-667h", @"-568h"]]];
    }
    return result;
}

+ (NSString *)renameImageNameForIos7:(NSString *)imageName {
    return [self renameImageNameForH: imageName h: @"-ios7"];
}

+ (NSString *)renameImageNameForH568andIos7:(NSString *)imageName {
    return [self imageNameForH: imageName variants: @[@"-ios7-568h", @"-568h-ios7", @"-ios7", @"-568h"]];
}

+ (NSArray *) addIos7VariantsTo: (NSArray*) variants
{
    NSMutableArray * result = [NSMutableArray arrayWithCapacity: variants.count * 3 + 1];
    for (NSString * variant in variants){
        [result addObject: [NSString stringWithFormat: @"-ios7%@", variant]];
        [result addObject: [NSString stringWithFormat: @"%@-ios7", variant]];
        [result addObject: variant];
    }
    [result addObject: @"-ios7"];
    return result;
}

@end

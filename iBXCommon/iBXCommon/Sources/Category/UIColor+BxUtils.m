/**
 *	@file UIColor+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для UIColor
 *	@date 30.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "UIColor+BxUtils.h"

@implementation UIColor (BxUtils)

+ (id) colorWithHex: (UInt32) rgbValue alpha: (float) alpha
{
    return [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16))/255.0f
                           green: ((float)((rgbValue & 0xFF00) >> 8))/255.0f
                            blue: ((float)(rgbValue & 0xFF))/255.0f
                           alpha: alpha];
}

+ (id) colorWithHex: (UInt32) rgbValue
{
    return [self colorWithHex: rgbValue alpha: 1.0f];
}

+ (id) colorFromHexString: (NSString*) hexString alpha: (float) alpha
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString: hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt: &rgbValue];
    return [UIColor colorWithRed: ((rgbValue & 0xFF0000) >> 16)/255.0f
                           green: ((rgbValue & 0xFF00) >> 8)/255.0f
                            blue: (rgbValue & 0xFF)/255.0f
                           alpha: alpha];
}

+ (id) colorFromHexString: (NSString*) hexString
{
    return [self colorFromHexString: hexString alpha: 1.0f];
}

@end

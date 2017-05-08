/**
 *	@file UIColor+BxUtils.h
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

#import <UIKit/UIKit.h>

@interface UIColor (BxUtils)

+ (nonnull instancetype) colorWithHex: (UInt32) rgbValue alpha: (float) alpha;
+ (nonnull instancetype) colorWithHex: (UInt32) rgbValue;
+ (nonnull instancetype) colorFromHexString: (NSString*) hexString  alpha: (float) alpha;
+ (nonnull instancetype) colorFromHexString: (NSString*) hexString;

@end

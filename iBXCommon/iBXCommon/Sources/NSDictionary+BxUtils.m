/**
 *	@file NSDictionary+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для NSDictionary
 *	@date 03.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSDictionary+BxUtils.h"
#import "NSString+BxUtils.h"

@implementation NSDictionary (BxUtils)

- (NSString*) xFormsString
{
    NSMutableString * result = [NSMutableString stringWithString: @""];
    [result addToXFormsPath: nil fromObject: self];
    return result;
}

@end

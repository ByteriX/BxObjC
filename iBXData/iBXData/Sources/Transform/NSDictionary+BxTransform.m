/**
 *	@file NSDictionary+BxTransformDate.m
 *	@namespace iBXData
 *
 *	@details NSDictionary категория конвертации данных
 *	@date 25.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSDictionary+BxTransform.h"

@implementation NSDictionary (BxTransform)

- (NSString*) notNullString
{
    return @"";
}

- (float) notNullFloat
{
    return 0.0f;
}

- (double) notNullDouble
{
    return 0.0;
}

- (int) notNullInt
{
    return 0.0;
}

- (BOOL) notNullBool
{
    return NO;
}

- (NSArray*) notNullArray
{
    return [self allValues];
}

- (NSDictionary*) notNullDictionary
{
    return self;
}

- (BOOL) isNotNil
{
    return YES;
}

@end

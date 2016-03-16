/**
 *	@file NSArray+BxTransformDate.m
 *	@namespace iBXData
 *
 *	@details NSArray категория конвертации данных
 *	@date 25.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSArray+BxTransform.h"

@implementation NSArray (BxTransform)

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
    return 0;
}

- (BOOL) notNullBool
{
    return NO;
}

- (NSDictionary*) notNullDictionary
{
    return nil;
}

- (NSArray*) notNullArray
{
    return self;
}

- (BOOL) isNotNil
{
    return YES;
}

@end

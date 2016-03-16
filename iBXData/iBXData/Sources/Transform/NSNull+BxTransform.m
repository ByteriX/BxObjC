/**
 *	@file NSNull+BxTransform.m
 *	@namespace iBXData
 *
 *	@details NSNull категория конвертации данных
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSNull+BxTransform.h"

@implementation NSNull(BxTransform)

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

- (BOOL) isNotNil
{
    return NO;
}

- (NSArray*) notNullArray
{
    return nil;
}

- (NSDictionary*) notNullDictionary
{
    return nil;
}

@end

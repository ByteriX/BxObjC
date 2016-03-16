/**
 *	@file NSNumber+BxTransform.m
 *	@namespace iBXData
 *
 *	@details NSNumber категория конвертации данных
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSNumber+BxTransform.h"

@implementation NSNumber(BxTransform)

- (NSString*) notNullString
{
    return [self stringValue];
}

- (float) notNullFloat
{
    return [self floatValue];
}

- (double) notNullDouble
{
    return [self doubleValue];
}

- (int) notNullInt
{
    return [self intValue];
}

- (BOOL) notNullBool
{
    return [self boolValue];
}

- (NSArray*) notNullArray
{
    return nil;
}

- (NSDictionary*) notNullDictionary
{
    return nil;
}

- (BOOL) isNotNil
{
    return YES;
}

@end

/**
 *	@file NSString+BxTransform.m
 *	@namespace iBXData
 *
 *	@details NSString категория конвертации данных
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSString+BxTransform.h"

@implementation NSString(BxTransform)

- (NSString*) notNullString
{
    return self;
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

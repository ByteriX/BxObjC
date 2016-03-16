/**
 *	@file BxJsonKitDataParser.m
 *	@namespace iBXData
 *
 *	@details JSON сериализатор/дисериализатор
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxJsonKitDataParser.h"

@implementation BxJsonKitDataParser

//! @overload
- (NSDictionary*) dataFromData: (NSData*) data
{
    NSError * error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    if (error){
        @throw [BxParserException exceptionWith: error];
    }
	return result;
}

//! @overload
- (NSData*) serializationData: (NSDictionary*) data
{
    NSError * error = nil;
	NSData * result = [NSJSONSerialization dataWithJSONObject: data options: NSJSONWritingPrettyPrinted error: &error];
    if (error){
        @throw [BxParserException exceptionWith: error];
    }
    return result;
}

@end

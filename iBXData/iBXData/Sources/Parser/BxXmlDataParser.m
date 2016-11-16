/**
 *	@file BxXmlDataParser.m
 *	@namespace iBXData
 *
 *	@details XML сериализатор/дисериализатор
 *	@date 27.08.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxXmlDataParser.h"
#import <XMLDictionary/XMLDictionary.h>

@implementation BxXmlDataParser

//! @overload
- (NSDictionary*) dataFromString: (NSString*) string
{
    NSDictionary *result0 = nil;
    
	@try {
        result0 = [[XMLDictionaryParser sharedInstance] dictionaryWithString: string];
    }
    @catch (NSException *exception) {
        [BxParserException raise: [exception name] format: [exception reason], nil];
    }
	return result0;
}

//! @overload
- (NSDictionary*) dataFromData: (NSData*) data
{
    NSDictionary *result0 = nil;
	@try {
        result0 = [[XMLDictionaryParser sharedInstance] dictionaryWithData: data];
    }
    @catch (NSException *exception) {
        [BxParserException raise: [exception name] format: [exception reason], nil];
    }
	return result0;
}

//! @overload
- (NSString*) getStringFrom: (NSDictionary*) data
{
    NSString * jsonString = nil;
    
    @try {
        jsonString = [data XMLString];
    }
    @catch (NSException *exception) {
        [BxParserException raise: [exception name] format: [exception reason], nil];
    }
	return jsonString;
}

//! @overload
- (NSData*) serializationData: (NSDictionary*) data
{
    // Неверное формирование данных по кодировке!!!
	return [[data XMLString] dataUsingEncoding: NSUTF8StringEncoding];
}

@end

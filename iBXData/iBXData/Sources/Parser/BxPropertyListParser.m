/**
 *	@file BxPropertyListParser.m
 *	@namespace iBXData
 *
 *	@details PList сериализатор/дисериализатор
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxPropertyListParser.h"

@implementation BxPropertyListParser

//! @overload
- (NSDictionary*) dataFromData: (NSData*) data
{
    if (!data) {
        [BxParserException raise: @"NotParsePListException" format: @"Empty Data", nil];
        return nil;
    }
    NSError *error = nil;
    NSPropertyListFormat format;
    id pList = [NSPropertyListSerialization propertyListWithData: data
                                                         options: NSPropertyListMutableContainersAndLeaves
                                                          format: &format error: &error];
    if (error) {
        @throw [BxParserException exceptionWith: [error autorelease]];
    }
    return pList;
}

//! @overload
- (NSData*) serializationData: (NSDictionary*) data
{
    NSError *error;
    NSData *pData = [NSPropertyListSerialization dataWithPropertyList: data
                                                               format: NSPropertyListBinaryFormat_v1_0
                                                              options: 0
                                                                error: &error];
    if (!pData) {
        NSLog(@"%@", error);
        @throw [BxParserException exceptionWith: [error autorelease]];
        return NO;
    }
	return pData;
}

@end

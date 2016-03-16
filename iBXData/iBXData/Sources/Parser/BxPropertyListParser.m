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
    NSString *error = nil;
    NSPropertyListFormat format;
    id pList = [NSPropertyListSerialization propertyListFromData: data
                                             mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                       format: &format errorDescription: &error];
    if (error) {
        [BxParserException raise: @"NotParsePListException" format: error, nil];
    }
    return pList;
}

//! @overload
- (NSData*) serializationData: (NSDictionary*) data
{
    NSString *error;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList: data
                                                               format: NSPropertyListBinaryFormat_v1_0
                                                     errorDescription: &error];
    if (!pData) {
        NSLog(@"%@", error);
        [BxParserException raise: @"NotSerializePListException" format: error, nil];
        return NO;
    }
	return pData;
}

@end

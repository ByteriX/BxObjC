/**
 *	@file BxRssDataParser.h
 *	@namespace iBXData
 *
 *	@details RSS сериализатор/дисериализатор
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataParser.h"

//! RSS сериализатор/дисериализатор
@interface BxRssDataParser : BxAbstractDataParser <NSXMLParserDelegate> {
    NSMutableDictionary * _item;
    NSString * _url;
}

- (void) addContent: (NSString *)string forTag: (NSString*) localtagName;

@end

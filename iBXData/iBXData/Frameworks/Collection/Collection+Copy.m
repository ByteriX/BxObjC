/**
 *	@file Collection+Copy.m
 *	@namespace iBXData
 *
 *	@details Копирование коллекций
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "Collection+Copy.h"

@implementation NSArray (Copy)

- (NSMutableArray*) getInstanceCopy
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: self.count];
    for (NSObject * obj in self) {
        if ([obj isKindOfClass: NSMutableDictionary.class]) {
            [result addObject: [(NSDictionary*)obj getInstanceCopy]];
        } else if ([obj isKindOfClass: NSMutableArray.class]) {
            [result addObject: [(NSArray*)obj getInstanceCopy]];
        } else {
            [result addObject: [[obj copy] autorelease]];
        }
    }
    return result;
}

@end

@implementation NSDictionary (Copy)

- (NSMutableDictionary*) getInstanceCopy
{
    NSArray * keys = [self allKeys];
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity: keys.count];
    for (id key in keys) {
        id obj = [self objectForKey: key];
        if ([obj isKindOfClass: NSMutableDictionary.class]) {
            [result setObject: [(NSDictionary*)obj getInstanceCopy] forKey: key];
        } else if ([obj isKindOfClass: NSMutableArray.class]) {
            [result setObject: [(NSArray*)obj getInstanceCopy] forKey: key];
        } else {
            [result setObject: [[obj copy] autorelease] forKey: key];
        }
    }
    return result;
}

@end

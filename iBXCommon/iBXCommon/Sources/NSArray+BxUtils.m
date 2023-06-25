/**
 *	@file NSArray+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для NSArray
 *	@date 09.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSArray+BxUtils.h"
#import "NSString+BxUtils.h"

@implementation NSArray (BxUtils)

- (NSString*) xFormsString
{
    NSMutableString * result = [NSMutableString stringWithString: @""];
    [result addToXFormsPath: nil fromObject: self];
    return result;
}

- (NSArray*) arrayByTransformHandler: (BxArrayTransformFromDictionaryHandler) transformHandler
{
    NSMutableArray * result = [NSMutableArray arrayWithCapacity: self.count];
    for (NSDictionary * item in self) {
        if ([item isKindOfClass: NSDictionary.class]) {
            [result addObject: transformHandler(item)];
        }
    }
    return result;
}

@end

@implementation NSMutableArray (BxUtils)

- (void) transformHandler: (BxArrayTransformFromDictionaryHandler) transformHandler
{
    NSUInteger index = 0;
    for (NSDictionary * item in self) {
        if ([item isKindOfClass: NSDictionary.class]){
            [self replaceObjectAtIndex: index withObject: transformHandler(item)];
        }
        index++;
    }
}

@end

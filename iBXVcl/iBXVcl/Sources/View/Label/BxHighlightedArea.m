/**
 *	@file BxHighlightedArea.m
 *	@namespace iBXVcl
 *
 *	@details Область выделения текста
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxHighlightedArea.h"
#import "BxCommon.h"


@implementation BxHighlightedArea

- (NSString*) description
{
    return [NSString stringWithFormat: @"HighlightedArea(pos = %lu, len = %lu)", (unsigned long)_position, (unsigned long)_length];
}

- (NSComparisonResult)comparePosition:(BxHighlightedArea *)otherObject 
{
    NSComparisonResult result = NSOrderedSame;
    if (self.position < otherObject.position) {
        result = NSOrderedAscending;
    } else if (self.position > otherObject.position) {
        result = NSOrderedDescending;
    }
    return result;
}

+ (NSArray *) areasFromText: (NSString*) text
              highlightText: (NSString*) highlightText 
              highlightType: (HighlightType) highlightType
{
    if (highlightText && highlightText.length > 0) {
		NSMutableArray * result = [NSMutableArray array];
		static NSStringCompareOptions options = NSCaseInsensitiveSearch;
		NSRange localRange = NSMakeRange(0, text.length);
		do { 
			NSRange range = [text rangeOfString: highlightText options: options 
                                          range: localRange];
			if (range.length > 0) {
				localRange = NSMakeRange(range.location + range.length, 
										 text.length - range.location - range.length);
				BxHighlightedArea * area = [[self.class alloc] initWithPosition: range.location length: range.length];
                area.type = highlightType;
				[result addObject: area];
				[area release];
			} else {
				break;
			}
		} while (YES);
		return result;
	} else {
		return nil;
	}
}

+ (NSArray *) margedAareasFromFirst: (NSArray*) firstArray second: (NSArray*) secondArray
{
    NSMutableArray * secondArrayCopy = [NSMutableArray arrayWithCapacity: secondArray.count];
    for (BxHighlightedArea * area in secondArray) {
        BxHighlightedArea * newArea = [area copy];
        [secondArrayCopy addObject: newArea];
        [newArea release];
    }
    NSMutableArray * result = [NSMutableArray arrayWithCapacity: firstArray.count + secondArray.count + 4];
    for (BxHighlightedArea * area in firstArray) {
        BOOL isAdd = NO;
		for (BxHighlightedArea * newArea in secondArrayCopy) {
            BxHighlightedArea * intersection = [newArea intersectionWith: area];
            if ( intersection ) {
                if (area.position < intersection.position) {
                    BxHighlightedArea * item = [area copy];
                    item.length = intersection.position - area.position;
                    [result addObject: item];
                    [item release];
                    newArea.length = 0;
                } else if (newArea.position < intersection.position) {
                    BxHighlightedArea * item = [newArea copy];
                    item.length = intersection.position - newArea.position;
                    [result addObject: item];
                    [item release];
                }
                [result addObject: intersection];
                if (area.position + area.length > intersection.position + intersection.length) {
                    BxHighlightedArea * item = [area copy];
                    item.position = intersection.position + intersection.length;
                    item.length = area.position + area.length - item.position;
                    [result addObject: item];
                    [item release];
                    newArea.length = 0;
                } else if (newArea.position + newArea.length > intersection.position + intersection.length) {
                    NSUInteger position = intersection.position + intersection.length;
                    newArea.length = newArea.position + newArea.length - position;
                    newArea.position = position;
                } else {
                    newArea.length = 0;
                }
                isAdd = YES;
            } else {
                if (newArea.position + newArea.length < area.position) {
                    if (newArea.length > 0){
                        BxHighlightedArea * temp = [newArea copy];
                        [result addObject: temp];
                        [temp release];
                        newArea.length = 0;
                    }
                }
            }
            if (!isAdd) {
                [result addObject: area];
            }
		}
    }
    for (BxHighlightedArea * newArea in secondArrayCopy) {
        if (newArea.length > 0){
            [result addObject: newArea];
        }
    }
    return result;
}

- (id) initWithPosition: (NSUInteger) position
				 length: (NSUInteger) length
{
    self = [self init];
	if ( self ) {
		self.position = position;
		self.length = length;
        self.type = HighlightTypeNone;
        self.isAreaInFocus = NO;
	}
	return self;
}

- (BxHighlightedArea*) intersectionWith: (BxHighlightedArea*) area
{
	NSRange range = NSIntersectionRange(area.range, self.range);
	if (range.length == 0) {
		return nil;
	} else {
        BxHighlightedArea * result = [self copy];
        result.position = range.location;
        result.length = range.length;
        result.type = result.type | area.type;
        return [result autorelease];
	}
}

- (id) copyWithZone: (NSZone *) zone
{
	BxHighlightedArea * copyObject = [[self.class allocWithZone: zone] initWithPosition: self.position
                                                                      length: self.length];
    copyObject.type = self.type;
    copyObject.isAreaInFocus = self.isAreaInFocus;
	return copyObject;
}

- (NSRange) range
{
	return NSMakeRange(self.position, self.length);
}

- (BOOL) onExclusiveClick: (id) sender
{
    return NO;
}

@end

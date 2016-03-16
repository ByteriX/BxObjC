/**
 *	@file BxHighlightedTagLabel.m
 *	@namespace iBXVcl
 *
 *	@details Отображение текста с выделенным текстом внутри тега.
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxHighlightedTagLabel.h"


@implementation BxHighlightedTagLabel

+ (NSString*) extractTagsWithText: (NSString*) text1
                            areas: (NSMutableArray*) areas
                         startTag: (NSString*) startTag
                          stopTag: (NSString*) stopTag
                             type: (HighlightType) type
{
    NSString * temp = text1;
	NSRange range = [temp rangeOfString: startTag];
	while (range.length > 0) {
		temp = [[temp substringToIndex: range.location] stringByAppendingString: [temp substringFromIndex: range.location + range.length]];
		NSRange stopRange = [temp rangeOfString: stopTag];
		BxHighlightedArea * area = [[BxHighlightedArea alloc] initWithPosition: range.location
                                                                        length: stopRange.location - range.location];
        area.type = type;
		temp = [[temp substringToIndex: stopRange.location] stringByAppendingString: [temp substringFromIndex: stopRange.location + stopRange.length]];
		[areas addObject: area];
		[area release];
		range = [temp rangeOfString: startTag];
		
	}
    return temp;
}

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
			startTag: (NSString*) startTag 
			 stopTag: (NSString*) stopTag
{
	
	NSMutableArray * areas = [NSMutableArray array];
	NSString * temp = [self.class extractTagsWithText: text areas: areas startTag: startTag stopTag: stopTag type: HighlightTypeMarked];
	return [self initWithWidth: labelWidth
                      position: position 
                          font: font
                          text: temp 
                         areas: areas
                     markColor: [UIColor yellowColor]]; 
}

- (id) initWithWidth: (CGFloat) labelWidth
			position: (CGPoint) position
				font: (UIFont*) font
            markfont: (UIFont*) markfont
				text: (NSString*) text
			startTag: (NSString*) startTag
			 stopTag: (NSString*) stopTag
{
	
	NSMutableArray * areas = [NSMutableArray array];
	NSString * temp = [self.class extractTagsWithText: text areas: areas startTag: startTag stopTag: stopTag type: HighlightTypeColor];
	self = [self initWithWidth: labelWidth
                      position: position
                          font: font
                          text: temp
                         areas: areas
                     markColor: [UIColor clearColor]];
    self.highlightedFont = markfont;
    return self;
}


@end

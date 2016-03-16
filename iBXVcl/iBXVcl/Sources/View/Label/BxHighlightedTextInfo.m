/**
 *	@file BxHighlightedTextInfo.m
 *	@namespace iBXVcl
 *
 *	@details Информация об подцвечиваемой части текста
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxHighlightedTextInfo.h"


@implementation BxHighlightedTextInfo

- (id) initWithText: (NSString*) text
{
    self = [self init];
	if ( self ) {
		self.text = text;
	}
	return self;
}

- (id) copyWithZone: (NSZone*) zone
{
	BxHighlightedTextInfo * copyObject = [[self.class allocWithZone: zone] initWithText: self.text];
	copyObject.levelIndex = self.levelIndex;
    BxHighlightedArea * copyArea = [self.area copyWithZone: zone];
	copyObject.area = copyArea;
    [copyArea release];
	copyObject.x = self.x;
	copyObject.width = self.width;
	return copyObject;
}

- (void) dealloc
{
	self.area = nil;
	self.text = nil;
	[super dealloc];
}

- (NSString *)debugDescription
{
    return  [self description];
}

- (NSString*) description
{
    return [NSString stringWithFormat: @"text: %@\rlevelIndex: %d\rarea: %@\rRange:[%f,%f]", self.text, self.levelIndex, self.area, (double)self.x, (double)self.width];
}

@end

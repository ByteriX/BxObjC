/**
 *	@file BxEventDataCommand.m
 *	@namespace iBXData
 *
 *	@details Команда, делегирующая событие
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxEventDataCommand.h"

@implementation BxEventDataCommand

- (id) initWithTarget: (NSObject*) terget selector: (SEL) selector
{
    self = [self init];
	if ( self ) {
		if (terget) {
			_target = [terget retain];
		} else {
			_target = nil;
		}
		_selector = selector;
	}
	return self;
}

- (void) execute
{
	[_target performSelector: _selector withObject: self];
}

- (void) dealloc
{
	[_target autorelease];
    _target = nil;
	[super dealloc];
}

@end

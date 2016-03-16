/**
 *	@file BxEventDataCommand.h
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

#import "BxAbstractDataCommand.h"

//! Команда, делегирующая событие
@interface BxEventDataCommand : BxAbstractDataCommand {
@protected
	NSObject * _target;
	SEL _selector;
}

- (id) initWithTarget: (NSObject*) terget selector: (SEL) selector;

@end

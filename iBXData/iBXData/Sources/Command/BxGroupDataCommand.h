/**
 *	@file BxGroupDataCommand.h
 *	@namespace iBXData
 *
 *	@details Команда, выполняющая несколько команд последовательно
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataCommand.h"

@class BxQueueDataCommand;

//! Команда, выполняющая несколько команд последовательно
@interface BxGroupDataCommand : BxAbstractDataCommand {
@protected
	NSMutableArray * _commands;
	NSString * _caption;
	BxQueueDataCommand * _queue;
}

- (id) initWithQueue: (BxQueueDataCommand*) queue caption: (NSString*) caption;

- (void) addCommand: (BxAbstractDataCommand*) command;

@end
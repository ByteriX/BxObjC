/**
 *	@file BxQueueDataCommand.h
 *	@namespace iBXData
 *
 *	@details Очередь исполнения команд
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxGroupDataCommand.h"

//! Очередь исполнения команд
@interface BxQueueDataCommand : BxGroupDataCommand {
@protected
	NSMutableDictionary * _registrationCommands;
	NSCondition * _condition;
	NSLock * _lockCommands;
	BOOL _isExecuted;
    BOOL _isPause;
}

- (BxAbstractDataCommand*) objectForData: (NSDictionary*) data;

- (void) update;

- (void) registryCommandClass: (Class) dataCommandClass;

- (void) start;

- (void) pause;

- (void) resume;

/**
 *	Запускает очередь с ожиданием исполнения,
 *	поскольку может останавливать основной поток,
 *	вызов данного метода из основного потока приведет к deadlock
 *	Смысла вызывать его никакого нет, проще execute у команды
 */
- (void) startAndWait;

- (void) removeCommand: (BxAbstractDataCommand*) command;

@end

@interface BxQueueDataCommand (private)

- (void) errorFromCommand: (BxAbstractDataCommand *) command exception: (NSException *) exception;

@end
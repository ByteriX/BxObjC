/**
 *	@file BxQueueDataCommand.m
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

#import "BxQueueDataCommand.h"
#import "BxCommon.h"

@implementation BxQueueDataCommand

- (id) init
{
    self = [super init];
	if (self) {
		_queue = [self retain];
		_registrationCommands = [[NSMutableDictionary alloc] init];
		_condition = [[NSCondition alloc] init];
		[self registryCommandClass: BxGroupDataCommand.class];
		_isExecuted = NO;
		_lockCommands = [[NSLock alloc] init];
	}
	return self;
}

- (void) addCommand: (BxAbstractDataCommand*) command
{
	[_lockCommands lock];
	@try {
		[_commands addObject: command];
	}
	@finally {
		[_lockCommands unlock];
	}
	[self update];
	/*if (!isExecuted) {
	 [self start];
	 }*/
}

- (void) loadFromData: (NSMutableDictionary*) data
{
	[_lockCommands lock];
	@try {
		[super loadFromData: data];
	}
	@finally {
		[_lockCommands unlock];
	}
}

- (NSMutableDictionary*) saveToData
{
	NSMutableDictionary * data = nil;
	[_lockCommands lock];
	@try {
		data = [super saveToData];
	}
	@finally {
		[_lockCommands unlock];
	}
	return data;
}

- (void) startWithWait: (BOOL) isWait
{
	//[_condition broadcast];
	[_condition lock];
    
    if (!_isExecuted) {
		_isExecuted = YES;
        
        [NSThread detachNewThreadSelector: @selector (execute) toTarget: self withObject: nil];
        if (isWait) {
            [_condition wait];
        }
    }
	
	[_condition unlock];
}

- (void) start
{
	[self startWithWait: NO];
}

- (void) startAndWait
{
	[self startWithWait: YES];
}

- (void) pause
{
    [_condition lock];
    _isPause = YES;
    [_condition unlock];
}

- (void) resume
{
    [_condition lock];
    _isPause = NO;
    [_condition unlock];
}

- (BOOL) checkPause
{
    [_condition lock];
    BOOL isPaused = _isPause;
    [_condition unlock];
    if (isPaused) {
        [NSThread sleepForTimeInterval: 1.0];
    }
    return isPaused;
}

- (void) errorFromCommand: (BxAbstractDataCommand *) command exception: (NSException *) exception
{
	if ([exception isKindOfClass: BxException.class]) {
        NSLog(@"Произошла ошибка при выполнении операции: %@", exception);
	} else {
        NSLog(@"Произошла неизвестная ошибка при выполнении операции");
	}
}

- (void) removeCommand: (BxAbstractDataCommand*) command
{
    [_lockCommands lock];
    @try {
        [_commands removeObjectIdenticalTo: command];
    }
    @finally {
        [_lockCommands unlock];
    }
}

- (void) execute
{
    int index = 0;
    while (index < _commands.count) {
        
        if ([self checkPause]) {
            continue;
        }
        
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        [_lockCommands lock];
        BxAbstractDataCommand * command = _commands[index];
        [_lockCommands unlock];
        @try {
            [command execute];
            [self removeCommand: command];
            [self update];
        }
        @catch (NSException * e) {
            [self errorFromCommand: command exception: e];
            index++;
        }
        @finally {
            [pool release];
        }
    }
    
	[_condition lock];
    _isExecuted = NO;
	[_condition signal];
	[_condition unlock];
}

- (void) update
{
	//
}

- (void) registryCommandClass: (Class) dataCommandClass
{
	BxAbstractDataCommand * command = [[dataCommandClass alloc] init];
	NSString * name = [NSString stringWithString: command.name];
	[command release];
	if ([_registrationCommands objectForKey: name]){
		[BxException raise: @"RegistrationException"
						 format: @"This command with name %@ is registred double for queue", name, nil];
	}
	[_registrationCommands setObject: dataCommandClass forKey: name];
}

- (BxAbstractDataCommand*) objectForData: (NSDictionary*) data
{
	NSObject * item = _registrationCommands[data[FNDataCommandName]];
	if (item) {
		Class class = (Class)item;
		BxAbstractDataCommand* result = [[[class alloc] init] autorelease];
		[result loadFromData: (NSMutableDictionary*)data];
		return result;
	} else {
		[BxException raise: @"NotRegistrationException"
						 format: @"This command with name %@ is not supported for queue",
		 [data objectForKey: FNDataCommandName], nil];
	}
	return nil;
}

- (void) dealloc
{
	[_lockCommands autorelease];
    _lockCommands = nil;
	[_registrationCommands autorelease];
    _registrationCommands = nil;
	[_condition autorelease];
    _condition = nil;
	[super dealloc];
}

@end

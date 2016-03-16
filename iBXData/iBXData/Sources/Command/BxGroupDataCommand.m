/**
 *	@file BxGroupDataCommand.m
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

#import "BxGroupDataCommand.h"
#import "BxQueueDataCommand.h"

static NSString const* FNGroupCommands = @"commands";

@implementation BxGroupDataCommand

- (id) init
{
	if (self = [super init]) {
		_queue = nil;
		_commands = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) initWithQueue: (BxQueueDataCommand*) queue caption: (NSString*) caption
{
	if (self = [self init]) {
		if (_queue) {
			_queue = [queue retain];
		}
		_caption = [caption retain];
	}
	return self;
}

//! @override
- (NSString*) getName
{
	return @"GroupDataCommand";
}

//! @override
- (NSString*) getCaption
{
	return _caption;
}

- (void) addCommand: (BxAbstractDataCommand*) command
{
	[_commands addObject: command];
	/*if (_queue) {
        [_queue update];
     }*/ //влезшие команды в пролете
}

- (NSMutableDictionary*) saveToData
{
	NSMutableArray * result = [NSMutableArray arrayWithCapacity: _commands.count];
	for (BxAbstractDataCommand * command in _commands) {
		NSMutableDictionary * data = [command saveToData];
		[data setObject: command.name forKey: FNDataCommandName];
		[result addObject: data];
	}
	return [NSMutableDictionary dictionaryWithObject: result forKey: FNGroupCommands];
}

- (void) loadFromData: (NSMutableDictionary*) data
{
	[_commands removeAllObjects];
	NSArray * rawCommands = [data objectForKey: FNGroupCommands];
	for (NSDictionary * commandData in rawCommands) {
		BxAbstractDataCommand * command = [_queue objectForData: commandData];
		[_commands addObject: command];
	}
}

- (void) execute
{
	int index = 0;
	for (BxAbstractDataCommand * command in _commands) {
		if (index > 0) {
			[command updateFrom: _commands[index - 1]];
		}
		[command execute];
		index++;
	}
}

- (void) dealloc
{
	[_caption autorelease];
    _caption = nil;
	[_queue autorelease];
    _queue = nil;
	[_commands autorelease];
    _commands = nil;
	[super dealloc];
}

@end

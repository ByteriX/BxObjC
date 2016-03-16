/**
 *	@file BxJsonServiceDataCommand.m
 *	@namespace iBXData
 *
 *	@details Команда, выполняющая действие на сервере на языке JSON
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxJsonServiceDataCommand.h"
#import "BxData.h"

@implementation BxJsonServiceDataCommand

//! @override
- (id) init
{
    self = [super init];
	if (self) {
		self.parser = [[[BxJsonKitDataParser alloc] init] autorelease];
	}
	return self;
}

//! @override
- (NSString*) getName
{
	return @"JsonServiceDataCommand";
}

- (void) updateRequest: (NSMutableURLRequest*) request
{
	[super updateRequest: request];
	[request setValue: @"text/json" forHTTPHeaderField: @"Accept"];
	if (_requestBody) {
		[request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
	}
}

@end

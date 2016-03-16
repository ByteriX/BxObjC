/**
 *	@file BxException.m
 *	@namespace iBXCommon
 *
 *	@details Исключения
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxException.h"

@implementation BxException

- (NSString*) getReason
{
	return [_error localizedFailureReason];
}

+ (id) exceptionWith: (NSError *) mainError
{
	return [[[self.class alloc] initWith: mainError] autorelease] ;
}

- (id) initWith: (NSError *) mainError{
	self = [self initWithName: [self getReason]
					   reason: [mainError localizedDescription]
					 userInfo: nil];
	if (self){
		self.error = mainError;
	}
	return self;
}

- (void) dealloc
{
    self.error = nil;
    [super dealloc];
}

@end

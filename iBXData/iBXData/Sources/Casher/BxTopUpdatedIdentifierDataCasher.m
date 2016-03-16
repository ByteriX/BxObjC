/**
 *	@file BxTopUpdatedIdentifierDataCasher.m
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору и удаление устаревших, востребует необновленный кеш
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxTopUpdatedIdentifierDataCasher.h"

#define IsNotUpdatedKey @"isNotUpdated"

@implementation BxTopUpdatedIdentifierDataCasher

//! @override
- (NSDictionary *) anywayLoadData
{
	return [super loadData];
}

//! @override
- (NSDictionary *) loadData
{
	NSDictionary * data = [super loadData];
	if ([data objectForKey: IsNotUpdatedKey]) {
		data = nil;
	}
	return data;
}

//! @override
- (void) saveData: (NSDictionary *) data
{
	//надо отметить о свежести данных
	if ([data isKindOfClass: NSMutableDictionary.class]) {
        
        if (data[IsNotUpdatedKey]){
            NSLog(@"is Updated cash in UpdatedIdentifierDataCasher");
            [(NSMutableDictionary *)data removeObjectForKey: IsNotUpdatedKey];
        }
        
	}
	[super saveData: data];
}

- (NSDictionary *) setNotUpdatedWithIdentifier: (NSString*) value
{
	self.identifier = value;
	NSMutableDictionary * data = (NSMutableDictionary *)[super loadData];
	if (data) {
		[data setObject: @"" forKey: IsNotUpdatedKey];
		[super saveData: data];
        return data;
	} else {
        return nil;
    }
}

@end

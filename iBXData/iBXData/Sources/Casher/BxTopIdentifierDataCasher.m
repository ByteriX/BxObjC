/**
 *	@file BxTopIdentifierDataCasher.m
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору и удаление устаревших
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxTopIdentifierDataCasher.h"
#import "BxCommon.h"

@implementation BxTopIdentifierDataCasher

- (NSString*) listFilePath
{
	return [_mainFileName stringByAppendingPathComponent: @"list.js"];
}

- (id) initWithFileName: (NSString*) cashedFileName topCount: (int) topCount
{
	self.topCount = topCount;
	if (self = [super initWithFileName: cashedFileName]) {
		[BxFileSystem initDirectories: [[self listFilePath] stringByDeletingLastPathComponent]];
	}
	return self;
}

- (void) clearObjects: (NSMutableArray*) result
{
	while (result.count >= self.topCount) {
		[result removeLastObject];
	}
}

- (NSArray*) addToTopList
{
	NSDictionary* saveData = nil;
	@try {
		saveData = [self.parser loadFromFile: [self listFilePath] ];
	}
	@catch (NSException * e) {
	}
	NSMutableArray * result;
	if (saveData) {
		result = [saveData objectForKey: @"items"];
	} else {
		result = [NSMutableArray array];
		saveData = [NSMutableDictionary dictionaryWithObject: result
													  forKey: @"items"];
	}
	[result insertObject: self.identifier atIndex: 0 ];
	[self.parser saveFrom: saveData toPath: [self listFilePath] ];
	return result;
}

//! @override
- (void) saveData: (NSDictionary *) data
{
	[super saveData: data];
	if (self.identifier) {
		/*NSArray* inList = */[self addToTopList];
		//[self deleteAllNotInIdentifierList: inList]; // каждый раз не будем это делать
	}
}

- (void) clear
{
	NSDictionary* saveData = nil;
	NSMutableArray* result = nil;
	@try {
		saveData = [self.parser loadFromFile: [self listFilePath] ];
		result = [saveData objectForKey: @"items"];
		if (result.count < 1) {
			result = nil;
		}
	}
	@catch (NSException * e) {
	}
	if (result) {
		[self clearObjects: result];
		[self.parser saveFrom: saveData toPath: [self listFilePath] ];
		[self deleteAllNotInIdentifierList: result];
	}
}

@end

/**
 *	@file BxIdentifierDataCasher.m
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxIdentifierDataCasher.h"
#import "BxCommon.h"

@implementation BxIdentifierDataCasher

- (id) initWithFileName: (NSString*) cashedFileName
{
	if (self = [super initWithFileName: cashedFileName]){
		_mainFileName = [_cashedFilePath retain];
		[BxFileSystem initDirectories: [_cashedFilePath stringByDeletingLastPathComponent]];
	}
	return self;
}

- (void) setIdentifier: (NSString*) value{
	if (_identifier){
		[_identifier release];
	}
	if (value){
		_identifier = [[value lowercaseString] retain];
		if (_cashedFilePath){
			[_cashedFilePath release];
		}
		_cashedFilePath = [[_mainFileName stringByAppendingFormat: @"%@",  _identifier, nil] retain];
	} else {
		_identifier = nil;
	}
    
}

- (void) deleteWithIdentifier: (NSString*) value
{
	if (!value)
		return;
	[self setIdentifier: value];
	if ([self cashedFileExist]){
		NSError * error = nil;
		[[NSFileManager defaultManager] removeItemAtPath: _cashedFilePath
												   error: &error];
		if (error) {
			NSLog(@"ERROR in IdentifierDataCasher->deleteWithIdentifier: %@", error.localizedDescription);
		}
	}
	[self setIdentifier: nil];
}

- (void) deleteAll
{
	[self deleteAllNotInIdentifierList: [NSArray array]];
	[super delete];
}

- (void) deleteAllNotInIdentifierList: (NSArray*) list
{
	NSString * mainPath = [_mainFileName stringByDeletingLastPathComponent];
	NSString * patern = [_mainFileName lastPathComponent];
	NSMutableDictionary * setForList = [[NSMutableDictionary alloc] initWithCapacity: list.count];
	NSMutableArray * deletesFieles = nil;
	@try {
		for (NSString * currentIdentifier in list) {
			[setForList setObject: @"!" forKey: currentIdentifier];
		}
		NSError * error = nil;
		NSArray * allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: mainPath
                                                                                 error: &error];
		deletesFieles = [[NSMutableArray alloc] initWithCapacity: allFiles.count];
		
		if (error) {
			NSLog(@"ERROR in IdentifierDataCasher->deleteAllNotInList: %@", error.localizedDescription);
		} else {
			for (NSString * currentFileName in allFiles) {
				NSRange range = [currentFileName rangeOfString: patern];
				if (range.location == 0 && range.length == patern.length) {
					NSString * currentIdentifier = [currentFileName substringFromIndex: patern.length];
					if (![setForList objectForKey: currentIdentifier]) {
						[deletesFieles addObject: currentFileName];
					}
				}
			}
			for (NSString * currentFileName in deletesFieles) {
				NSError * error = nil;
				currentFileName = [mainPath stringByAppendingPathComponent: currentFileName];
				[[NSFileManager defaultManager] contentsOfDirectoryAtPath: currentFileName error: &error];
				if (error) {
					error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath: currentFileName
                                                               error: &error];
				}
				
				if (error) {
					NSLog(@"ERROR in IdentifierDataCasher->deleteAllNotInList: %@ (path: %@)", error.localizedDescription, currentFileName);
				}
			}
		}
	}
	@finally {
		if (deletesFieles) {
			[deletesFieles release];
		}
		[setForList release];
	}
}

- (NSDictionary *) loadData
{
	if (_identifier){
		return [super loadData];
	} else {
		return nil;
	}
}

- (void) saveData: (NSDictionary *) data
{
	if (self.isRefreshing || _identifier) {
		[super saveData: data];
	}
}

- (void) saveDataFromExternal: (NSDictionary *) data
{
	if (_identifier) {
		[super saveData: data];
	}
}

- (void) dealloc
{
	if (_identifier){
		[_identifier autorelease];
        _identifier = nil;
	}
	[_mainFileName autorelease];
    _mainFileName = nil;
	[super dealloc];
}

@end

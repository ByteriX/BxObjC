/**
 *	@file BxDatabase.m
 *	@namespace iBXDB
 *
 *	@details База данных SQLite
 *	@date 05.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDatabase.h"
#import "BxFMDatabaseUnicode.h"
#import "BxCommon.h"
#import "NSURL+BxUtils.h"

@implementation BxDatabase

+ (BxDatabase*) defaultDatabase
{
    static BxDatabase * _default = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _default = [[self allocWithZone: NULL] init];
    });
    return _default;
}

- (void) open
{
    [self.database open];
}

- (id) initWithFileName: (NSString*) fileName
{
    self = [super init];
	if ( self ) {
		_fileName = [fileName retain];
		_database = [[BxFMDatabaseUnicode alloc] initWithPath: [self restore]];
        _includeFromBackup = [[NSURL fileURLWithPath: self.filePath] hasSkipBackupAttribute];
	}
	return self;
}

- (NSString *) getPathForRestore
{
    if ([_fileName isAbsolutePath]){
        return _fileName;
    }
    return [[[BxConfig defaultConfig] documentPath] stringByAppendingPathComponent: _fileName];
}

- (void) setIncludeFromBackup: (BOOL) value
{
    if (value){
        if ([[NSURL fileURLWithPath: self.filePath] addSkipBackupAttribute]){
            _includeFromBackup = value;
        }
    } else {
        if ([[NSURL fileURLWithPath: self.filePath] removeSkipBackupAttribute]){
            _includeFromBackup = value;
        }
    }
}

- (NSString *) getResurcePath{
    return [[NSBundle mainBundle] pathForResource: [[_fileName lastPathComponent] stringByDeletingPathExtension]
                                           ofType: [_fileName pathExtension]];
}

- (NSString*) restore
{
	NSString * path = [self getPathForRestore];
	if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
		NSString * copyPath = [self getResurcePath];
		if (!copyPath){
			[BxAlertView showErrorAndExit: @"Not found database!"];
            return nil;
		}
		NSError * error = nil;
		[[NSFileManager defaultManager] copyItemAtPath: copyPath toPath: path error: &error];
		if (error) {
			[BxAlertView showErrorAndExit: [NSString stringWithFormat: @"Not found database! %@", error]];
		}
        [[NSURL fileURLWithPath: path] addSkipBackupAttribute];
	}
	return path;
}

- (BOOL) executeWith: (NSString*) sql
{
    [_database open];
    return [self.database executeUpdate: sql];
}

- (NSNumber*) executeNumberFunctionWith: (NSString*) sql
{
    [self open];
    BxFMResultSet * result = [self.database executeQuery: sql];
    if (result && [result next]){
        return [NSNumber numberWithLong: [result longForColumnIndex: 0]];
    } else {
        return nil;
    }
}

- (NSArray*) allDataWith: (NSString*) sql
{
    [self open];
    BxFMResultSet * result = [self.database executeQuery: sql];
    NSMutableArray * returnResult = [NSMutableArray array];
    while ([result next]) {
        [returnResult addObject: [result resultDictionary]];
    }
    return returnResult;
}

- (NSString*)lastErrorMessage
{
    return [_database lastErrorMessage];
}

- (void)dealloc {
    [_database close];
	[_database release];
	[_fileName release];
    [super dealloc];
}

@end

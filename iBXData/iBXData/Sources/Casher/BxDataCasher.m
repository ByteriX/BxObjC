/**
 *	@file BxDataCasher.m
 *	@namespace iBXData
 *
 *	@details Кеширование данных
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDataCasher.h"
#import "BxCommon.h"

@implementation BxDataCasher

+ (NSString*) defaultDir
{
    return @"cashed_data";
}

//! Каталог, в который будет сохраняться кеш
- (NSString*) defaultDir
{
	return [self.class defaultDir];
}

- (NSString *) getDefaultPathForCash
{
    return [[BxConfig defaultConfig] cashPath];
}

- (id) initWithFileName: (NSString*) cashedFileName
{
    self = [self init];
	if ( self ){
		self.isRefreshing = NO;
		cashedFileName = [cashedFileName retain];
		NSString * cashedFileNameWithDir = [[self defaultDir] stringByAppendingPathComponent: cashedFileName];
		_cashedFilePath = [[[self getDefaultPathForCash] stringByAppendingPathComponent: cashedFileNameWithDir] retain];
	}
	return self;
}

- (id) initWithParser: (BxAbstractDataParser*) parser
	   cashedFileName: (NSString*) cashedFileName
{
	if (self = [self initWithFileName: cashedFileName]){
		self.parser = parser;
	}
	return self;
}

- (void) restore
{
	if (![[NSFileManager defaultManager] fileExistsAtPath: _cashedFilePath]){
		[BxFileSystem initDirectories: [_cashedFilePath stringByDeletingLastPathComponent]];
		NSString * srcPath =
		[[NSBundle mainBundle] pathForResource: [_cashedFileName stringByDeletingPathExtension]
										ofType: [_cashedFileName pathExtension]];
		if (![[NSFileManager defaultManager] fileExistsAtPath: srcPath]){
			return;
		}
		NSError * error = nil;
		[[NSFileManager defaultManager] copyItemAtPath: srcPath toPath: _cashedFilePath error: &error];
		if (error){
			@throw [BxException exceptionWith: error];
		}
	}
}

- (BOOL) cashedFileExist
{
	return [[NSFileManager defaultManager] fileExistsAtPath: _cashedFilePath];
}

- (void) delete
{
	if ([self cashedFileExist]) {
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtPath: _cashedFilePath error: &error];
		if (error){
			NSLog(@"DataCasher error: %@", error);
		}
	}
}

- (void) deleteAll
{
	[self delete];
}

- (NSDictionary *) loadData
{
	if (_isRefreshing) {
		return nil;
	}
	// проверяем наиличие файла в ресурсах
	[self restore];
	if (!_parser){
		[NSException raise: @"NotFoundException"
					format: @"Незадан парсер для кеширования"];
	}
	if (![self cashedFileExist]){
		return nil;
	}
	// открываем данные
	NSDictionary * result = [_parser loadFromFile: _cashedFilePath];
	//NSLog(@"%@", result);
	return result;
}

- (NSDictionary *) anywayLoadData
{
	return nil;
}

- (void) saveData: (NSDictionary *) data
{
	if (!_parser){
		[NSException raise: @"NotFoundException"
					format: @"Для кеширования необходимо задать парсер"];
	}
    if (!data) {
        return;
    }
	@synchronized(self) {
        [BxFileSystem initDirectories: [_cashedFilePath stringByDeletingLastPathComponent]];
		[_parser saveFrom: data toPath: _cashedFilePath];
	}
}

- (void)dealloc {
	self.parser = nil;
	[_cashedFileName autorelease];
    _cashedFileName = nil;
	[_cashedFilePath autorelease];
    _cashedFilePath = nil;
    [super dealloc];
}

@end

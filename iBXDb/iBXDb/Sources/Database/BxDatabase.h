/**
 *	@file BxDatabase.h
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

#import <Foundation/Foundation.h>
#import "BxFMDatabase.h"

//! База данных SQLite
@interface BxDatabase : NSObject
{
@protected
    NSString * _fileName;
    BOOL _includeFromBackup;
}
@property (nonatomic, retain, readonly) BxFMDatabase * database;
@property (nonatomic, retain, readonly, getter = getPathForRestore) NSString * filePath;
//! Позволяет восстановить базу из iCloud. Внимание Apple не всех пропустит с этой функцией. По умолчанию отключена
@property (nonatomic, getter = _includeFromBackup, setter = setIncludeFromBackup:) BOOL includeFromBackup;

+ (BxDatabase*) defaultDatabase;

- (void) open;

/**
* fileName - название файла, в качестве которого может быть полный путь.
* название конечного файла будет использовано, чтобы достать из ресурсов проекта в случае
* отсутствия файла по указанному пути
*/
- (id) initWithFileName: (NSString*) fileName;

- (BOOL) executeWith: (NSString*) sql;

- (NSNumber*) executeNumberFunctionWith: (NSString*) sql;

- (NSArray*) allDataWith: (NSString*) sql;

- (NSString*)lastErrorMessage;

@end

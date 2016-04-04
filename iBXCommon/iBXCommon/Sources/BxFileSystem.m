/**
 *	@file BxFileSystem.m
 *	@namespace iBXCommon
 *
 *	@details Работа с файловой системой
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxFileSystem.h"
#import "BxCommon.h"
#import "NSData+BxUtils.h"

@implementation BxFileSystem

+ (void) initDirectories: (NSString*) path
{
	if(![[NSFileManager defaultManager]
         createDirectoryAtPath: path
         withIntermediateDirectories: YES
         attributes: nil
         error: nil])
	{
		[BxAlertView showErrorAndExit: StandartLocalString(@"The failed to initialize dictionary")];
	}
}

+ (void) cleanDirectory: (NSString*) path
{
    if([path hasPrefix:@"~"]) {
        path = [path stringByExpandingTildeInPath];
    }
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath: path error: &error];
        if (error) {
            RAISE_TRANSFORM_EXCEPTION(error, StandartLocalString(@"Could not clean directory"));
        }
    }
	[self initDirectories: path];
}

+ (BOOL) deleteAllNotInList: (NSArray*) list inPath: (NSString*) inPath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath: inPath]) {
        return NO;
    }
	NSError * error = nil;
    NSArray * allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: inPath
                                                                             error: &error];
    if (error) {
        NSLog(@"ERROR in deleteAllNotInList: %@", error.localizedDescription);
        return NO;
    } else {
        BOOL result = YES;
        for (NSString * currentFileName in allFiles) {
            BOOL isFound = NO;
            for (NSString * notListFileName in list) {
                if ([currentFileName isEqualToString: notListFileName]) {
                    isFound = YES;
                    break;
                }
            }
            if (!isFound) {
                error = nil;
                [[NSFileManager defaultManager] removeItemAtPath: [inPath stringByAppendingPathComponent: currentFileName]
                                                           error: &error];
                if (error) {
                    NSLog(@"ERROR in IdentifierDataCasher->deleteAllNotInList: %@ (path: %@)", error.localizedDescription, currentFileName);
                    result = NO;
                }
            }
        }
        return result;
    }
}

+ (NSString*) addNewFolderTo: (NSString*) path
{
	NSInteger dirNum = 1;
	NSString * dirPath = nil;
	do { // перебираем шестизначные цыфры, пока такие уже существуют
		NSString * dirNumName = [[NSString alloc] initWithFormat: @"%06ld", (long)dirNum++, nil];
		dirPath = [path stringByAppendingPathComponent: dirNumName];
		[dirNumName release];
	} while ([[NSFileManager defaultManager] fileExistsAtPath: dirPath]);
	// создаем заданный каталог
	NSError * error = nil;
	[[NSFileManager defaultManager] createDirectoryAtPath: dirPath
							  withIntermediateDirectories: NO attributes: nil error: &error];
	if (error) {
		[BxException raise: @"addNewFolderTo: Create directory" format: @"%@", error, nil];
	}
	return dirPath;
}

+ (NSString*) getNewFilePathWith: (NSString*) path name: (NSString*) name ext: (NSString*) ext
{
    if (!ext && ext.length < 1) {
        ext = @"data";
    }
	NSInteger dirNum = 1;
	NSString * filePath = nil;
	do {
		NSString * dirNumName = [[NSString alloc] initWithFormat: @"%@%05ld", name, (long)dirNum++, nil];
		NSString * dirPath = [path stringByAppendingPathComponent: dirNumName];
		filePath = [dirPath stringByAppendingPathExtension: ext];
		[dirNumName release];
	} while ([[NSFileManager defaultManager] fileExistsAtPath: filePath]);
	return filePath;
}

+ (NSString*) pathFrom: (NSString*) url dirPath:(NSString*) dirPath extention:(NSString*) ext
{
	NSString * result = [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
	if ( ![[result pathExtension] isEqualToString: ext]){
		result = [result stringByAppendingPathExtension: ext];
	}
	return result;
}

+ (NSString*) relativePathFrom: (NSString*) dirPath targetPath:(NSString*) targetPath
{
	// подчищаем пути
	NSURL * url = [NSURL fileURLWithPath: dirPath];
	dirPath = [url path];
	url = [NSURL fileURLWithPath: targetPath];
	targetPath = [url path];
	// ищем расхождения
	NSMutableArray * result = [NSMutableArray arrayWithArray: [targetPath pathComponents]];
	NSArray * src = [dirPath pathComponents];
	int removedComponents = 0;
	for (int i = 0; i < src.count; i++) {
		if (result.count > 0 && [[result objectAtIndex: 0] isEqualToString: [src objectAtIndex: i]])
		{
			[result removeObjectAtIndex: 0];
			removedComponents++;
		} else {
			break;
		}
	}
	// дополняем возвратом папки вверх
	for (int i = 0; i < src.count - removedComponents; i++) {
		[result insertObject: @".." atIndex: 0];
	}
	return [NSString pathWithComponents: result];
}

+ (NSData *) dataWithResourceFileName: (NSString*) fileName
{
    return [NSData dataWithResourceFileName: fileName];
}

@end

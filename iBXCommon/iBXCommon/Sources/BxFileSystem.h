/**
 *	@file BxFileSystem.h
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

#import <Foundation/Foundation.h>

@interface BxFileSystem : NSObject

//! Производит инициализацию каталогов, указанных в пути path
+ (void) initDirectories: (NSString*) path;
//! производит очистку каталога по пути, указанного в пути path
+ (void) cleanDirectory: (NSString*) path;
//! Очистка директории без указанных файлов в списке
+ (BOOL) deleteAllNotInList: (NSArray*) list inPath: (NSString*) inPath;

/**
 *	Путь к файлу с уникальным названием
 *
 *	Возвращает путь к файлу с расширением ext и именем name с добавочным числом,
 *	которое будет гарантировать его уникальность в каталоге path
 */
+ (NSString*) getNewFilePathWith: (NSString*) path name: (NSString*) name ext: (NSString*) ext;
//! Генерирует название нового каталога который должен находится в path
+ (NSString*) addNewFolderTo: (NSString*) path;

/**
 *	возвращает путь к файлу в дирректории dirPath с названием, взятым из контекста url с добавлением расширения файла ext
 *	@param url [in] - ссылка на источник, с которым будет ассоциирован искомый файл
 *	@param dirPath [in] - путь к каталогу, в котором будет находится файл
 *	@param ext [in] - расширение файла
 */
+ (NSString*) pathFrom: (NSString*) url dirPath:(NSString*) dirPath extention:(NSString*) ext;

/**
 *	возвращает относительный путь для текущего пути к искомому
 *	@param dirPath [in] - текущий путь
 *	@param targetPath [in] - искомый путь
 */
+ (NSString*) relativePathFrom: (NSString*) dirPath targetPath:(NSString*) targetPath;

//! data from resource fileName, if not found return nil
+ (NSData *) dataWithResourceFileName: (NSString*) fileName;


@end

/**
 *	@file BxDownloadStreamSaver.h
 *	@namespace iBXData
 *
 *	@details Провайдер загрузки из Веб-сервиса в файл определенных данных
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxDownloadProgress.h"

//! Провайдер загрузки из Веб-сервиса в файл определенных данных
@interface BxDownloadStreamSaver : NSObject

@property (nonatomic, retain) NSMutableURLRequest * request;

/**
 *	@brief Сохранение всего содержимого html страницы со вложанными ссылками
 *
 *	Происходит сохранение синхронно, все события по управлению обрабатываются тут
 *	@param url [in] - ссылка на ресурс (например html страницу)
 *	@param path [in] - путь, куда ресурс будет сохранен в виде набора файлов с заглавной страницей
 *	@return Путь к заглавной странице ресурса
 *	@throw DownloadException
 */
- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate;

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
          isContaining: (BOOL) isContaining
       containingLevel: (int) containingLevel;

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
				   ext: (NSString *) ext;

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
				   ext: (NSString *) ext
          isContaining: (BOOL) isContaining
       containingLevel: (int) containingLevel;

@end

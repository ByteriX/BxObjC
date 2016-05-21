/**
 *	@file BxDownloadStream.h
 *	@namespace iBXData
 *
 *	@details Загрузка данных из Веб-ресурса по ссылке url
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxException.h"
#import "BxDownloadProgress.h"
#import "BxDownloadUtils.h"


//!	Исключение для закачки ресурсов из интернета
@interface BxDownloadStreamException : BxException {
}

@property (nonatomic, retain) NSData * data;

@end

typedef void (^BxDownloadStreamHandler)(NSError * error, NSData * data);

typedef void (^BxDownloadStreamHttpResponseHandler)(NSDictionary * allHeaderData);

//! Загрузка данных из Веб-ресурса по ссылке url
@interface BxDownloadStream : NSObject <BxDownloadStreamProtocol>
{
@protected
	//! Прирост уровня загрузке
	float _progressScale;
	//! Максимально возможный уровень загрузки
	float _maxProgress;
	//! Интерфейс индикации уровня загрузки
	id<BxDownloadProgress> _progress;
    //! Флаг необходим для корректной обработки отмены загрузки
    BOOL _isCanceled;
    //! This flag is needing for check double stoping, for example respond error status and finished session
    BOOL _isStopped;
@protected
	//! соединение для закачки данных
	NSURLConnection * _urlDownload;
	//! закачиваемые данные
	NSMutableData * _loadingData;
}

/**
 *	@brief Загрузка Данных из ресурса по ссылке url
 *	@throw DownloadException
 */
+ (NSData *) loadFromUrl: (NSString*) url;
+ (NSData *) loadFromUrl: (NSString*) url timeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 *	@brief Загрузка Данных из ресурса по ссылке url с синхронным показом уровня загрузки
 *	@throw DownloadException
 */
+ (NSData *) loadFromUrl: (NSString*) url
             maxProgress: (float) maxProgress
                delegate: (id<BxDownloadProgress>) delegate;

+ (NSData *) loadFromRequest: (NSURLRequest *) request
                 maxProgress: (float) maxProgress
                    delegate: (id<BxDownloadProgress>) delegate;

+ (NSData *) loadFromRequest: (NSURLRequest *) request
                 maxProgress: (float) maxProgress
                    delegate: (id<BxDownloadProgress>) delegate
                      stream: (BxDownloadStream **) stream;

/**
 *	@brief Возвращает информацию о ресурсе url
 *
 *	Происходит удаленный доступ синхронно
 *	@param url [in] - ссылка на ресурс (например html страницу)
 *	@return Справочник заголовка
 */
+ (NSDictionary *) getAllHeaderFieldsFrom: (NSString*)url;

//! Прирост загрузки данных до maxProgress при получении соединения с ресурсом response
+ (float) getProgressScaleWith: (NSURLResponse *)response maxProgress: (float) maxProgress1;

//! Старт загрузки данных по запросу
- (void) start: (NSURLRequest *) request responseHandler: (BxDownloadStreamHttpResponseHandler) responseHandler
       handler: (BxDownloadStreamHandler) handler;

//! Отмена операции загрузки
- (void) cancel;

@end

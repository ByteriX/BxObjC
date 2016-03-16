/**
 *	@file BxDownloadOldFileCasher.h
 *	@namespace iBXData
 *
 *	@details Кешированная закачка ресурсов из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxDownloadProgress.h"
#import "BxDownloadStreamSaver.h"

/**
 *	@brief Кешированная закачка ресурсов из Веб-сервиса
 *
 *	Фишка данного кешера в том, что при возможности подключения к интернет
 *	он будет проверять обновление данной страницы по его контексту и в случае
 *	обнаружения более свежей версии обновит текущую. Долговременно хранящиеся
 *	документы будут удалены автоматически.
 *
 */
@interface BxDownloadOldFileCasher : NSObject {
@protected
    //! Файл хранящий информацию по кешу
	NSString * _currentFilePath; //property
	//! Доступ у общему хранилищу cash происходит через этот мьютекс
	NSLock * _cashUpdatingLock;
	//! Критическая секция для поиска кеша
	NSLock * _mainLock;
}

//! Справочник запрашиваемых удаленных ресурсов
@property (nonatomic, retain) NSMutableDictionary * cashSearch;
//! Путь к директории в которой расположены закешированные ресурсы
@property (nonatomic, readonly) NSString * currentDirPath;
//! Расширение файлов кеша
@property (nonatomic, retain) NSString * extention;
//! Формат даты для текстового представления
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;
//! Определяет нужно ли проверять наиличие обновления на сервере. По умолчанию NO
@property (nonatomic) BOOL isCheckUpdate;
//! Определяет нужно ли загружать вложенные ссылки, чаще всего используется для HTML. По умолчанию YES
@property (nonatomic) BOOL isContaining;
//! Максимально возможное количество закешированных страниц
@property (nonatomic) int maxCashCount;
//! Зактчик контента, у которого всегда можно изменить параметры запроса
@property (nonatomic, retain) BxDownloadStreamSaver * streamSaver;

- (id) initWithName: (NSString*) name;

+ (BxDownloadOldFileCasher *) downloadCashWithName: (NSString*) name;

//! Синголтон @ref CashDownload
+ (BxDownloadOldFileCasher *) defaultCasher;

//! Завершение работы с синголтоном
+ (void) close;

//! Открытие регистратора
- (void) open;

//! Сообщает о том что url имеется в кеше
- (BOOL) isCashed: (NSString*) url;

//! сообщает о том что ссылка идет на локальный рессурс
+ (BOOL) isLocale: (NSString*) url;

//! возвращает дату последнего изменения из заголовков HTTP
+ (NSDate *) getLastModifiedFromAllHeader: (NSDictionary*) headers;

//! Возвращает урловую ссылку на локальный ресурс
- (NSString*) localURLFrom: (NSString*) absolutePath;
+ (NSString*) localURLFrom: (NSString*) absolutePath;

/**
 *	@brief Загрузка ресурса из кеша с возможной проверки обновления на сервере
 *	@param url - путь к ресурсу
 */
- (NSString *) getDownloadedPathFrom: (NSString*) url;
- (NSString*) getLocalDownloadedPathFrom: (NSString*) url;

/**
 *	@brief Загрузка ресурса из кеша с обязательной errorConnection и ведением индикации загрузки
 *	@param url - путь к ресурсу
 *	@throws Может вызывать исключение @ref DownloadException, NSException
 *	но не в том случае если ресурс есть в кеше
 */
- (NSString *) getDownloadedPathFrom: (NSString*) url
					 errorConnection: (BOOL) errorConnection
							progress: (id<BxDownloadProgress>) progress;

//! Очистка всего кеша от лишнего груза и сохранение регистратора
- (void) cleanAndSave;

//! Сообщает о том что кеш пуст
- (BOOL) isEmpty;

//! Сообщает об отсутствии соединения
+ (BOOL) isErrorConnectionFrom: (NSInteger)errorCode;

@end

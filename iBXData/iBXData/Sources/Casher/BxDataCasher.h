/**
 *	@file BxDataCasher.h
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

#import <Foundation/Foundation.h>
#import "BxAbstractDataParser.h"

//! Класс инкапсулирует сохранение данных на носитель и по мере надобности их обновление, в том числе и принудительное
@interface BxDataCasher : NSObject
{
@protected
	//! относительный путь файла/директории
	NSString * _cashedFileName;
	//! полный путь к конечному файлу кеша
	NSString * _cashedFilePath;
}

//! парсер, который работает при сохранении на устройстве для сериализации/дисериализации
@property (nonatomic, retain) BxAbstractDataParser* parser;
//! Состояние менеджера, при котором он будет обновлять свои данные всегда при значение YES
@property (nonatomic) BOOL isRefreshing;

+ (NSString*) defaultDir;

//! инициализация кеширования с парсером
- (id) initWithParser: (BxAbstractDataParser*) parser
	   cashedFileName: (NSString*) cashedFileName;

//! инициализация кеширования для файла/директории имеющего путь cashedFileName (относительно папки для документов)
- (id) initWithFileName: (NSString*) cashedFileName;

//! возвращает данные по кешу, если они существуют/актуальны/не обновляются
- (NSDictionary *) loadData;

//! еще одна попытка получить данные, даже если они стали неактуальными (ну иначе никак их не получить)
- (NSDictionary *) anywayLoadData;

//! сохраняет данные в кеш
- (void) saveData: (NSDictionary *) data;

//! говорит о том что файл кеша успешно обнаружен
- (BOOL) cashedFileExist;

- (void) delete;

- (void) deleteAll;

@end

/**
 *	@file BxAbstractDataParser.h
 *	@namespace iBXData
 *
 *	@details Абстрактный сериализатор/дисериализатор
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxException.h"

//!	Исключение для закачки ресурсов из интернета
@interface BxParserException : BxException {
}
@end

//!	Абстрактный сериализатор/дисериализатор
@interface BxAbstractDataParser : NSObject

//! загрузка данных из файла и интернет контента
//! может генерировать @ref DownloadException, @ref ParserException, @ref WorkingException
- (NSDictionary*) loadFromFile: (NSString*) filePath;
- (NSDictionary *) loadFromUrl: (NSString*) url post: (NSString*)post;
- (NSDictionary *) loadFromUrl: (NSString*) url;

//! дастать данные из содержимого при дисериализации
- (NSDictionary*) dataFromData: (NSData*) data;
//! дастать данные из строки
- (NSDictionary*) dataFromString: (NSString*) string;

//! вернуть содержимое данных при сериализации
- (NSData*) serializationData: (NSDictionary*) data;

//! сохранение данных в файл
- (void) saveFrom: (NSDictionary*) data toPath: (NSString*) filePath;
//! получение в виде строки в кодировке UTF-8
- (NSString*) getStringFrom: (NSDictionary*) data;

@end

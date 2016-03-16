/**
 *	@file NSString+BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Категория для NSString
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

@interface NSString (BxUtils)

//! Генерация случайным образом 16-ричной последовательности
+ (NSString*) getUUID;

//! для версии compareString большей вернется NSOrderedAscending!
- (NSComparisonResult) versionCompare:(NSString *)compareString;

//! Генерация MD5 из строки
- (NSString *) md5;

//! Генерация sha1 из строки
-(NSString *) sha1;

//! получение URL для браузера из строки в которой уже присутствуют только приобразованные символы % или их вовсе нету
- (NSString*) getAddingPercentEscapes;

//! получение URL для браузера из строки в которой отсутствуют преобразованные символы %
- (NSString*) getAddingPercentEscapesWithDublicate;

//! Правильная кодировка в RFC 3986, чтобы в параметре строк не было путаницы по параметрам, лучше использовать этот метод для кодирования отдельных параметров URL
- (NSString *)getAddingPercentEscapesToParams;

//! раскадирование URL
- (NSString*) getReplacingPercentEscapes;

//! возвращает кодировки из его названия
- (NSStringEncoding)encodingFromEncodingName;

//! HTML прасинг с превращением в обычный текст / фактически выдираем текст с сохранением отступов/абзацев
- (NSString*) htmlToPlainText;

//! раскладка параметров URL в словарь с данными (строковыми)
- (NSDictionary*) componentsFromURLParams;

//! Урл и локальный путь к файлу ресурса по названию файла
- (NSString*) urlFromResourceFileName;
- (NSString*) pathFromResourceFileName;

@end

@interface NSMutableString (BxUtils)

//! Добавляет объекты к строке в формате x-www-forms
- (void) addToXFormsPath: (NSString*) path fromObject: (id) object;

@end
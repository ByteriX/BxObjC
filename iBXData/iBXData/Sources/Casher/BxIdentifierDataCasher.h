/**
 *	@file BxIdentifierDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDataCasher.h"

//! Кеширование в отдельные файлы по указанному в названии файла кеша пути по идентификатору
@interface BxIdentifierDataCasher : BxDataCasher{
@protected
	//! главный путь, указанный пользователем для данного кешера
	NSString * _mainFileName;
}
//! идентификатор кеша, в нем не должно быть символов "/" иначе чиститься не будет
@property (nonatomic, retain) NSString * identifier;

//! гарантированно и независимо сохраняет данные в кеше
- (void) saveDataFromExternal: (NSDictionary *) data;

//! удаляет из данного кеша, все что не найдено в списке идентификаторов
- (void) deleteAllNotInIdentifierList: (NSArray*) list;

//! удаляет из кеша данные по конкретному идентификатору
- (void) deleteWithIdentifier: (NSString*) value;

@end
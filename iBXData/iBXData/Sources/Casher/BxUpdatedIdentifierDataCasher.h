/**
 *	@file BxUpdatedIdentifierDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору, востребует необновленный кеш
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxIdentifierDataCasher.h"

/**
 *	Менеджер кеширования данных с привязкой к идентификатору,
 *  так же способен к закачке из офлайн и отметки того что лучше обновиться из вне
 */
@interface BxUpdatedIdentifierDataCasher : BxIdentifierDataCasher


//! помечает элемент, как требующего обновления
- (NSDictionary *) setNotUpdatedWithIdentifier: (NSString*) value;

@end

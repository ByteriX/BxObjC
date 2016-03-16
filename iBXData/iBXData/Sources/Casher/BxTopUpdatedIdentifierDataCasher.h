/**
 *	@file BxTopUpdatedIdentifierDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору и удаление устаревших, востребует необновленный кеш
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxTopIdentifierDataCasher.h"

/**
 *  Менеджер кеширования данных с привязкой к идентификатору и
 *  удалением предыдущих сохранений при достижении лимита,
 *  так же способен к закачке из офлайн и отметки того что лучше обновиться из вне
 */
@interface BxTopUpdatedIdentifierDataCasher : BxTopIdentifierDataCasher

//! помечает элемент, как требующего обновления
- (NSDictionary *) setNotUpdatedWithIdentifier: (NSString*) value;

@end

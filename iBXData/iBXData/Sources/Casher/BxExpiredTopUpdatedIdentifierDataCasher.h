/**
 *	@file BxExpiredTopUpdatedIdentifierDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору, востребует необновленный кеш, который имеет время жизни
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxTopUpdatedIdentifierDataCasher.h"
#import "BxExpiredDataCasher.h"

/**
 *	Менеджер кеширования данных имеющих срок действия и идентификацию
 *  с возможностью инвалидировать по идентификатору пул кеша
 */
@interface BxExpiredTopUpdatedIdentifierDataCasher : BxTopUpdatedIdentifierDataCasher
{
@private
    NSDateFormatter * _dateFormatter;
	//! срок действия данных в секундах
	NSTimeInterval _expiredInterval;
}

- (id) initWithFileName: (NSString*) cashedFileName
               topCount: (int) topCount
        expiredInterval: (NSTimeInterval) expiredInterval;

//! загрузка данных, даже если они неактуальны
- (NSDictionary *) loadDataIfExpired;

//! Дата последнего обновления кеша
- (NSDate*) cashDate;

@end

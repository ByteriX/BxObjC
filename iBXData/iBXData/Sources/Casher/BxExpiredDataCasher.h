/**
 *	@file BxExpiredDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование со сроком действия
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDataCasher.h"

#define ExpiredPeriodHour 3600.0
#define ExpiredPeriodDay 24.0 * ExpiredPeriodHour
#define ExpiredPeriodMonth 30.0 * ExpiredPeriodDay

FOUNDATION_EXPORT NSString const* FNExpiredDataCasherCashed;
FOUNDATION_EXPORT NSString const* FNExpiredDataCasherDate;

//! менеджер кеширования со заданным сроком действия информации
@interface BxExpiredDataCasher : BxDataCasher {
@protected
	NSDateFormatter * _dateFormatter;
	//! срок действия данных в секундах
	NSTimeInterval _expiredInterval;
}

//! конструктор с заданным интервалом срока действия в секундах
- (id) initWithFileName: (NSString*) cashedFileName
		expiredInterval: (NSTimeInterval) expiredInterval;

//! загрузка данных, даже если они неактуальны
- (NSDictionary *) loadDataIfExpired;

//! Дата последнего обновления кеша
- (NSDate*) cashDate;

@end

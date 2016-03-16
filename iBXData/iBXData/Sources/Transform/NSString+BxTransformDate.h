/**
 *	@file NSString+BxTransformDate.h
 *	@namespace iBXData
 *
 *	@details NSString категория конвертации данных в дату
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

typedef long long JPlusDateTime;

//! NSString категория конвертации данных в дату
@interface NSString (BxTransformDate)

//! Преобразование серверной строковой даты в объект
- (NSDate*)dateFromRfc3999Value;

+ (id) stringWithTime: (JPlusDateTime) time;
+ (id) stringWithJTime: (NSDate*) date;
- (JPlusDateTime) getJPlusDateTime;

@end

/**
 *	@file BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Утилиты
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

@interface BxUtils : NSObject

//! возращает название количества count из набора названий words для русскоязычной локали
+ (NSString *) getWordFromCount: (int) count with3Words: (NSArray*) words;

//! Возвращает случайное число от 0 до 1.0
+ (double) getRandom;

@end

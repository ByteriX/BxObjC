/**
 *	@file BxTopIdentifierDataCasher.h
 *	@namespace iBXData
 *
 *	@details Кеширование по идентификатору и удаление устаревших
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxIdentifierDataCasher.h"

//! Менеджер кеширования данных с привязкой к идентификатору и  удалением предыдущих сохранений при достижении лимита
@interface BxTopIdentifierDataCasher : BxIdentifierDataCasher

@property (nonatomic) int topCount;

- (id) initWithFileName: (NSString*) cashedFileName topCount: (int) topCount;

- (void) clear;

@end

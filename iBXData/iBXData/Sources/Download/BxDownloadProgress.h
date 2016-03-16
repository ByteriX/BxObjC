/**
 *	@file BxDownloadProgress.h
 *	@namespace iBXData
 *
 *	@details Интерфейс изменения уровня загрузки
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//!	Интерфейс изменения уровня загрузки
@protocol BxDownloadProgress <NSObject>

//! Текущее значение уровня загрузки
- (float) getPosition;

//! Установка текущего уровня загрузки
- (void) setPosition: (float) position;

//! Запуск визуального представления моментальной загрузки
- (void) startFastFull;

//! Отвечает всем критериям гарантии, что индикатор готов отреагировать на изменения
- (BOOL) isActive;

@optional

- (void) setText: (NSString*) text;
- (NSString*) getText;

@end

//! Определение готовниости индикатора загрузки для работы с ним
BOOL DPisValid(id<BxDownloadProgress> downloadProgress);
//! Возврат значения индикатора загрузки
float DPgetPosition(id<BxDownloadProgress> downloadProgress);
//! Установка определенного значения индикатору загрузки
void DPsetPosition(id<BxDownloadProgress> downloadProgress, float value);
//! Прирощение определенного значения индикатору загрузки
void DPincPosition(id<BxDownloadProgress> downloadProgress, float value);
//! Визуализация быстрой загрузки
void DPstartFastFull(id<BxDownloadProgress> downloadProgress);
/**
 *	@file BxConfig.h
 *	@namespace iBXCommon
 *
 *	@details Настройка окружения
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum  {
    BxConfigLocaleDefault = 0,
    BxConfigLocaleEnglish = 1,
    BxConfigLocaleRussian = 2,
} BxConfigLocale;

@interface BxConfig : NSObject
{
    @private
        NSString * _documentPath; // property
        NSString * _cashPath; // property
        NSString * _tempPath; // property
        BxConfigLocale _language;
        NSDateFormatter * _commonDateFormatter;
}

+ (BxConfig*) defaultConfig;

//! Поле хранящее путь к документам данного приложения
@property (nonatomic, readonly) NSString * documentPath;
//! Поле хранящее путь к кешу данного приложения
@property (nonatomic, readonly) NSString * cashPath;
//! Поле хранящее путь к временным файлам данного приложения
@property (nonatomic, readonly) NSString * tempPath;
//! Язык, выбранный при установке
@property (nonatomic, readonly) BxConfigLocale language;
//! Типичный формат даты под данную локаль
@property (nonatomic, readonly) NSDateFormatter * commonDateFormatter;

//! Сообщает системе о том что программа имела сборку для отладки приложения
+ (BOOL) isDebuging;

//! Текстовое значение токина для Push Notification
+ (NSString*) deviceTokenFromData: (NSData*) webDeviceToken;

//! симулирует возникновение предупреждения о нехватки памяти
+ (void) performFakeMemoryWarning;

//! Для Retina = 2.0, в остальных случаях = 1.0
+ (float) scale;

@end

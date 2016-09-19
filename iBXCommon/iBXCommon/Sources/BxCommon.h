/**
 *	@file BxCommon.h
 *	@namespace iBXCommon
 *
 *	@details Основные определения
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxConfig.h"
#import "BxFileSystem.h"
#import "BXUtils.h"
#import "BXUIUtils.h"
#import "BxException.h"

#import "NSString+BxUtils.h"
#import "UIImage+BxUtils.h"
#import "NSData+BxUtils.h"
#import "UIDevice+BxUtils.h"
#import "UIColor+BxUtils.h"
#import "NSDictionary+BxUtils.h"
#import "NSArray+BxUtils.h"
#import "NSURL+BxUtils.h"

#import "BxAlertView.h"
#import "BxActionSheet.h"

#import "BxGeometry.h"

#import "BxPushNotificationMessageQueue.h"

#ifndef iBXCommon_BxCommon_h
#define iBXCommon_BxCommon_h

//! Определение позволяет получить переведенную строку из файла проекта Localizable.strings
#define LocalString(key) \
    [[NSBundle mainBundle] localizedStringForKey: key value: @"" table: nil]

//! Определение позволяет получить переведенную строку из фреймворка BxCommonLocalizable.strings
#define BxCommonLocalString(key, standartValue) \
    [[NSBundle bundleForClass:[BxConfig class]] localizedStringForKey: key value: standartValue table: @"BxCommonLocalizable"]
#define StandartLocalString(key) BxCommonLocalString(key, @"")

/**
 *	Переброс исключений, которые можно показывать пользователям в сообщениях
 */
#define RAISE_TRANSFORM_EXCEPTION(exception, message) \
    NSLog(@"ERROR!!! %s [Line %d]\n\nTransform Exception message: \n\n\t %@ \n\n\texception:\n\n\t %@", __PRETTY_FUNCTION__, __LINE__, message, exception); \
    [BxException raise: @"TransformException" format: message, nil]; \

/**
 *	Вывод сообщения об ошибке при отлове исключения
 */
#define EXCEPTION_TO_ERROR(exception, message) \
    NSLog(@"ERROR!!! %s [Line %d]\n\nError Exception message: \n\n\t %@ \n\n\texception:\n\n\t %@", __PRETTY_FUNCTION__, __LINE__, message, exception); \
    [BxAlertView showError: [NSString stringWithFormat: @"%@\n%@", message, [exception reason]]];

//! Сообщение связанное с ошибкой веб сервиса для статуса
#define BxHTTPMessageFromStatus(statusCode) [NSString stringWithFormat: StandartLocalString(@"Web service error: %@ (%d)"), \
[NSHTTPURLResponse localizedStringForStatusCode: statusCode], statusCode, nil]

//! Макрос, который доступен только под сборкой для тестирования
#ifdef DEBUG
    #define StandartLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define StandartLog(...)
#endif

#define IS_480 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480)
#define IS_568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define IS_667 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define IS_736 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)
#define IS_568_GREATER ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height >= 568)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0f)
#define IS_RETINA_X2 ([[UIScreen mainScreen] scale] == 2.0f)
#define IS_RETINA_X3 ([[UIScreen mainScreen] scale] == 3.0f)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_OS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#endif

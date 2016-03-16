/**
 *	@file BxPushNotificationMessageQueue.h
 *	@namespace iBXCommon
 *
 *	@details Очередь удаленных нотификаций
 *	@date 29.11.2015
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! событие, которое делегируется при нотификациях для обработке в интерфейсе
typedef void(^BxPushNotificationHandler)(NSDictionary* data);

//! событие, которое делегируется при нотификациях для возможности обработки в интерфейсе
typedef BOOL(^BxPushNotificationShowHandler)(NSDictionary* data);

//! класс работы с нотификациями, необходимо создавать экземпляр при старте приложения в AppDelegate (смотри пример)
@interface BxPushNotificationMessageQueue : NSObject

//! событие, которое вызывается при приходе пуша, который был отклонен автоматически или пользователем
@property (nonatomic, copy) BxPushNotificationHandler skippedActionHandler;
//! событие, которое вызывается при приходе пуша, полностью принятый пользователем
@property (nonatomic, copy) BxPushNotificationHandler actionHandler;
//! событие определяет, будет показан диалог "Вы хотите перейти на экран просмотра? да или нет
@property (nonatomic, copy) BxPushNotificationShowHandler inAppShowHandler;


//! Облочный токен для пушнотификаций
+ (NSString*) deviceToken;

//! инициализатр при старте в AppDelegate
- (id) initWithApplication: (UIApplication*) application actionHandler: (BxPushNotificationHandler) handler;

//! Регистрация пушей в приложении, работает и в iOS8, параметры соответствуют UIUserNotificationSettings:settingsForTypes:categories:
- (void) registerTypes: (UIUserNotificationType) types categories:(NSSet *)categories;

/**
 *  Проверка, приходили нотификации при старте приложения, если приходили, то возвращает YES
 *
 *  Необходимо вызывать в AppDelegate didFinishLaunchingWithOptions
 *  например сразу после инициализации объекта
 */
- (BOOL) checkNotificationFromLaunchOptions: (NSDictionary*) launchOptions;

//! Захват нотификаций в AppDelegate в блоке didReceiveRemoteNotification
- (void) catchNotification:(NSDictionary *) userInfo;

//! Регистрация токена для отправки пушей. Вызывать ее так же надо при ошибках нотификаций с параметром nil
- (void) updateDeviceToken: (NSString*) deviceTokenString;

//! Эту функцию можно использовать для тестирования пушей без участия сервера
- (void) testWithText: (NSString*) text params: (NSDictionary*) params delay: (NSTimeInterval) delay;

//! фоновое обновление информации о пушнотификациях для обновления облочного токена
//! @protected template method for override
- (void) checkUpdatePushNotificationsInfo;

@end

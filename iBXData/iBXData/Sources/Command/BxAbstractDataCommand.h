/**
 *	@file BxAbstractDataCommand.h
 *	@namespace iBXData
 *
 *	@details Абстрактная команда, выполняющая действие
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

typedef void (^BxDataCommandSuccessHandler)(id command);
typedef void (^BxDataCommandErrorHandler)(NSError * error);
typedef void (^BxDataCommandCancelHandler)();

extern NSString *const FNDataCommandName;

//! Абстрактная команда исполнения
@interface BxAbstractDataCommand : NSObject {
@protected
    BOOL _isCanceled;
}
@property (nonatomic, readonly, getter = getCaption) NSString * caption;
@property (nonatomic, readonly, getter = getName) NSString * name;
@property (nonatomic, readonly, getter = _isCanceled) BOOL isCanceled;

- (NSMutableDictionary*) saveToData;
- (void) loadFromData: (NSMutableDictionary*) data;
- (void) execute;
- (void) updateFrom: (BxAbstractDataCommand*) command;

- (void)cancel;

//! Выполняет операцию в фоновом потоке, по завершению обрабатывает результат
- (void) executeWithSuccess: (BxDataCommandSuccessHandler) successHandler
               errorHandler: (BxDataCommandErrorHandler) errorHandler
              cancelHandler: (BxDataCommandCancelHandler) cancelHandler;

//! @protected
+ (void) errorWithCode: (NSInteger) code message: (NSString*) message;

@end

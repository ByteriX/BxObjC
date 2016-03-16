/**
 *	@file BxAlertView.h
 *	@namespace iBXCommon
 *
 *	@details Диалоговое окно
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

typedef void(^BxAlertHandler)(BOOL isOK);

@interface BxAlertView : UIAlertView

//! Стандартное диалоговое окно через блоки
+ (void) showAlertWithTitle: (NSString *) title
                    message: (NSString *) message
          cancelButtonTitle: (NSString *) cancelButtonTitle
              okButtonTitle: (NSString *) okButtonTitle
                    handler: (BxAlertHandler) handler;

//! Отображение ошибки программы
+ (void) showError: (NSString *) message;

//! Отображает ошибку и завершает выполнение программы после нажатия на ОК
+ (void) showErrorAndExit: (NSString *) message;

@end

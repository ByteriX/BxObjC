/**
 *    @file UIViewController+Alert.h
 *    @namespace iBXCommon
 *
 *    @details Диалоговое окно для iOS 9
 *    @date 07.07.2019
 *    @author Sergey Balalaev
 *
 *    @version last in https://github.com/ByteriX/BxObjC
 *    @copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *     Copyright (c) 2019 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxAlertView.h"

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface UIAlertController (Alert)

+ (UIAlertController *) alertWithTitle: (NSString* _Nonnull) title
                               message: (NSString* _Nonnull) message
                     cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
                         okButtonTitle: (NSString * __nullable) okButtonTitle
                               handler: (BxAlertHandler __nullable) handler;

- (void)show;
- (void)show:(BOOL)animated;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface UIViewController (Alert)

+ (void) showAlertWithTitle: (NSString* _Nonnull) title
                    message: (NSString* _Nonnull) message
          cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
              okButtonTitle: (NSString * __nullable) okButtonTitle
                    handler: (BxAlertHandler __nullable) handler API_AVAILABLE(ios(8.0), watchos(2.0));

- (void) showAlertWithTitle: (NSString* _Nonnull) title
                    message: (NSString* _Nonnull) message
          cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
              okButtonTitle: (NSString * __nullable) okButtonTitle
                    handler: (BxAlertHandler __nullable) handler API_AVAILABLE(ios(8.0), watchos(2.0));

@end

NS_ASSUME_NONNULL_END

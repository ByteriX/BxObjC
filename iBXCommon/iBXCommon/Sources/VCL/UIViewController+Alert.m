/**
 *    @file UIViewController+Alert.m
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

#import "UIViewController+Alert.h"

#import <objc/runtime.h>

@implementation UIAlertController (Alert)

+ (UIAlertController *) alertWithTitle: (NSString* _Nonnull) title
                message: (NSString* _Nonnull) message
      cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
          okButtonTitle: (NSString * __nullable) okButtonTitle
                handler: (BxAlertHandler __nullable) handler
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(NO);
        }
    }]];
    if (okButtonTitle) {
        [alert addAction: [UIAlertAction actionWithTitle: okButtonTitle style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(YES);
            }
        }]];
    }
    return alert;
}

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    UIViewController * rootController = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    [rootController presentViewController:self animated:animated completion:nil];
}

@end

@implementation UIViewController (UIViewController)

+ (void) showAlertWithTitle: (NSString* _Nonnull) title
                    message: (NSString* _Nonnull) message
          cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
              okButtonTitle: (NSString * __nullable) okButtonTitle
                    handler: (BxAlertHandler __nullable) handler
{
    UIAlertController * alert = [UIAlertController alertWithTitle: title message: message cancelButtonTitle: cancelButtonTitle okButtonTitle: okButtonTitle handler: handler];
    [alert show: YES];
}

- (void) showAlertWithTitle: (NSString* _Nonnull) title
                    message: (NSString* _Nonnull) message
          cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
              okButtonTitle: (NSString * __nullable) okButtonTitle
                    handler: (BxAlertHandler __nullable) handler
{
    UIAlertController * alert = [UIAlertController alertWithTitle: title message: message cancelButtonTitle: cancelButtonTitle okButtonTitle: okButtonTitle handler: handler];
    [self presentViewController: alert animated: YES completion: nil];
}



@end

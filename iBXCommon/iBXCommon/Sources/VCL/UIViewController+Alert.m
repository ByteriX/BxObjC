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

+ (UIAlertController *) actionSheetWithTitle: (NSString* _Nonnull) title
      cancelButtonTitle: (NSString * _Nonnull) cancelButtonTitle
      otherButtonTitles: (NSArray<NSString *> * __nullable) otherButtonTitles
                handler: (BxActionSheetHandler __nullable) handler
{
    NSInteger otherButtonsCount = otherButtonTitles.count;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: title message: nil preferredStyle: UIAlertControllerStyleActionSheet];
    [alert addAction: [UIAlertAction actionWithTitle: cancelButtonTitle style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(otherButtonsCount);
        }
    }]];
    if (otherButtonTitles.count > 0) {
        for (int index = 0; index < otherButtonsCount; index++) {
            [alert addAction: [UIAlertAction actionWithTitle: [otherButtonTitles objectAtIndex: index] style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(index);
                }
            }]];
        }
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

+ (void) showActionSheetWithTitle: (NSString *) title
                cancelButtonTitle: (NSString *) cancelButtonTitle
                otherButtonTitles: (NSArray *) otherButtonTitles
                   viewController: (UIViewController*) viewController
                          handler: (BxActionSheetHandler) handler

{
    UIAlertController * alertController = [UIAlertController actionSheetWithTitle: title cancelButtonTitle: cancelButtonTitle otherButtonTitles: otherButtonTitles handler: handler];
    [[alertController popoverPresentationController] setSourceView:viewController.view];
    [[alertController popoverPresentationController] setSourceRect: CGRectMake(viewController.view.bounds.size.width / 2, viewController.view.bounds.size.height - 1, 1, 1)];
    [[alertController popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionDown];
    [viewController presentViewController: alertController animated: YES completion: nil];
}

- (void) showActionSheetWithTitle: (NSString *) title
                cancelButtonTitle: (NSString *) cancelButtonTitle
                otherButtonTitles: (NSArray *) otherButtonTitles
                          handler: (BxActionSheetHandler) handler
{
    [UIViewController showActionSheetWithTitle: title
                             cancelButtonTitle: cancelButtonTitle
                             otherButtonTitles: otherButtonTitles
                                viewController: self
                                       handler: handler];
}

@end

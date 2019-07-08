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

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (Window)

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    // Applications that does not load with UIMainStoryboardFile might not have a window property:
    if ([delegate respondsToSelector:@selector(window)]) {
        // we inherit the main window tintColor
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    
    // window level is above the top window (this makes the alert, if it a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to ensure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

@end

@implementation UIViewController (UIViewController)

+ (void) alertWithTitle: (NSString* _Nonnull) title
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
    //[self presentViewController: alert animated: YES completion: nil];
    [alert show: YES];
}



@end

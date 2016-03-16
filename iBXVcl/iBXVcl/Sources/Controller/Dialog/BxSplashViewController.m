/**
 *	@file BxSplashViewController.m
 *	@namespace iBXVcl
 *
 *	@details Отображение сплеша
 *	@date 15.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxSplashViewController.h"

@implementation BxSplashViewController

static BOOL BxSplashViewControllerIsShow = NO;

- (void) viewDidLoad
{
	[super viewDidLoad];
    if (self.splashImage) {
        UIImageView * splashView = [[UIImageView alloc] initWithImage: self.splashImage];
        splashView.contentMode = UIViewContentModeScaleToFill;
        splashView.frame = self.view.bounds;
        splashView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview: splashView];
        [splashView release];
    }
    self.autoDismiss = YES;
}

- (void) timeOutDissmiss
{
    [self dismissAnimated: YES];
}

- (void) dismissDidStop {
    [super dismissDidStop];
    BxSplashViewControllerIsShow = NO;
}

- (void) execute
{
    if (self.action) {
        self.action();
    }
}

+ (void) checkFromParent: (UIViewController*) viewController image: (UIImage*) image time: (NSTimeInterval) time action: (BxSplashAction) action
{
    if (!BxSplashViewControllerIsShow) {
        BxSplashViewControllerIsShow = YES;
        __block BxSplashViewController * splashController = (BxSplashViewController *) [self.class new];
        splashController.splashImage = image;
        splashController.time = time;
        splashController.action = action;
        [splashController presentFromParent: viewController animated: NO];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [splashController execute];
            [NSThread sleepForTimeInterval: splashController.time];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [splashController timeOutDissmiss];
            });
        });
        //[splashController performSelector: @selector(timeOutDissmiss) withObject: nil afterDelay: time];
    }
}

+ (void) checkFromParent: (UIViewController*) viewController
{
    [self checkFromParent: viewController image: [UIImage imageNamed: @"Default"] time: 5.0 action: nil];
}

- (void) dealloc
{
    self.splashImage = nil;
    self.action = nil;
    [super dealloc];
}

@end

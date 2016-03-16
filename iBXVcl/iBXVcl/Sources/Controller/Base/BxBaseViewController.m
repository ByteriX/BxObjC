/**
 *	@file BxBaseViewController.m
 *	@namespace iBXVcl
 *
 *	@details Базовый контролер
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxBaseViewController.h"

@interface BxBaseViewController ()
{
    BOOL _lastNavigationHidden;
}

@end

@implementation BxBaseViewController

- (id)init
{
    self = [self initWithNibName: @"BxBaseViewController" bundle: [NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapAction)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer: tapRecognizer];
    [tapRecognizer release];
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    _lastNavigationHidden = self.navigationController.navigationBarHidden;
    if (!_lastNavigationHidden && _autoHideNavigationBar && _autoHideNavigationBarFromShow) {
        [self.navigationController setNavigationBarHidden: YES animated: YES];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (_autoHideNavigationBar) {
        if (_lastNavigationHidden != self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden: _lastNavigationHidden  animated: YES];
        }
    }
}

- (void) tapAction
{
    if (_autoHideNavigationBar) {
        [self.navigationController setNavigationBarHidden: !self.navigationController.navigationBarHidden animated: YES];
    }
}

@end

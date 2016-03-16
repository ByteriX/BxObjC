//
//  NavigationTestController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 1/30/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "NavigationTestController.h"
#import "BxVcl.h"
#import "BxCommon.h"
#import "BxNavigationController.h"

@interface NavigationTestController ()

@end

@implementation NavigationTestController

- (void) awakeFromNib
{
    _isExit = YES;
}

- (IBAction) btTrigerExitClick:(UIButton*)sender
{
    _isExit = !_isExit;
    sender.selected = !_isExit;
}

- (IBAction) btExitClick:(UIButton*)sender
{
     [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) btExitToRootClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController
{
    if (!_isExit) {
        [BxAlertView showAlertWithTitle: @"Внимание" message: @"Выйти нельзя, все равно выйти?" cancelButtonTitle: @"Отмена" okButtonTitle: @"OK" handler:^(BOOL isOK)
        {
            if (isOK) {
                [navigationController immediatePopViewControllerAnimated: YES];
            }
        }];
    }
    return _isExit;
}

- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController toController: (UIViewController*) toController
{
    if (!_isExit) {
        [BxAlertView showAlertWithTitle: @"Внимание" message: @"Выйти из данного контролера нельзя, все равно выйти?" cancelButtonTitle: @"Отмена" okButtonTitle: @"OK" handler:^(BOOL isOK)
                {
                    if (isOK) {
                        [navigationController immediatePopViewController: toController animated: YES];
                    }
                }];
    }
    return _isExit;
}

- (void) navigationWillPopController: (BxNavigationController*) navigationController
{
    [BxAlertView showAlertWithTitle: @"Поздравление" message: @"Мы слиняли" cancelButtonTitle: @"ОК" okButtonTitle: nil handler:nil];
}

- (UIView*) navigationToolPanelWithController: (BxNavigationController*) navigationController
{
    UISegmentedControl * _control = [[UISegmentedControl alloc] initWithFrame: CGRectMake(10, 6, 300, 28)];
    [_control insertSegmentWithTitle: @"Все" atIndex:0 animated: NO];
    [_control insertSegmentWithTitle: @"Как один" atIndex:0 animated: NO];
    [_control insertSegmentWithTitle: @"Три" atIndex:0 animated: NO];
    _control.selectedSegmentIndex = 1;
    UIView * result = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    [result addSubview: _control];
    return result;
}

@end

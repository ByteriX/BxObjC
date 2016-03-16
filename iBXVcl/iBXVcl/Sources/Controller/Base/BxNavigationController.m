/**
 *	@file BxNavigationController.m
 *	@namespace iBXVcl
 *
 *	@details UINavigationController с кучей прибалуток
 *	@date 30.01.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxNavigationController.h"
#import "BxNavigationBar.h"
#import "BxCommon.h"

@implementation UIViewController (BxNavigationController)

- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController
{
    return YES;
}

- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController toController: (UIViewController*) toController
{
    return YES;
}

- (void) navigationWillPopController: (BxNavigationController*) navigationController
{
    //
}

- (UIView*) navigationToolPanelWithController: (BxNavigationController*) navigationController
{
    return nil;
}

@end

@interface UINavigationController (BxNavigationController)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;
//- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item;

@end

@interface BxNavigationController ()

@property (nonatomic, weak) UIViewController * removedViewController;

@end

@implementation BxNavigationController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER) {
        [self.interactivePopGestureRecognizer addTarget: self action: @selector(handleNavigationPop:)];
    }
    [self setValue:[[BxNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    [self checkPanelController:self.topViewController animated:NO];
}

- (void) handleNavigationPop: (UIScreenEdgePanGestureRecognizer*) sender
{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
    
        [self performSelector: @selector(checkHandleNavigationPop) withObject: nil afterDelay: 0.3];
        
    }
}

- (void) checkHandleNavigationPop
{
    if (!self.removedViewController) {
        self.removedViewController = self.topViewController;
    }
    BOOL isBack = self.topViewController == self.removedViewController;
    if ( isBack ) {
        [self hidePanelAnimated: YES];
        [self checkPanelController:self.removedViewController animated: YES];
    } else {
        [self navigationWillPopToActiveController: self.removedViewController];
    }
    self.removedViewController = nil;
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _toolPanel.frame = CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), self.navigationBar.frame.size.width, _toolPanel.frame.size.height);
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController * thisController = self.topViewController;
    if (thisController.navigationItem == item) {
        if ([thisController respondsToSelector: @selector(navigationShouldPopController:)]) {
            if (![thisController navigationShouldPopController: self]){
                return NO;
            }
        }
    }
    if ([super respondsToSelector: @selector(navigationBar:shouldPopItem:)]) {
        return [super navigationBar: navigationBar shouldPopItem: item];
    }
    //[self immediatePopViewControllerAnimated: YES];
    return YES;
}

/*- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    if ([super respondsToSelector: @selector(navigationBar:didPopItem:)]) {
        [super navigationBar: navigationBar didPopItem: item];
    }
}  */

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * thisController = self.topViewController;
    if ([thisController respondsToSelector: @selector(navigationShouldPopController:)])
    {
        if ([thisController navigationShouldPopController: self]){
            return [self immediatePopViewControllerAnimated: animated];
        } else if ([thisController respondsToSelector: @selector(navigationShouldPopController:)]) {
            return thisController;
        }
    } else {
        return [self immediatePopViewControllerAnimated: animated];
    }
    return nil;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray * resultPopControllers = [NSMutableArray arrayWithCapacity: self.viewControllers.count];
    UIViewController * toController = viewController;
    for (UIViewController * thisController in [self.viewControllers reverseObjectEnumerator]) {
        if (thisController == viewController){
            break ;
        }
        if ([thisController respondsToSelector: @selector(navigationShouldPopController:toController:)]) {
            if ([thisController navigationShouldPopController: self toController: viewController]){
                [resultPopControllers addObject: thisController];
            } else {
                toController = thisController;
                break;
            }
        } else {
            [resultPopControllers addObject: thisController];
        }
    }
    if (resultPopControllers.count > 0){
        return [self immediatePopViewController: toController animated: animated];
    }
    return nil;
}

- (NSArray *) popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count > 0){
        return [self popToViewController: self.viewControllers[0] animated: animated];
    } else {
        return [super popToRootViewControllerAnimated: animated];
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self hidePanelAnimated: YES];
    [super pushViewController: viewController animated: animated];
    [self checkPanelController:viewController animated:animated];
}

- (void)checkPanelController:(UIViewController *)viewController animated: (BOOL) animated
{
    if (!viewController) {
        return;
    }
    BOOL hide = YES;
    if ([viewController respondsToSelector: @selector(navigationToolPanelWithController:)]){
        UIView * toolBar = [viewController navigationToolPanelWithController: self];
        if (toolBar){
            if (_toolPanel && toolBar != _toolPanel){ // так как панелька может обновиться, старую можно случайно потерять случайно и не удалить при выходе с экрана.
                [self hidePanelAnimated: animated];
            }
            _toolPanel = toolBar;
            _toolPanel.frame = CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), self.navigationBar.frame.size.width, _toolPanel.frame.size.height);
            _toolPanel.alpha = 0;
            [self.view addSubview: _toolPanel];
            if (animated){
                [UIView animateWithDuration: 0.5 animations:^{
                    _toolPanel.alpha = 1;
                }];
            } else {
                _toolPanel.alpha = 1;
            }
            hide = NO;
        }
    }
    if (hide) {
        [self hidePanelAnimated: animated];
    }
}

- (void) hidePanelAnimated: (BOOL) animated
{
    __weak UIView * popedToolPanel = _toolPanel;
    _toolPanel = nil;
    if (animated){
        [UIView animateWithDuration: 0.25
                         animations: ^{
            popedToolPanel.alpha = 0;
        }
                         completion:^(BOOL finished)
        {
            if (finished && popedToolPanel.alpha < 0.1) {
                [popedToolPanel removeFromSuperview];
            }
        }];
    } else {
        [popedToolPanel removeFromSuperview];
    }
}

- (NSArray *) immediatePopViewController: (UIViewController *) toController animated:(BOOL)animated
{
    for (UIViewController * thisController in [self.viewControllers reverseObjectEnumerator]) {
        if (thisController == toController){
            break ;
        }
        if ([thisController respondsToSelector: @selector(navigationWillPopController:)]) {
            [thisController navigationWillPopController: self];
        }
    }
    [self hidePanelAnimated: animated];
    self.removedViewController = self.topViewController;
    id removeControllers = [super popToViewController: toController animated: animated];
    [self checkPanelController:self.topViewController animated:animated];
    return removeControllers;
}

- (void) navigationWillPopToActiveController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector: @selector(navigationWillPopController:)]) {
        [viewController navigationWillPopController: self];
    }
}

- (BOOL) activeGestureRecognizer
{
    if (IS_OS_7_OR_LATER) {
        return self.interactivePopGestureRecognizer.enabled && (self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan || self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateChanged);
    }
    return NO;
}

- (UIViewController *) immediatePopViewControllerAnimated:(BOOL)animated
{
    if (![self activeGestureRecognizer])
    {
        [self navigationWillPopToActiveController: self.visibleViewController];
    }
    [self hidePanelAnimated: animated];
    self.removedViewController = self.topViewController;
    id removeController = [super popViewControllerAnimated: animated];
    [self checkPanelController:self.visibleViewController animated:animated];
    return removeController;
}

- (void) dealloc
{
    _toolPanel = nil;
}

@end

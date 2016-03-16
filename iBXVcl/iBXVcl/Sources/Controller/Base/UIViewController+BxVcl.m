/**
 *	@file UIViewController+BxVcl.m
 *	@namespace iBXVcl
 *
 *	@details UIViewController категория для перехода на дизайн iOS 7
 *	@date 25.11.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "UIViewController+BxVcl.h"
#import "BxCommon.h"
#import "BxNavigationController.h"

@implementation UIViewController (BxVcl)

- (CGFloat) topExtendedEdges
{
    if (IS_OS_7_OR_LATER) {
        if (!self.extendedLayoutIncludesOpaqueBars) {
            if ((self.edgesForExtendedLayout | UIRectEdgeTop) == self.edgesForExtendedLayout && self.navigationController.navigationBar) {
                CGFloat shift = 20.0f;
                if (!self.navigationController.navigationBarHidden) {
                    shift += self.navigationController.navigationBar.frame.size.height;
                }
                if ([self.navigationController isKindOfClass: BxNavigationController.class]) {
                    BxNavigationController * navController = (BxNavigationController*)self.navigationController;
                    shift += navController.toolPanel.frame.size.height;
                }
                return shift;
            }
        }
    }
    if ([self.navigationController isKindOfClass: BxNavigationController.class]) {
        BxNavigationController * navController = (BxNavigationController*)self.navigationController;
        return navController.toolPanel.frame.size.height;
    }
    return 0.0f;
}

- (CGFloat) bottomExtendedEdges
{
    if (IS_OS_7_OR_LATER) {
        if (!self.extendedLayoutIncludesOpaqueBars) {
            if ((self.edgesForExtendedLayout | UIRectEdgeBottom) == self.edgesForExtendedLayout && self.tabBarController) {
                CGFloat shift = self.tabBarController.tabBar.frame.size.height;
                return shift;
            }
        }
    }
    return 0.0f;
}

- (CGRect) extendedEdgesBounds
{
    CGRect rect = self.view.bounds;
    CGFloat shift = [self topExtendedEdges];
    rect.origin.y += shift;
    rect.size.height -= shift;
    shift = [self bottomExtendedEdges];
    rect.size.height -= shift;
    return rect;
}

+ (UIViewController *) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end

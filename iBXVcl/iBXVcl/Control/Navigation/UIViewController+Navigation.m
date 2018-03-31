/**
 *	@file UIViewController+Navigation.m
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

#import "UIViewController+Navigation.h"
#import "BxCommon.h"
#import "BxNavigationController.h"

@implementation UIViewController (Navigation)

- (CGFloat) bxNavigationPanelShiftY
{
    BxNavigationController * navController = self.navController;
    if (navController && !self.navigationController.navigationBarHidden) {
        return navController.toolPanel.frame.size.height;
    }
    return 0.0f;
}

- (CGFloat) topExtendedEdges
{
    if IS_OS_11_OR_LATER {
        return [self bxNavigationPanelShiftY];
    } else if (IS_OS_9_OR_LATER) {
        return self.topLayoutGuide.length + [self bxNavigationPanelShiftY];
    } else if (IS_OS_7_OR_LATER) {
        if (!self.extendedLayoutIncludesOpaqueBars) {
            if ((self.edgesForExtendedLayout | UIRectEdgeTop) == self.edgesForExtendedLayout && self.navigationController.navigationBar) {
                CGRect frame = [UIApplication sharedApplication].statusBarFrame;
                CGFloat shift = MIN(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
                if (!self.navigationController.navigationBarHidden) {
                    shift += self.navigationController.navigationBar.frame.size.height + [self bxNavigationPanelShiftY];
                }
                return shift;
            }
        }
    }
    // This is for iOS6
    BxNavigationController * navController = self.navController;
    if (navController && !self.navigationController.navigationBarHidden) {
        return navController.toolPanel.frame.size.height;
    }
    return 0.0f;
}

- (CGFloat) bottomExtendedEdges
{
    if IS_OS_11_OR_LATER {
        return 0.0f;
    } if (IS_OS_9_OR_LATER) {
        return self.bottomLayoutGuide.length;
    } else if (IS_OS_7_OR_LATER) {
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

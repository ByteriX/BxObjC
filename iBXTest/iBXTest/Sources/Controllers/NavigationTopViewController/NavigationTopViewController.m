//
//  NavigationTopViewController.m
//  DiscoverMoscow
//
//  Created by Balalaev Sergey on 4/3/13.
//  Copyright (c) 2013 Balalaev Sergey. All rights reserved.
//

#import "NavigationTopViewController.h"
#import "ECSlidingViewController.h"
#import "IconWorkspaceViewPagingTabController.h"
#import "IconWorkspaceViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NavigationTopViewController ()

@end

@implementation NavigationTopViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.clipsToBounds = YES;
    self.view.superview.backgroundColor = [UIColor clearColor];
    
    /*if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
     self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
     }*/
    
    /*if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
     self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
     }*/
    
    [self.view addGestureRecognizer: self.slidingViewController.panGesture];
    self.slidingViewController.panGesture.delegate = self;
    self.slidingViewController.panGesture.cancelsTouchesInView = NO;
    ((UIViewController*)self.viewControllers[0]).navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"icon_tabbar_settings.png"] style: UIBarButtonItemStylePlain target: self action: @selector(menuClick:)] autorelease];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.visibleViewController isKindOfClass: IconWorkspaceViewPagingTabController.class]) {
        IconWorkspaceViewPagingTabController * mainController = (IconWorkspaceViewPagingTabController*)self.visibleViewController;
        if ([mainController.selectedViewController isKindOfClass: IconWorkspaceViewController.class]) {
            //IconWorkspaceViewController * controller = (IconWorkspaceViewController*)mainController.selectedViewController;
            CGPoint point = [gestureRecognizer locationInView: mainController.view];
            if (point.y > 0) {
                return NO;
            }
        }
    }
    /*if ([self.visibleViewController isKindOfClass: MainSigmentedController.class]) {
        MainSigmentedController * mainController = (MainSigmentedController*)self.visibleViewController;
        if ([mainController.selectedViewController isKindOfClass: MapViewController.class]) {
            MapViewController * controller = (MapViewController*)mainController.selectedViewController;
            CGPoint point = [gestureRecognizer locationInView: controller.view];
            if (point.y > 64) {
                return NO;
            }
        }
    } else if ([self.visibleViewController isKindOfClass: SettingsCommentsViewController.class]) {
        SettingsCommentsViewController * controller = (SettingsCommentsViewController*)self.visibleViewController;
        CGPoint point = [gestureRecognizer locationInView: controller.view];
        if (point.y > 0) {
            return NO;
        }
    }*/
    return YES;
}

- (void) menuClick: (id) sender
{
    if ([self.slidingViewController underLeftShowing]) {
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}

@end

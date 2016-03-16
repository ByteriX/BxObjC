//
// Created by Balalaev Sergey on 9/29/14.
// Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "IconWorkspaceViewPagingTabController.h"
#import "IconWorkspaceViewController.h"
#import "IconWorkspaceViewSettingsController.h"


@interface IconWorkspaceViewPagingTabController () {

}
@property (nonatomic, strong) IconWorkspaceViewSettingsController * settingsController;
@property (nonatomic, strong) IconWorkspaceViewController * itemsListController;

@end

@implementation IconWorkspaceViewPagingTabController

- (void) viewDidLoad
{
    if (!self.settingsController || !self.itemsListController) {
        self.settingsController = [self.storyboard instantiateViewControllerWithIdentifier: @"IconWorkspaceViewSettingsController"];
        self.itemsListController = [self.storyboard instantiateViewControllerWithIdentifier: @"IconWorkspaceViewController"];
        //self.settingsController.owner = self.itemsListController;
    }
    self.viewControllers = @[self.itemsListController, self.settingsController];
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationItem.rightBarButtonItem = self.itemsListController.navigationItem.rightBarButtonItem;
    self.delegate = self;
}

- (void)segmentPageController:(JCMSegmentPageController *)segmentPageController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    if (index == 1) {
        [self.itemsListController viewWillDisappear: NO];
        [self.settingsController viewWillAppear: NO];
        self.navigationItem.rightBarButtonItem = self.settingsController.navigationItem.rightBarButtonItem;
    } else {
        [self.settingsController viewWillDisappear: NO];
        [self.itemsListController viewWillAppear: NO];
        self.navigationItem.rightBarButtonItems = self.itemsListController.navigationItem.rightBarButtonItems;
    }
    self.navigationItem.titleView = self.segmentedControl;
}
@end
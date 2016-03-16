//
//  ItemsListController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 2/13/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "ItemsListPagingTabController.h"
#import "BxItemsListViewController.h"
#import "ItemsListSettingsController.h"

@interface ItemsListPagingTabController () <JCMSegmentPageControllerDelegate>

@property (nonatomic, strong) ItemsListSettingsController * settingsController;
@property (nonatomic, strong) BxItemsListViewController * itemsListController;

@end

@implementation ItemsListPagingTabController

- (void) viewDidLoad
{
    if (!self.settingsController || !self.itemsListController) {
        self.settingsController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemsListSettingsController"];
        self.itemsListController = [self.storyboard instantiateViewControllerWithIdentifier: @"BxItemsListViewController"];
        self.settingsController.owner = self.itemsListController;
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

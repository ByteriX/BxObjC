//
//  TestSegmentPageController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 11/6/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "TestSegmentPageController.h"

@interface TestSegmentPageController ()

@end

@implementation TestSegmentPageController


- (void)viewDidLoad
{
    self.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier: @"TestTableController1"], [self.storyboard instantiateViewControllerWithIdentifier: @"TestTableController2"]];
    [super viewDidLoad];
    self.contentContainerView.frame = self.view.bounds;
    self.navigationItem.titleView = self.segmentedControl;
    self.headerContainerView.alpha = 0.0;
    
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
    } else {
        
    }
}


@end

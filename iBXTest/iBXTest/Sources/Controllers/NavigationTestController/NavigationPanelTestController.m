//
//  NavigationPanelTestController.m
//  iBXTest
//
//  Created by Sergan on 20.07.14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "NavigationPanelTestController.h"
#import "BxVcl.h"

@implementation NavigationPanelTestController

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    cell.textLabel.text = @"Text maximum";
    return cell;
}

- (UIView*) navigationToolPanelWithController: (BxNavigationController*) navigationController
{
    UISegmentedControl * _control = [[UISegmentedControl alloc] initWithFrame: CGRectMake(10, 6, 300, 28)];
    [_control insertSegmentWithTitle: @"Новый" atIndex:0 animated: NO];
    [_control insertSegmentWithTitle: @"New" atIndex:0 animated: NO];
    _control.selectedSegmentIndex = 1;
    UIView * result = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    [result addSubview: _control];
    return result;
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topY = self.topExtendedEdges;
    CGFloat h = self.tableView.contentInset.bottom;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topY, 0, h, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topY, 0, h, 0);
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.bxNavigationBar.scrollView = self.tableView;
    CGFloat topY = self.topExtendedEdges;
    [self.tableView setContentOffset: CGPointMake(0, -topY) animated: NO];
}

@end

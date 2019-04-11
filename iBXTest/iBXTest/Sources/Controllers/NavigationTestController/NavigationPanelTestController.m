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
    if (_isSizing) {
        return 25;
    } else {
        return 9; // 12
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    cell.textLabel.text = [NSString stringWithFormat: @"Text maximum %d", (int)indexPath.row];
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
    BxNavigationBarShakeXEffect * effect = [[BxNavigationBarShakeXEffect alloc] initWithView: _control];
    self.navigationController.bxNavigationBar.scrollEffects = [NSArray<BxNavigationBarEffectProtocol> arrayWithObject: effect];
    return result;
}

- (UIView*) navigationBackgroundWithController: (BxNavigationController*) navigationController
{
    if (_isSizing) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"common_background1.jpg"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        return imageView;
    } else {
        return nil;
    }
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topY = self.topExtendedEdges;
    CGFloat bottomY = self.bottomExtendedEdges;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topY, 0, bottomY, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topY, 0, bottomY, 0);
    
}

- (void) awakeFromNib {
    [super awakeFromNib];
    _isSizing = YES;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
     CGFloat topY = self.topExtendedEdges;
    [self.tableView setContentOffset: CGPointMake(0, -topY) animated: NO];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.bxNavigationBar.scrollView = self.tableView;
    self.navigationController.bxNavigationBar.scrollLimitation = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.navigationController.bxNavigationBar.scrollLimitation = YES;
}

@end

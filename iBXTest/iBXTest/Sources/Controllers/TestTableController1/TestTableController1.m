//
//  TestTableController1.m
//  iBXTest
//
//  Created by Balalaev Sergey on 11/6/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "TestTableController1.h"

@interface TestTableController1 ()

@end

@implementation TestTableController1

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat topBarOffset = self.topLayoutGuide.length + self.navigationController.navigationBar.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(topBarOffset, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topBarOffset, 0, 0, 0);
}


@end

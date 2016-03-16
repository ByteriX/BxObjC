//
//  NavigationCommonTestController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 12/2/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "NavigationCommonTestController.h"

@interface NavigationCommonTestController ()

@end

@implementation NavigationCommonTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) dealloc
{
    NSLog(@"dealloc NavigationFirstTestController");
}

@end

//
// Created by Balalaev Sergey on 10/2/14.
// Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "BxServiceTestController.h"


@implementation BxServiceTestController {

}

- (void) viewDidLoad
{
    [super viewDidLoad];
    //self.autoDismiss = YES;
    self.autoBackground = YES;

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    [self.view addSubview: view];
    view.multipleTouchEnabled = NO;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height / 2.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.cornerRadius = 10;
    [button setTitle:@"Text label" forState:UIControlStateNormal] ;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btClick) forControlEvents:UIControlEventTouchUpInside] ;
    [view addSubview:button];

}

- (void)btClick {
    //
}

@end
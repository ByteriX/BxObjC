//
// Created by Balalaev Sergey on 9/29/14.
// Copyright (c) 2014 ByteriX. All rights reserved.
//

#import <iBXVcl/BxIconWorkspaceView.h>
#import <iBXVcl/BxPageControl.h>
#import "IconWorkspaceViewController.h"


@implementation IconWorkspaceViewController {

}

- (void) awakeFromNib
{
    self.title = @"Рабочий стол";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconWorkspaceView.backgroundColor = [UIColor lightGrayColor];
    self.iconWorkspaceView.delegate = self;
    self.iconWorkspaceView.pageControl.activeImage = [UIImage imageNamed: @"common_rotatordot_rotator_on"];
    self.iconWorkspaceView.pageControl.inactiveImage = [UIImage imageNamed: @"common_rotatordot_rotator_off"];
    [self startPages];
}

- (void)startPages {
    BxIconWorkspacePageView * page1 = [[BxIconWorkspacePageView alloc] initWithFrame: CGRectZero];
    [page1 addIcon:[[BxIconWorkspaceItemControl alloc] initWithTitle:@"Test 1"
                                                               image:[UIImage imageNamed: @"testicon1.png"]
                                                              target:self
                                                              action:@selector(clickAction)
                                                              idName:@"test1"]];

    [page1 addIcon:[[BxIconWorkspaceItemControl alloc] initWithTitle:@"Test 2"
                                                               image:[UIImage imageNamed: @"testicon2.png"]
                                                              target:self
                                                              action:@selector(clickAction)
                                                              idName:@"test2"]];

    [page1 addIcon:[[BxIconWorkspaceItemControl alloc] initWithTitle:@"Test 3"
                                                               image:[UIImage imageNamed: @"testicon3.png"]
                                                              target:self
                                                              action:@selector(clickAction)
                                                              idName:@"test3"]];

    [page1 addIcon:[[BxIconWorkspaceItemControl alloc] initWithTitle:@"Test 4"
                                                               image:[UIImage imageNamed: @"testicon2.png"]
                                                              target:self
                                                              action:@selector(clickAction)
                                                              idName:@"test4"]];

    BxIconWorkspacePageView * page2 = [[BxIconWorkspacePageView alloc] initWithFrame: CGRectZero];

    [self.iconWorkspaceView updateWithPages: @[page1, page2 ] idName: @"new001"];

    //[self.iconWorkspaceView updateWithPages: @[[[BxIconWorkspacePageView alloc] initWithFrame: CGRectZero] ] idName: nil];
    //_iconWorkspaceView.editable = NO;
}

- (void)clickAction {
    NSString * platform = @"";
    if (IS_480) {
        platform = [NSString stringWithFormat: @"%@, iPhone 4", platform];
    }
    if (IS_568) {
        platform = [NSString stringWithFormat: @"%@, iPhone 5", platform];
    }
    if (IS_667) {
        platform = [NSString stringWithFormat: @"%@, iPhone 6", platform];
    }
    if (IS_736) {
        platform = [NSString stringWithFormat: @"%@, iPhone 6 +", platform];
    }
   [BxAlertView showError: platform];
}

- (void) iconWorkspaceView: (BxIconWorkspaceView*) view onEdition: (BOOL) onEdition
{
    UIBarButtonItem * btDone = nil;
    if (onEdition){
        btDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: view action: @selector(done)];
    }
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem: btDone animated: YES];
}

@end
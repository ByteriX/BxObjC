//
//  NavigationBackgroundController.m
//  iBXTest
//
//  Created by Sergey Balalaev on 04/06/2017.
//  Copyright © 2017 ByteriX. All rights reserved.
//

#import "NavigationBackgroundController.h"
#import "BxVcl.h"

@interface NavigationBackgroundController ()

@property (retain, nonatomic) IBOutlet UIButton *navigationRemoveButton;
@property (retain, nonatomic) IBOutlet UIButton *returnPanelButton;

@end

@implementation NavigationBackgroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*) navigationBackgroundWithController: (BxNavigationController*) navigationController
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"common_background1.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (IBAction)navigationRemoveClick:(id)sender {
    if (_navigationRemoveButton.isSelected) {
        [self.navController setNavigationBarHidden: NO animated: YES];
        [_navigationRemoveButton setSelected: NO];
    } else {
        [self.navController setNavigationBarHidden: YES animated: YES];
        [_navigationRemoveButton setSelected: YES];
    }
}

- (IBAction)backClick:(id)sender {
    if (_navigationRemoveButton.isSelected && _returnPanelButton.isSelected)
    {
        [self.navController setNavigationBarHidden: NO animated: YES];
    }
    [self.navigationController popViewControllerAnimated: YES];
}
- (IBAction)returnPanelClick:(id)sender {
    [_returnPanelButton setSelected: !_returnPanelButton.isSelected];
}

- (void)dealloc {
    [_navigationRemoveButton release];
    [_returnPanelButton release];
    [super dealloc];
}

@end

//
//  NavigationFirstTestControllerViewController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 7/21/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "NavigationFirstTestController.h"
#import "BxVcl.h"
#import "NavigationPanelTestController.h"

@interface NavigationFirstTestController ()

@property (nonatomic, strong) UIView * toolView;

@end

@implementation NavigationFirstTestController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        UISegmentedControl * _control = [[UISegmentedControl alloc] initWithFrame: CGRectMake(10, 6, 300, 28)];
        [_control insertSegmentWithTitle: @"Первый" atIndex:0 animated: NO];
        [_control insertSegmentWithTitle: @"Сразу" atIndex:0 animated: NO];
        _control.selectedSegmentIndex = 1;
        _control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        UIView * result = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
        [result addSubview: _control];
        self.toolView = result;
    }
    return self;
}

- (UIView*) navigationToolPanelWithController: (BxNavigationController*) navigationController
{
    return self.toolView;
}

- (UIView*) navigationBackgroundWithController: (BxNavigationController*) navigationController
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"common_background1.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"withoutSizing"]) {
        NavigationPanelTestController * controller = segue.destinationViewController;
        controller.isSizing = NO;
    }
}

- (void) dealloc
{
    //NSLog(@"dealloc NavigationFirstTestController");
}

@end

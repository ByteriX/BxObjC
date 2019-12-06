//
//  InitialSlidingViewController.m
//  DiscoverMoscow
//
//  Created by Balalaev Sergey on 4/3/13.
//  Copyright (c) 2013 Balalaev Sergey. All rights reserved.
//

#import "InitialSlidingViewController.h"
#import "MainMenuController.h"


@interface InitialSlidingViewController ()

@end

@implementation InitialSlidingViewController

static CGFloat AnchorRevealAmount = 260.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldAllowUserInteractionsWhenAnchored = NO;
    self.shouldAllowPanningPastAnchor = YES;
    self.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.topViewController) {
        [self setAnchorLeftRevealAmount: AnchorRevealAmount];
        [self setAnchorRightRevealAmount: AnchorRevealAmount];
        self.underRightWidthLayout = ECFixedRevealWidth;
        self.underLeftWidthLayout = ECFixedRevealWidth;
        
        self.underLeftViewController  = [[self.storyboard instantiateViewControllerWithIdentifier: @"MainMenu"] retain];
        
        //self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"MainSigmentedController"];
        
        
       
        //
    }
    [super viewWillAppear:animated];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}*/

- (BOOL)shouldAutorotate
{
    return YES;
}
/*- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}*/

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDarkContent;
}

@end

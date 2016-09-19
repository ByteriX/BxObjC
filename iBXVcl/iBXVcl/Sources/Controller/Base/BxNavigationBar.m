/**
 *	@file BxNavigationBar.m
 *	@namespace iBXVcl
 *
 *	@details Специальная панель UINavigationBar для BxNavigationController
 *	@date 30.01.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxNavigationBar.h"
#import "BxNavigationController.h"
#import "BxCommon.h"

@interface BxNavigationBar ()

@property (nonatomic, strong) UIToolbar * toolPanel;
@property (nonatomic, copy) NSString * backgroundClassName;

@end

@implementation BxNavigationBar

- (id) init
{
    self = [super init];
    if (IS_OS_10_OR_LATER) {
        self.backgroundClassName = @"_UIBarBackground";
    } else {
        self.backgroundClassName = @"_UINavigationBarBackground";
    }
    return self;
}

- (UIView*) backgroundView
{
    for (UIView *view in self.subviews)
    {
        if ([NSStringFromClass(view.class) isEqualToString: self.backgroundClassName]){
            return  view;
        }
    }
    return nil;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UIView * view = [self backgroundView];
    
    __weak BxNavigationController * navigationController = nil;
    if ([self.delegate isKindOfClass: BxNavigationController.class]) {
        navigationController = (BxNavigationController*)self.delegate;
    }
    
    if (IS_OS_7_OR_LATER) {
        CGFloat shift = 0;
        if (navigationController) {
            shift = navigationController.toolPanel.frame.size.height;
        }
        [UIView animateWithDuration: 0.3 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.frame.size.height + 20 + shift);
        }];
    } else {
        CGFloat shift = 0;
        if (navigationController) {
            shift = navigationController.toolPanel.frame.size.height;
            if (!_toolPanel) {
                self.toolPanel = [[UIToolbar alloc] initWithFrame: CGRectZero];
                [self addSubview: _toolPanel];
            }
            self.toolPanel.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + self.frame.size.height, view.frame.size.width, shift);
            self.toolPanel.tintColor = self.tintColor;
        }
    }
}

- (void) dealloc
{
    self.toolPanel = nil;
}

@end

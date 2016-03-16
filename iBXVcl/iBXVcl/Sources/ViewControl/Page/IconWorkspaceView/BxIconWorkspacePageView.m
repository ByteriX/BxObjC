/**
 *	@file BxIconWorkspacePageView.m
 *	@namespace iBXVcl
 *
 *	@details Страница для рабочего стола с иконками
 *	@date 29.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxIconWorkspacePageView.h"
#import "BxIconWorkspaceItemControl.h"

@interface BxIconWorkspaceItemControl ()

@property (nonatomic) BOOL isMoved;
@property (nonatomic, weak) UIView * backSuperView;

@end


@implementation BxIconWorkspacePageView

//! override
- (id) initWithFrame: (CGRect) rect
{
    if (self = [super initWithFrame: rect]){
        _icons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addIcon: (BxIconWorkspaceItemControl*) icon
{
    [_icons addObject: icon];
    [self initIcon:icon];
}

- (void) insertIcon: (BxIconWorkspaceItemControl*) icon atIndex: (NSUInteger) index
{
    [_icons insertObject: icon atIndex: index];
    [self initIcon:icon];
}

- (void)initIcon:(BxIconWorkspaceItemControl *)icon {
    if (icon.isMoved) {
        icon.backSuperView = self;
    } else {
        [self addSubview:icon];
    }
}

@end
/**
 *	@file BxNavigationBar.h
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

#import <UIKit/UIKit.h>
#import "BxNavigationBarEffectProtocol.h"

@class BxNavigationController;

static CGFloat bxNavigationDurationTime = 0.5;

typedef NS_ENUM(NSInteger, BxNavigationBarScrollState) {
    BxNavigationBarScrollStateNone,
    BxNavigationBarScrollStateDown,
    BxNavigationBarScrollStateUp
};

typedef NS_ENUM(NSInteger, BxNavigationBarState) {
    BxNavigationBarStateShown,
    BxNavigationBarStateFloat,
    BxNavigationBarStateHidden
};

@interface BxNavigationBar : UINavigationBar

//! This need define in viewWillApear, for scrolling naviationBar
//! from pop or push navigation this property will get nil
@property (strong, nonatomic) UIScrollView *scrollView;
//! Effects from user scrolling behaviors
@property(copy, nonatomic) NSArray<BxNavigationBarEffectProtocol> * scrollEffects;
//! If scroll is small all effects ignored. Default is YES.
@property(nonatomic) BOOL scrollLimitation UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic, readonly) BxNavigationBarScrollState scrollState;
    @property (assign, nonatomic, readonly) BxNavigationBarState state;

@property(strong, nonatomic, readonly) BxNavigationController *navController;

//! Default Pi = 3,14
@property(nonatomic) CGFloat toolFadeFactor UI_APPEARANCE_SELECTOR;
//! Default 20
@property(nonatomic) CGFloat nativeFadeFactor UI_APPEARANCE_SELECTOR;

//@property(nonatomic) BOOL isScrollLockedWhenSmall UI_APPEARANCE_SELECTOR;



- (UIView*) backgroundView;

@end



@interface UINavigationController (BxNavigationBar)

@property(strong, nonatomic, readonly) BxNavigationBar *bxNavigationBar;

@end

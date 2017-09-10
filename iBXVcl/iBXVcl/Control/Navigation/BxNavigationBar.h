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

typedef NS_ENUM(NSInteger, BxNavigationBarScrollState) {
    BxNavigationBarScrollStateNone,
    BxNavigationBarScrollStateDown,
    BxNavigationBarScrollStateUp
};

@interface BxNavigationBar : UINavigationBar

//! This need define in viewWillApear, for scrolling naviationBar
//! from pop or push navigation this property will get nil
@property (strong, nonatomic) UIScrollView *scrollView;
//! Effects from user scrolling behaviors
@property(copy, nonatomic) NSArray<BxNavigationBarEffectProtocol> * scrollEffects;
//! If scroll is small all effects ignored. Default is NO.
@property(nonatomic) BOOL scrollLimitation;

@property (assign, nonatomic, readonly) BxNavigationBarScrollState scrollState;

@property(strong, nonatomic, readonly) BxNavigationController *navController;



- (UIView*) backgroundView;

@end



@interface UINavigationController (BxNavigationBar)

@property(strong, nonatomic, readonly) BxNavigationBar *bxNavigationBar;

@end

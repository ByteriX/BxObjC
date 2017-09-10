//
//  BxNavigationBarEffectProtocol.h
//  iBXVcl
//
//  Created by Sergey Balalaev on 16/12/16.
//  Copyright © 2016 Byterix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BxNavigationBar;

@protocol BxNavigationBarEffectProtocol

@property (weak, nonatomic) UIView * view;

- (void) startingMotionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift;

- (void) motionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift;

- (void) finishingMotionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift;

@end

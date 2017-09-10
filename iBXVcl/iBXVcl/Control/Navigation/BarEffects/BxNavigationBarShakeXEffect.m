//
//  BxNavigationBarShakeXEffect.m
//  iBXVcl
//
//  Created by Sergey Balalaev on 16/12/16.
//  Copyright © 2016 Byterix. All rights reserved.
//

#import "BxNavigationBarShakeXEffect.h"
#import "BxNavigationBar.h"
#import "UIView+ShakeAnimation.h"

@implementation BxNavigationBarShakeXEffect

- (instancetype) initWithView: (UIView *) view breakFactor: (CGFloat) breakFactor duration: (CGFloat) duration
{
    self = [self init];
    if (self) {
        self.view = view;
        _breakFactor = breakFactor;
        _duration = duration;
    }
    return self;
}

- (instancetype) initWithView: (UIView *) view
{
    return [self initWithView:view breakFactor: 0.65 duration: 0.75];
}

- (void) startingMotionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift;
{
    //
}

- (void) motionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift
{
    //
}

- (void) finishingMotionWithNavigationBar: (BxNavigationBar*) navigationBar shift: (CGFloat) shift
{
    if (navigationBar.scrollState == BxNavigationBarScrollStateUp) {
        return;
    }
    [self.view shakeXWithOffset: fabs(shift)
                    breakFactor: _breakFactor
                       duration: _duration + fabs(shift / 100.0f)
                      maxShakes: fabs(shift * 2)];
}

@end

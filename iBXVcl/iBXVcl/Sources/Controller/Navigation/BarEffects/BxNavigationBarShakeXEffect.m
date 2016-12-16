//
//  BxNavigationBarShakeXEffect.m
//  iBXVcl
//
//  Created by Sergey Balalaev on 16/12/16.
//  Copyright © 2016 Byterix. All rights reserved.
//

#import "BxNavigationBarShakeXEffect.h"
#import "BxNavigationBar.h"

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


@implementation UIView (ShakeAnimation)

- (void)shakeXWithOffset: (CGFloat) offset
             breakFactor: (CGFloat) breakFactor
                duration: (CGFloat) duration
               maxShakes: (NSInteger) maxShakes
{
    static NSString * animationName = @"position";
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: animationName];
    [animation setDuration: duration];
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity: 128];
    NSInteger shakeStep = maxShakes;
    while(offset > 0.01) {
        [keys addObject: [NSValue valueWithCGPoint: CGPointMake(self.center.x - offset, self.center.y)]];
        offset *= breakFactor;
        [keys addObject: [NSValue valueWithCGPoint: CGPointMake(self.center.x + offset, self.center.y)]];
        offset *= breakFactor;
        shakeStep--;
        if(shakeStep <= 0) {
            break;
        }
    }
    animation.values = keys;
    [self.layer addAnimation: animation forKey: animationName];
}

@end

//
//  UIView+ShakeAnimation.m
//  iBXVcl
//
//  Created by Sergey Balalaev on 10/09/2017.
//  Copyright © 2017 Byterix. All rights reserved.
//

#import "UIView+ShakeAnimation.h"

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

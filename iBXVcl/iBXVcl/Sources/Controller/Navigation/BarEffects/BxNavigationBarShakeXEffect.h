//
//  BxNavigationBarShakeXEffect.h
//  iBXVcl
//
//  Created by Sergey Balalaev on 16/12/16.
//  Copyright © 2016 Byterix. All rights reserved.
//

#import "BxNavigationBarEffectProtocol.h"

@interface BxNavigationBarShakeXEffect : NSObject <BxNavigationBarEffectProtocol>

@property (weak, nonatomic) UIView * view;
@property (nonatomic) CGFloat breakFactor;
@property (nonatomic) CGFloat duration;


- (instancetype) initWithView: (UIView *) view breakFactor: (CGFloat) breakFactor duration: (CGFloat) duration;
- (instancetype) initWithView: (UIView *) view;

@end

@interface UIView (ShakeAnimation)

- (void)shakeXWithOffset: (CGFloat) offset
             breakFactor: (CGFloat) breakFactor
                duration: (CGFloat) duration
               maxShakes: (NSInteger) maxShakes;

@end

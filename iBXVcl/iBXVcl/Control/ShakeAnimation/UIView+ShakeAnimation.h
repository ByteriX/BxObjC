//
//  UIView+ShakeAnimation.h
//  iBXVcl
//
//  Created by Sergey Balalaev on 10/09/2017.
//  Copyright © 2017 Byterix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShakeAnimation)
    
- (void)shakeXWithOffset: (CGFloat) offset
             breakFactor: (CGFloat) breakFactor
                duration: (CGFloat) duration
               maxShakes: (NSInteger) maxShakes;
    
@end

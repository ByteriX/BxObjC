/**
 *	@file ItemsListPanGestureRecognizer.m
 *	@namespace iBXVcl
 *
 *	@details Жесты для линейного списка
 *	@date 24.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "ItemsListPanGestureRecognizer.h"

@interface UIPanGestureRecognizer (private)

- (void) setState: (UIGestureRecognizerState)state;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@implementation ItemsListPanGestureRecognizer {

    NSDate * _beginTime;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _beginTime = [[NSDate date] retain];
    [super touchesBegan: touches withEvent: event];
    [super setState: UIGestureRecognizerStateBegan];

}

- (void) setState: (UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateEnded) {
        _lastTime = - [_beginTime timeIntervalSinceNow];
    }
    [super setState: state];
}

@end
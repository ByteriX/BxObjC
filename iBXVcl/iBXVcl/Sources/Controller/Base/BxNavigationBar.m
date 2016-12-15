/**
 *	@file BxNavigationBar.m
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

#import "BxNavigationBar.h"
#import "BxNavigationController.h"
#import "BxCommon.h"

@implementation  BxNavigationBarMotionEffect

- (instancetype) initWithView: (UIView *) view
{
    self = [self init];
    if (self) {
        self.view = view;
    }
    return self;
}

@end

@interface UIView (ShakeAnimation)

- (void)shakeXWithOffset: (CGFloat) offset
             breakFactor: (CGFloat) breakFactor
                duration: (CGFloat) duration
               maxShakes: (NSInteger) maxShakes;

@end

@interface BxNavigationController (private)

@property (nonatomic) CGFloat scrollOffset;

@end


@interface BxNavigationBar () <UIGestureRecognizerDelegate>
{
    CGFloat _startTouchY;
    CGFloat _startY;
    CGPoint _lastTouch;
    CGFloat _lastPower;
    
    CGFloat _lastScrollOffset;
}

@property (nonatomic, strong) UIToolbar * toolPanel;
@property (nonatomic, copy) NSString * backgroundClassName;

@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;

@end

@implementation BxNavigationBar

@dynamic navController;

static CGFloat minimalAlpha = 0.00001f;

- (id) init
{
    self = [super init];
    if (IS_OS_10_OR_LATER) {
        self.backgroundClassName = @"_UIBarBackground";
    } else {
        self.backgroundClassName = @"_UINavigationBarBackground";
    }
    
    _scrollState = BxNavigationBarScrollStateNone;
    _lastScrollOffset = 0;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(gesturePan:)];
    self.panGesture.delegate = self;
    self.panGesture.cancelsTouchesInView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarDidChange)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    
    return self;
}

- (UIView*) backgroundView
{
    for (UIView *view in self.subviews)
    {
        if ([NSStringFromClass(view.class) isEqualToString: self.backgroundClassName]){
            return  view;
        }
    }
    return nil;
}

- (BxNavigationController*) navController
{
    if ([self.delegate isKindOfClass: BxNavigationController.class]) {
        return (BxNavigationController*)self.delegate;
    }
    return nil;
}

- (void) setBackgroundWithShift: (CGFloat) shift
{
    UIView * view = [self backgroundView];
    
    __weak BxNavigationController * navigationController = self.navController;
    
    if (IS_OS_7_OR_LATER) {
        if (navigationController) {
            shift += navigationController.toolPanel.frame.size.height;
        }
        [UIView animateWithDuration: 0.3 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.frame.size.height + 20 + shift);
        }];
    } else {
        if (navigationController) {
            shift += navigationController.toolPanel.frame.size.height;
            if (!_toolPanel) {
                self.toolPanel = [[UIToolbar alloc] initWithFrame: CGRectZero];
                [self addSubview: _toolPanel];
            }
            self.toolPanel.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + self.frame.size.height, view.frame.size.width, shift);
            self.toolPanel.tintColor = self.tintColor;
        }
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self setBackgroundWithShift: 0];
    
//    if (self.scrollView) {
//        CGFloat scrollOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
//        if  (scrollOffset < 0) {
//            NSLog(@"scrollOffset = %@", scrollOffset);
//            [self shiftBackgroundWithShift: -scrollOffset];
//        } else {
//            [self shiftBackgroundWithShift: 0];
//        }
//        
//    } else {
//        [self shiftBackgroundWithShift: 0];
//    }
}

// For scroll methods
- (void) setScrollView:(UIScrollView*)scrollView
{
    [self resetScrollStateWithAnimation: NO];
    
    _scrollView = scrollView;
    
    if (self.panGesture.view) {
        [self.panGesture.view removeGestureRecognizer: self.panGesture];
    }
    
    if (scrollView) {
        [scrollView addGestureRecognizer: self.panGesture];
    }
}

- (void) resetScrollStateWithAnimation: (BOOL) animated
{
    _scrollState = BxNavigationBarScrollStateNone;
    CGRect frame = self.frame;
    frame.origin.y = [self scrollTopOffset];
    [self setFrame: frame alpha: 1.0f scrollOffset: 0.0f animated: animated];
}

- (void) statusBarDidChange
{
    [self resetScrollStateWithAnimation: NO];
}

- (void) applicationDidBecomeActive
{
    [self resetScrollStateWithAnimation: NO];
}

- (BOOL) gestureRecognizer: (UIGestureRecognizer*) gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer*) otherGestureRecognizer
{
    return YES;
}

- (CGFloat) scrollTopOffset
{
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat result = MIN(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    static CGFloat minimalResult = 20.0f;
    if (result > minimalResult) {
        result -= minimalResult;
    }
    return result;
}

- (void) gesturePan: (UIPanGestureRecognizer*) gesture
{
    if (_scrollView == nil || gesture.view != _scrollView) {
        return;
    }
    
    CGPoint touch = [gesture translationInView: _scrollView.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _startTouchY = touch.y;
        _startY = self.frame.origin.y;
        _scrollState = BxNavigationBarScrollStateNone;
        _lastTouch = touch;
        return;
    }
    
    BOOL isSmallScrolling = self.scrollView.contentSize.height < self.scrollView.frame.size.height + 2 * self.bounds.size.height;
    BOOL isScrollingX = fabs(touch.x - _lastTouch.x) > fabs(touch.y - _lastTouch.y);
    
    if (self.scrollState == BxNavigationBarScrollStateNone && (isSmallScrolling || isScrollingX))
    {
        _startTouchY = touch.y;
        _lastTouch = touch;
        return;
    }
    
    CGFloat power =  touch.y - _lastTouch.y;
    if (touch.y > _lastTouch.y) {
        _scrollState = BxNavigationBarScrollStateDown;
    } else if (touch.y < _lastTouch.y) {
        _scrollState = BxNavigationBarScrollStateUp;
    }
    _lastTouch = touch;
    
    CGFloat maxY = [self scrollTopOffset];
    CGFloat minY = maxY - self.frame.size.height;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        minY = minY + 1.0f;
    }
    BxNavigationController * navigationController = self.navController;
    if (navigationController.toolPanel) {
        minY -= navigationController.toolPanel.frame.size.height;
    }

    CGFloat alpha = 1.0f;
    CGRect frame = self.frame;
    CGFloat y = _startY + touch.y - _startTouchY;
    CGFloat scrollOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
    
    bool isScrolling = (self.scrollState == BxNavigationBarScrollStateUp ||
                        self.scrollState == BxNavigationBarScrollStateDown);
    bool isStopingPan = (gesture.state == UIGestureRecognizerStateEnded ||
                            gesture.state == UIGestureRecognizerStateCancelled);
    
    // это тоже надо поправить, тут лучше бывает уходить в напрвлении "к кому сейчас ближе"
    if (isScrolling && isStopingPan) {
        if (self.scrollState == BxNavigationBarScrollStateDown && y < minY) {
            _scrollState = BxNavigationBarScrollStateUp;
        }
        if (self.scrollState == BxNavigationBarScrollStateUp && y > maxY) {
            _scrollState = BxNavigationBarScrollStateDown;
        }
        
        if (self.scrollState == BxNavigationBarScrollStateDown) {
            frame.origin.y = maxY;
            alpha = 1.0f;
        } else if (self.scrollState == BxNavigationBarScrollStateUp) {
            frame.origin.y = minY;
            alpha = minimalAlpha;
        }
        [self setFrame: frame alpha: alpha scrollOffset: 0.0f animated: YES];
        _scrollState = BxNavigationBarScrollStateNone;
    }
    else {
        frame.origin.y = MIN(maxY, MAX(y, minY));
        alpha = MAX(minimalAlpha, (frame.origin.y - minY) / (maxY - minY));
        [self setFrame: frame alpha: alpha scrollOffset: scrollOffset animated: NO];
        _lastPower = power;
    }
}

- (BOOL) isParalaxPosible
{
    return self.navController.backgroundView != nil;
}

- (void) setFrame: (CGRect) frame alpha: (CGFloat) alpha scrollOffset: (CGFloat) scrollOffset animated: (BOOL) animated
{
    if (animated) {
        [UIView beginAnimations: nil context: nil];
    }
    CGFloat offsetY = CGRectGetMinY(frame) - CGRectGetMinY(self.frame);
    for (UIView* view in self.subviews) {
        bool isBackgroundView = [self backgroundView] == view;
        bool isViewHidden = view.hidden || view.alpha == 0.0f;
        if (!isBackgroundView && !isViewHidden) {
            view.alpha = alpha;
        }
    }
    self.frame = frame;
    BxNavigationController * navigationController = self.navController;
    if (navigationController.toolPanel) {
        navigationController.toolPanel.alpha = alpha;
        CGRect toolPanelFrame = navigationController.toolPanel.frame;
        CGFloat y = CGRectGetMaxY(frame);
        if ([self isParalaxPosible] && scrollOffset < 0) {
            y =  y - scrollOffset;
            navigationController.scrollOffset = -scrollOffset;
        } else {
            navigationController.scrollOffset = 0;
        }
        if (animated && fabs(toolPanelFrame.origin.y - y) > 10) {
            _lastPower = toolPanelFrame.origin.y - y;
        }
        toolPanelFrame.origin.y = y;
        navigationController.toolPanel.frame = toolPanelFrame;
    }
    if (navigationController.backgroundView) {
        CGRect backgroundFrame = navigationController.backgroundView.frame;
        CGFloat scrollTopOffset = [self scrollTopOffset];
        CGFloat height = frame.size.height + scrollTopOffset;
        if (navigationController.toolPanel) {
            height =  height + navigationController.toolPanel.frame.size.height;
        }
        if ([self isParalaxPosible] && scrollOffset < 0) {
            height =  height - scrollOffset;
            navigationController.scrollOffset = -scrollOffset;
        } else {
            navigationController.scrollOffset = 0;
        }
        backgroundFrame.size.height = height;
        backgroundFrame.origin.y = frame.origin.y - scrollTopOffset;
        navigationController.backgroundView.frame = backgroundFrame;
    }
    if (self.scrollView) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - offsetY);
    }
    if (animated) {
        [UIView commitAnimations];
        [self finishingMotion];
    }
}

- (void) finishingMotion
{
    [self finishingMotionWithPower: _lastPower];
}

- (void) finishingMotionWithPower: (CGFloat) power
{
    if (_scrollState == BxNavigationBarScrollStateUp) {
        return;
    }
    if (_scrollMotionEffects != nil && _scrollMotionEffects.count > 0) {
        for (BxNavigationBarMotionEffect * effect in _scrollMotionEffects) {
            [effect.view shakeXWithOffset: fabs(power) breakFactor:0.65 duration:0.75 maxShakes: fabs(power)];
        }
    }
}

@end

@implementation UINavigationController (BxNavigationBar)

@dynamic bxNavigationBar;

- (BxNavigationBar*) bxNavigationBar
{
    return (BxNavigationBar*)self.navigationBar;
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

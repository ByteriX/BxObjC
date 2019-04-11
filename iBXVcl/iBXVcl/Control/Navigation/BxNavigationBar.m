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


@interface BxNavigationController (private)

@property (nonatomic) CGFloat scrollOffset;

@end


@interface BxNavigationBar () <UIGestureRecognizerDelegate>
{
    CGFloat _startContentY;
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
    
    _toolFadeFactor = M_PI;
    _nativeFadeFactor = 20;
    _scrollLimitation = YES;
    
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

- (void) setBackgroundWithShift: (CGFloat) shift animated: (BOOL) animated
{
    UIView * view = [self backgroundView];
    
    __weak BxNavigationController * navigationController = self.navController;
    
    if (IS_OS_7_OR_LATER) {
        if (navigationController) {
            shift += navigationController.currentToolPanelHeight;
        }
        if (animated) {
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationDuration: bxNavigationDurationTime];
        }
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.frame.size.height - view.frame.origin.y + shift);
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        if (navigationController) {
            shift += navigationController.currentToolPanelHeight;
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
    
    [self setBackgroundWithShift: 0 animated: YES];
}

// For scroll methods
- (void) setScrollView:(UIScrollView*)scrollView
{
    [self resetScrollStateWithAnimation: YES];
    
    [_scrollView removeObserver: self forKeyPath:@"contentOffset"];
    
    _scrollView = scrollView;
    
    if (self.panGesture.view) {
        [self.panGesture.view removeGestureRecognizer: self.panGesture];
    }
    
    if (scrollView) {
        [scrollView addGestureRecognizer: self.panGesture];
        [scrollView addObserver:self
                     forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
}

- (void) resetScrollStateWithAnimation: (BOOL) animated
{
    _scrollState = BxNavigationBarScrollStateNone;
    CGRect frame = self.frame;
    if (self.navController.isNavigationBarHidden) {
        frame.origin.y -= frame.size.height;
    } else {
        frame.origin.y = [self scrollTopOffset];
    }
    [self setFrame: frame alphaNative: 1.0f alphaTool: 1.0f scrollOffset: 0.0f animated: animated];
}

- (void) statusBarDidChange
{
    [self resetScrollStateWithAnimation: YES];
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
#if IS_OS_SDK_11_ALLOWED
    if IS_OS_11_OR_LATER {
        if (self.navController.isViewLoaded) {
            UIView * view = self.navController.view;
            if (view.insetsLayoutMarginsFromSafeArea && view.safeAreaInsets.top > 0.0) {
                result = self.navController.view.safeAreaInsets.top;
            }
        }
    }
    else
#endif
    {
        static CGFloat minimalResult = 20.0f;
        if (result > minimalResult) {
            result -= minimalResult;
        }
    }
    return result;
}

-(void) observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id) object
                        change: (NSDictionary *) change
                       context: (void *) context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.navController.isNavigationBarHidden) {
            return;
        }
        BOOL isNotReseted = fabs(self.frame.origin.y - [self scrollTopOffset]) > minimalAlpha;
        if (isNotReseted) {
            bool isStopingPan = (_panGesture.state == UIGestureRecognizerStatePossible ||
                                 _panGesture.state == UIGestureRecognizerStateEnded ||
                                 _panGesture.state == UIGestureRecognizerStateCancelled);
            BOOL isSmallContentOffset = self.scrollView.contentOffset.y < 0;
            if (isStopingPan && isSmallContentOffset) {
                [self resetScrollStateWithAnimation: YES];
            }
        }
    }
}

- (void) gesturePan: (UIPanGestureRecognizer*) gesture
{
    if (_scrollView == nil || gesture.view != _scrollView || self.navController.isNavigationBarHidden) {
        return;
    }
    
    CGPoint touch = [gesture translationInView: _scrollView.superview];
    BOOL isScrollingY = fabs(_startContentY - self.scrollView.contentOffset.y) > 0.1;
    
    if (gesture.state == UIGestureRecognizerStateBegan || !isScrollingY)
    {
        _startTouchY = touch.y;
        _startY = self.frame.origin.y;
        _scrollState = BxNavigationBarScrollStateNone;
        _lastTouch = touch;
        _startContentY = self.scrollView.contentOffset.y;
        return;
    }
    
    BOOL isSmallScrolling = self.scrollView.contentSize.height < self.scrollView.frame.size.height;
    BOOL isScrollingX = fabs(touch.x - _lastTouch.x) > fabs(touch.y - _lastTouch.y);
    
    if (_scrollLimitation || isScrollingX) {
        if (self.scrollState == BxNavigationBarScrollStateNone && (isSmallScrolling || isScrollingX))
        {
            _startTouchY = touch.y;
            _lastTouch = touch;
            return;
        }
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
        minY -= navigationController.currentToolPanelHeight;
    }

    CGFloat alpha = 1.0f;
    CGRect frame = self.frame;
    CGFloat y = _startY + touch.y - _startTouchY;
    CGFloat scrollOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
    
    // This case posible because presented saveAncher. And that affected to scroll position calculation.
    if IS_OS_11_OR_LATER {
        scrollOffset += CGRectGetMaxY(frame);
    }
    
    bool isScrolling = (self.scrollState == BxNavigationBarScrollStateUp ||
                        self.scrollState == BxNavigationBarScrollStateDown);
    bool isStopingPan = (gesture.state == UIGestureRecognizerStateEnded ||
                         gesture.state == UIGestureRecognizerStateCancelled);
    
    // это тоже надо поправить, тут лучше бывает уходить в напрвлении "к кому сейчас ближе"
    if (isScrolling && isStopingPan) {
        if (self.scrollState == BxNavigationBarScrollStateDown && y < minY) {
            _scrollState = BxNavigationBarScrollStateUp;
        }
        if ((self.scrollState == BxNavigationBarScrollStateUp && y > maxY) || isSmallScrolling) {
            _scrollState = BxNavigationBarScrollStateDown;
        }
        
        if (self.scrollState == BxNavigationBarScrollStateDown) {
            frame.origin.y = maxY;
            alpha = 1.0f;
        } else if (self.scrollState == BxNavigationBarScrollStateUp) {
            frame.origin.y = minY;
            alpha = minimalAlpha;
        }
        [self setFrame: frame alphaNative: alpha alphaTool: alpha scrollOffset: 0.0f animated: YES];
        _scrollState = BxNavigationBarScrollStateNone;
    }
    else {
        frame.origin.y = MIN(maxY, MAX(y, minY));
        //alpha = (frame.origin.y - minY) / (maxY - minY);
        //alpha = MAX(minimalAlpha, alpha);
        CGFloat alphaExp = (maxY - frame.origin.y) / (maxY - minY);
        CGFloat alphaNative = exp(- alphaExp * alphaExp * _nativeFadeFactor);
        CGFloat alphaTool = exp(- alphaExp * alphaExp * _toolFadeFactor);
        [self setFrame: frame
           alphaNative: MAX(minimalAlpha, alphaNative)
             alphaTool: MAX(minimalAlpha, alphaTool)
          scrollOffset: scrollOffset
              animated: NO];
        _lastPower = power;
    }
}

- (BOOL) isParalaxPosible
{
    return self.navController.backgroundView != nil;
}

- (void) setFrame: (CGRect) frame
        alphaNative: (CGFloat) alphaNative
        alphaTool: (CGFloat) alphaTool
     scrollOffset: (CGFloat) scrollOffset
         animated: (BOOL) animated
{
    if (animated) {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: bxNavigationDurationTime];
    }
    CGFloat offsetY = CGRectGetMinY(frame) - CGRectGetMinY(self.frame);
    
    for (UIView* view in self.subviews) {
        bool isBackgroundView = [self backgroundView] == view;
        bool isViewHidden = view.hidden || view.alpha == 0.0f;
        if (!isBackgroundView && !isViewHidden) {
            view.alpha = alphaNative;
        }
    }
    self.frame = frame;
    BxNavigationController * navigationController = self.navController;
    if (navigationController.toolPanel) {
        navigationController.toolPanel.alpha = alphaTool;
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
            height =  height + navigationController.currentToolPanelHeight;
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
    if (_scrollEffects != nil && _scrollEffects.count > 0) {
        for (id<BxNavigationBarEffectProtocol> effect in _scrollEffects) {
            [effect finishingMotionWithNavigationBar: self shift: power];
        }
    }
}

@end

@implementation UINavigationController (BxNavigationBar)

@dynamic bxNavigationBar;

- (BxNavigationBar*) bxNavigationBar {
    if ([self.navigationBar isKindOfClass: BxNavigationBar.class]) {
        return (BxNavigationBar*)self.navigationBar;
    }
    return nil;
}

@end

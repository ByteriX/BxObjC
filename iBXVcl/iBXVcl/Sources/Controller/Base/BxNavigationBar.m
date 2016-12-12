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


@interface BxNavigationBar () <UIGestureRecognizerDelegate>
{
    CGFloat _startTouchY;
    CGFloat _startY;
    CGFloat _lastTouchY;
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UIView * view = [self backgroundView];
    
    __weak BxNavigationController * navigationController = self.navController;
    
    if (IS_OS_7_OR_LATER) {
        CGFloat shift = 0;
        if (navigationController) {
            shift = navigationController.toolPanel.frame.size.height;
        }
        [UIView animateWithDuration: 0.3 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.frame.size.height + 20 + shift);
        }];
    } else {
        CGFloat shift = 0;
        if (navigationController) {
            shift = navigationController.toolPanel.frame.size.height;
            if (!_toolPanel) {
                self.toolPanel = [[UIToolbar alloc] initWithFrame: CGRectZero];
                [self addSubview: _toolPanel];
            }
            self.toolPanel.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + self.frame.size.height, view.frame.size.width, shift);
            self.toolPanel.tintColor = self.tintColor;
        }
    }
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
    [self setFrame: frame alpha: 1.0f animated: animated];
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
    
    CGFloat touchY = [gesture translationInView: _scrollView.superview].y;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _startTouchY = touchY;
        _startY = self.frame.origin.y;
        _scrollState = BxNavigationBarScrollStateNone;
        _lastTouchY = [gesture translationInView: _scrollView.superview].y;
        return;
    }
    
    if (touchY > _lastTouchY) {
        _scrollState = BxNavigationBarScrollStateDown;
    } else if (touchY < _lastTouchY) {
        _scrollState = BxNavigationBarScrollStateUp;
    }
    _lastTouchY = touchY;
    
    if (self.scrollState == BxNavigationBarScrollStateNone && self.scrollView.contentSize.height < self.scrollView.frame.size.height + 2 * self.bounds.size.height)
    {
        _startTouchY = touchY;
        return;
    }
    
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
    
    bool isScrolling = (self.scrollState == BxNavigationBarScrollStateUp ||
                        self.scrollState == BxNavigationBarScrollStateDown);
    bool isStopingPan = (gesture.state == UIGestureRecognizerStateEnded ||
                            gesture.state == UIGestureRecognizerStateCancelled);
    
    if (isScrolling && isStopingPan) {
        if (self.scrollState == BxNavigationBarScrollStateDown) {
            frame.origin.y = maxY;
            alpha = 1.0f;
        } else if (self.scrollState == BxNavigationBarScrollStateUp) {
            frame.origin.y = minY;
            alpha = minimalAlpha;
        }
        [self setFrame: frame alpha: alpha animated: YES];
        _scrollState = BxNavigationBarScrollStateNone;
    }
    else {
        CGFloat y = _startY + touchY - _startTouchY;
        frame.origin.y = MIN(maxY, MAX(y, minY));
        alpha = MAX(minimalAlpha, (frame.origin.y - minY) / (maxY - minY));
        [self setFrame: frame alpha: alpha animated: NO];
    }
}

- (void) setFrame: (CGRect) frame alpha: (CGFloat) alpha animated: (BOOL) animated
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
        toolPanelFrame.origin.y = CGRectGetMaxY(self.frame);
        navigationController.toolPanel.frame = toolPanelFrame;
    }
    if (self.scrollView) {
        CGRect parentViewFrame = self.scrollView.superview.frame;
        parentViewFrame.origin.y += offsetY;
        parentViewFrame.size.height -= offsetY;
        self.scrollView.superview.frame = parentViewFrame;
    }
    if (animated) {
        [UIView commitAnimations];
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

/**
 *	@file ServiceController.h
 *	@namespace iBXVcl
 *
 *	@details Контролер, позволяющий показывать диалоговые представления
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxServiceController.h"
#import "BxUIUtils.h"
#import "BxCommon.h"
#import "UIImage+BxUtils.h"
#import "UIImage+ImageWithUIView.h"

@implementation BxServiceController

- (void) initObject {
    _active = NO;
    _autoDismiss = YES;
    _autoBackground = NO;
}

- (id) init
{
    self = [super init];
	if ( self ) {
		[self initObject];
	}	
	return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initObject];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //[self updateAutoBackground];
    self.view.exclusiveTouch = YES;
}

- (void)setAutoBackground:(BOOL)autoBackground
{
    _autoBackground = autoBackground;
    if ([self isViewLoaded]) {
        [self updateAutoBackground];
    }
}
- (void)updateAutoBackground {
    if (![self isViewLoaded]) {
        return;
    }
    if (_autoBackground) {
        if (IS_OS_7_OR_LATER) {
            
            /*if (IS_OS_8_OR_LATER) {
                UIBlurEffect *blur = [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight];
                UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
                effectView.frame = self.view.frame;
                [self.view insertSubview: effectView atIndex: 0];
            } else*/ {
                if (!self.view.superview){
                    return;
                }
                UIImage * backgroundImage = [UIImage imageWithAllUIView: self.view.superview];
                backgroundImage = [backgroundImage blurWithRadius: 24.0f];
                
                self.view.layer.contents = (id)backgroundImage.CGImage;
            }
        } else {
            self.view.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.75f];
        }
    } else {
        //
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
}

- (void) presentDidStop {
	[self viewDidAppear: NO];
}

- (UIView*) getViewFromParent: (UIViewController*) parent 
{
	return [BxUIUtils getSuperParentView: parent.view];
}

- (void) presentFromParent: (UIViewController*) parent animated: (BOOL) animated
{
    [self retain];
    [self view];
	_active = YES;
	CGRect rect;
	UIView * parentView = [self getViewFromParent: parent];
	rect = parentView.frame;
	rect.origin.x = rect.origin.y = 0.0f;
    if ( UIInterfaceOrientationIsLandscape(parent.interfaceOrientation) && rect.size.width < rect.size.height ) 
    {
        CGFloat temp = rect.size.width;
        rect.size.width = rect.size.height;
        rect.size.height = temp;
    }
	self.view.alpha = 0.0f;
	self.view.frame = rect;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth        |
    UIViewAutoresizingFlexibleRightMargin  |
    UIViewAutoresizingFlexibleTopMargin    |
    UIViewAutoresizingFlexibleHeight       |
    UIViewAutoresizingFlexibleBottomMargin;
	
	[parentView addSubview: self.view];
	[self updateAutoBackground];

	if (animated){
		[UIView beginAnimations: nil context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDidStopSelector: @selector(presentDidStop)];
	}
	self.view.alpha = 1.0f;
	[self viewWillAppear: animated];
	if (animated) {
		[UIView commitAnimations];
	} else {
		[self presentDidStop];
	}
}

- (void) dismissWillStop {
    //
}

- (void) dismissDidStop {
    if (!_active) {
        [self.view removeFromSuperview];
    }
    [self autorelease];
}

- (void) dismissAnimated: (BOOL) animated
{
	if (!_active) {
		return;
	}
    [self dismissWillStop];
	if (_delegate && [_delegate respondsToSelector: @selector(willDismiss:)]) {
		if (![_delegate willDismiss: self]) {
			return;
		}
	}
	_active = NO;
	if (animated){
		[UIView beginAnimations: nil context: nil];
        [UIView setAnimationDelegate: self];
		[UIView setAnimationDidStopSelector: @selector(dismissDidStop)];
	}
	self.view.alpha = 0.0f;
	[self viewWillDisappear: animated];
	if (animated) {
		[UIView commitAnimations];
	} else {
        [self dismissDidStop];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_autoDismiss) {
		[self dismissAnimated: YES];
	}
}

- (BOOL) isPresented
{
	return self.view.superview && self.view.alpha > 0.5f;
}

- (void) dealloc
{
    [self viewDidUnload];
    [super dealloc];
}

@end

/*@implementation UIViewController (ServiceController)

- (void) presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
	if ([modalViewController isKindOfClass: ServiceController.class]) {
		[(ServiceController*)modalViewController presentFromParent: self animated: animated];
	} else {
		[self presentModalViewController: modalViewController animated: animated];
	}
}

@end*/

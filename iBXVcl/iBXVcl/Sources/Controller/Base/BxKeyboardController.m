/**
 *	@file BxKeyboardController.m
 *	@namespace iBXVcl
 *
 *	@details Контроллер подразумевающий использование клавиатуры
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxKeyboardController.h"
#import "BxUIUtils.h"

@implementation BxKeyboardController

- (BOOL) isAlwaysShowKeyboard
{
	return YES;
}

- (BOOL) isAlwaysHiddenKeyboard
{
	return NO;
}

- (BOOL) isContentResize
{
	return YES;
}

- (UIResponder*) keyBoardSource
{
	return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_keyboardShown = NO;

    _contentView = [[UIView alloc] initWithFrame:
                     CGRectMake(0.0f, 0.0f, self.view.frame.size.width,
                                self.view.frame.size.height)];
    
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	_contentView.backgroundColor = [UIColor clearColor];
	[self.view addSubview: _contentView];
    [_contentView release];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
										 duration:(NSTimeInterval)duration
{
	/*float keyHeight;
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		keyHeight = 162;
	}else {
		keyHeight = 216;
	}
	_contentView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,
								   self.view.frame.size.height - keyHeight);*/
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification object:nil];
}

- (void) startKeyboardPosition
{
	if ([self isAlwaysShowKeyboard] || (_keyboardShown && (![self isAlwaysHiddenKeyboard]))) {
		[[self keyBoardSource] becomeFirstResponder];
	} else if ([self isAlwaysHiddenKeyboard] || (!_keyboardShown)) {
		[[self keyBoardSource] resignFirstResponder];
		_contentView.frame = CGRectMake(0.0f, 0.0f,
									   self.view.frame.size.width, 
									   self.view.frame.size.height);
		if ([self isAlwaysHiddenKeyboard]) {
			_keyboardShown = NO;
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
    [self registerForKeyboardNotifications];
	[self startKeyboardPosition];
	//[self willAnimateRotationToInterfaceOrientation: self.interfaceOrientation duration: 0.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	//[self startKeyboardPosition];
}

- (void)viewWillDisappear:(BOOL)animated; 
{
	if ([self isAlwaysHiddenKeyboard]) {
		[[self keyBoardSource] resignFirstResponder];
	}
	[super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated; 
{
	
	//if ([self isAlwaysShowKeyboard]) {
		[[self keyBoardSource] resignFirstResponder];
	//}
	[self unregisterForKeyboardNotifications];
	[super viewDidDisappear: animated];
}

- (void) onWillChangeContentSizeWithShow: (BOOL) isKeyBoardWillShow
{
	//
}

- (void) onDidChangeContentSizeWithShow
{
	//
}

- (CGFloat) contentHeightForKeyboardFrame:(CGRect) keyboardFrame
{
    return  keyboardFrame.origin.y;
}

- (void) onWillChangeContentSizeWithShow:(NSDictionary*) data isKeyBoardWillShow: (BOOL) isKeyBoardWillShow
{
	if (![self isContentResize]) {
		return;
	}
	NSNumber * keyboardDuration = [data objectForKey: UIKeyboardAnimationDurationUserInfoKey];
	NSNumber * keyboardCurve = [data objectForKey: UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardFrame = [BxUIUtils getKeyboardFrameIn: self.view userInfo: data];
	CGFloat contentHeight = self.view.frame.size.height;
    if (isKeyBoardWillShow) {
        contentHeight = [self contentHeightForKeyboardFrame: keyboardFrame];
    }
	
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(onDidChangeContentSizeWithShow)];
	[UIView setAnimationCurve: [keyboardCurve unsignedIntValue]];
	[UIView setAnimationDuration: [keyboardDuration doubleValue]];
	_contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y,
								   self.view.frame.size.width, 
								   contentHeight);
	[self onWillChangeContentSizeWithShow: isKeyBoardWillShow];
	[UIView commitAnimations];	
}

/*- (void) changeContentView: (NSDictionary*) userInfo
{

	if (keyboardShown) {
		if ( [self isKeyBoardShift] ) {
			CGRect keyboardFrame = [UIUtils getKeyboardFrameIn: table userInfo: userInfo];
			float height = keyboardFrame.origin.y;
			table.frame = CGRectMake(0.0f, 0.0f, 
											 contentView.frame.size.width, height);
			
		} else {
			table.frame = CGRectMake(0.0f, [self tableShift], 
											 contentView.frame.size.width, contentView.frame.size.height);
		}
		
		[self searchBarToView];
	} else {
		contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, 
									   self.view.frame.size.width, self.view.frame.size.height - contentView.frame.origin.y);
		[self addSearchBarToTable];
	}
}*/

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    if (_keyboardShown)
        return;
	_keyboardShown = YES;
    [self onWillChangeContentSizeWithShow: [aNotification userInfo] isKeyBoardWillShow: _keyboardShown];
}

// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    if (!_keyboardShown)
        return;
    _keyboardShown = NO;
	[self onWillChangeContentSizeWithShow: [aNotification userInfo] isKeyBoardWillShow: _keyboardShown];
}

/*- (void)dealloc {
    [super dealloc];
}*/

@end

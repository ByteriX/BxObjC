/**
 *	@file DialogController.m
 *	@namespace iBXVcl
 *
 *	@details Нижняя панель с кнопками, в диалоговом режиме
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDialogController.h"

@interface BxServiceController ()

- (void) presentDidStop;

@end

@implementation BxDialogController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _titleHeight = 52.0f;
    }
    return self;
}

- (CGFloat) contentHeight
{
	return self.view.frame.size.height;
}

- (UIImage*) backgroundImage
{
    return  [[UIImage imageNamed: @"popup_panel.png"]
             stretchableImageWithLeftCapWidth: 0.0f topCapHeight: 40.0f];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.autoDismiss = NO;
	self.view.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.5f];
	
	
	_contentView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, self.view.frame.size.height,
															self.view.frame.size.width, 
															[self contentHeight])];
	_contentView.backgroundColor = [UIColor clearColor];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	
	[self.view addSubview: _contentView];
	[_contentView release];
	
	UIImage * image = [self backgroundImage];
	_backMessagePanel = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, - _titleHeight,
																					_contentView.frame.size.width,
																					_contentView.frame.size.height + _titleHeight)];
	_backMessagePanel.image = image;
	_backMessagePanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	[_contentView addSubview: _backMessagePanel];
	[_backMessagePanel release];
	
	_titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(10.0f, -_titleHeight,
						self.view.frame.size.width - 20.0f, _titleHeight)];
	_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.textColor = [UIColor whiteColor];
	_titleLabel.font = [UIFont fontWithName: @"Arial-BoldMT" size: 20.0f];
	_titleLabel.numberOfLines = 1;
	_titleLabel.shadowColor = [UIColor blackColor];
	_titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.text = self.title;
	[_contentView addSubview: _titleLabel];
	[_titleLabel release];
}

//! @override
- (void) presentDidStop
{
    [super presentDidStop];
}

//! @override
- (void) setTitle:(NSString *) value
{
	[super setTitle: value];
	_titleLabel.text = self.title;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	//
	_contentView.center = CGPointMake(_contentView.center.x,
									 self.view.frame.size.height + _contentView.frame.size.height / 2.0f);
	//
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDelay: 0.1f];
	_contentView.center = CGPointMake(_contentView.center.x,
									 self.view.frame.size.height - _contentView.frame.size.height / 2.0f);
	[UIView commitAnimations];
}

- (void) viewDidHide
{
    //
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear: animated];
	//
	[UIView beginAnimations: nil context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(viewDidHide)];
	_contentView.center = CGPointMake(_contentView.center.x,
									 self.view.frame.size.height + _contentView.frame.size.height / 2.0f);
	[UIView commitAnimations];
}

@end

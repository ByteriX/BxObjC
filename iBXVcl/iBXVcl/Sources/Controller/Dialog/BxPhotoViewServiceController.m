/**
 *	@file PhotoViewServiceController.m
 *	@namespace iBXVcl
 *
 *	@details Просмотр фото из определенной области
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxPhotoViewServiceController.h"

@interface BxPhotoViewServiceController ()

@end

@implementation BxPhotoViewServiceController

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.autoDismiss = YES;
	self.view.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.85f];
	_photoView = [[UIImageView alloc] initWithFrame: CGRectZero];
    [self.view addSubview: _photoView];
    [_photoView release];
    _photoView.userInteractionEnabled = NO;
    _photoView.contentMode = UIViewContentModeScaleAspectFit;
	//
}

- (void) presentFromParent: (UIViewController*) parent animated: (BOOL) animated
{
    [NSException raise: @"IncorrectMethodUseException" format: @"Use presentFromParent:imageView:animated: method"];
}

- (void) presentFromParent: (UIViewController*) parent imageView: (UIImageView*) imageView animated: (BOOL) animated
{
    [self view];
    CGRect imageRect = [parent.view convertRect:imageView.bounds fromView:imageView];
    _startRect = imageRect;//CGRectMake(imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
    _photoView.frame = _startRect;
    _photoView.image = imageView.image;
    
    
    CGFloat scale = 4.0f;
    
    CGRect endRect = CGRectMake(truncf((parent.view.bounds.size.width - imageRect.size.width * scale) /2.0f), truncf((parent.view.bounds.size.height - imageRect.size.height * scale) /2.0f), imageRect.size.width * scale, imageRect.size.height * scale);
    
    [super presentFromParent: parent animated: animated];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    _photoView.frame = endRect;
    [UIView commitAnimations];
}

- (void) dismissWillStop {
    [UIView beginAnimations: nil context: nil];
    _photoView.frame = _startRect;
    [UIView commitAnimations];
}

@end

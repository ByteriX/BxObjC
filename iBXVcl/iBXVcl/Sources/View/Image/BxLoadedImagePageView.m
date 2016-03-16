/**
 *	@file BxLoadedImagePageView.m
 *	@namespace iBXVcl
 *
 *	@details Кешируемое изображение из сети на странице
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxLoadedImagePageView.h"

@interface BxLoadedImagePageView ()

@end

@implementation BxLoadedImagePageView

- (void) initObject
{
    self.backgroundColor = [UIColor blackColor];
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 10.0f;
    self.canCancelContentTouches = YES;
    self.imageView = [[[BxLoadedImageViewItem alloc] initWithFrame: self.bounds] autorelease];
    self.imageView.contentImage.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.contentImage.layer.borderWidth = 0.0f;
    self.imageView.contentImage.clipsToBounds = YES;
    self.imageView.contentImage.backgroundColor = [UIColor clearColor];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview: self.imageView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initObject];
    }
    return self;
}

- (void) setDefaultState
{
	self.zoomScale = 1.0f;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark -

- (void)dealloc
{
    self.imageView = nil;
    [super dealloc];
}

@end

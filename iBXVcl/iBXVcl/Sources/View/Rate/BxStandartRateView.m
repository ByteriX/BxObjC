/**
 *	@file BxStandartRateView.m
 *	@namespace iBXVcl
 *
 *	@details Рейтинг с произвольным визуальным отображением
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxStandartRateView.h"

@interface BxStandartRateView ()

@property (retain) NSMutableArray *imageViews;

@end

@implementation BxStandartRateView

- (void) initObject
{
    _notSelectedImage = nil;
    _selectedImage = nil;
    _rating = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 2;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;
    _rounded = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initObject];
    }
    return self;
}

- (void) setRating:(float)rating
{
    _rating = rating;
    [self refresh];
}

- (void) refresh
{
    for (int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (self.rating >= i + 1) {
            imageView.image = self.selectedImage;
        } else if (self.rating >= i + 0.5) {
            imageView.image = self.halfSelectedImage;
        } else {
            imageView.image = self.notSelectedImage;
        }
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (self.notSelectedImage == nil) return;
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin * 2) - (self.midMargin * self.imageViews.count)) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    for (int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i * (self.midMargin + imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
    }
}

- (void) setMaxRating:(int)maxRating
{
    _maxRating = maxRating;
    for (int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    for (int i = 0; i < maxRating; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
        [imageView release];
    }
    [self setNeedsLayout];
    [self refresh];
}

- (void) handleTouchAtLocation:(CGPoint)touchLocation
{
    float newRating = 0;
    for (NSInteger i = self.imageViews.count - 1; i >= 0; i--) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x) {
            if (touchLocation.x < (imageView.frame.origin.x + imageView.frame.size.width / 2)) {
                newRating = i + 0.5;
                break;
            }
            else {
                newRating = i + 1;
                break;
            }
        }
    }
    if (self.rounded) {
        self.rating = roundf(newRating);
    } else {
        self.rating = newRating;
    }
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.editable) { return; }
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.editable) { return; }
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
    [self.delegate standartRateView: self ratingDidChange: self.rating];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!self.editable) { return; }
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
    [self.delegate standartRateView: self ratingDidChange: self.rating];
}

- (void) dealloc
{
    _delegate = nil;
    [_notSelectedImage autorelease];
    _notSelectedImage = nil;
    [_halfSelectedImage autorelease];
    _halfSelectedImage = nil;
    [_selectedImage autorelease];
    _selectedImage = nil;
    [_imageViews autorelease];
    _imageViews = nil;
    [super dealloc];
}

@end

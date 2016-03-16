/**
 *	@file BxPageControl.m
 *	@namespace iBXVcl
 *
 *	@details UIPageControl с кастомным представлением индикатора
 *	@date 06.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxPageControl.h"

@implementation BxPageControl

- (void) initObject {
    self.indention = 10.0f;
    [self addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self initObject];
    }
    return self;
}

/*- (void)awakeFromNib {
    [self initObject];
}*/

- (void) setActiveImage: (UIImage *) activeImage
{
    _activeImage = activeImage;
    [self setNeedsDisplay];
}

- (void) setInactiveImage: (UIImage *) inactiveImage
{
    _inactiveImage = inactiveImage;
    [self setNeedsDisplay];
}

- (void) updateImages
{
    if (_inactiveImage && _activeImage){
        NSArray * originalSubviews = [self.subviews copy];
        for ( UIView *view in originalSubviews ) {
            [view removeFromSuperview];
        }
        self.contentMode = UIViewContentModeRedraw;
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateImages];
}

- (void) drawRect:(CGRect) iRect {
    if (_inactiveImage && _activeImage){
        UIImage                 *image;
        int                     i;
        CGRect                  rect;
        iRect = self.bounds;

        if ( self.opaque ) {
            [self.backgroundColor set];
            UIRectFill( iRect );
        }

        if ( self.hidesForSinglePage && self.numberOfPages == 1 ) {
            return;
        }

        rect.size.height = self.activeImage.size.height;
        rect.size.width = self.numberOfPages * self.activeImage.size.width + ( self.numberOfPages - 1 ) * _indention;
        rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0f );
        rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0f );
        rect.size.width = self.activeImage.size.width;

        for ( i = 0; i < self.numberOfPages; ++i ) {
            image = i == self.currentPage ? self.activeImage : self.inactiveImage;

            [image drawInRect: rect];

            rect.origin.x += self.activeImage.size.width + _indention;
        }
    }
}

- (void) setCurrentPage:(NSInteger) iPage {
    [super setCurrentPage: iPage];
    [self setNeedsDisplay];
}


- (void) setNumberOfPages:(NSInteger) iPages {
    [super setNumberOfPages: iPages];
    [self setNeedsDisplay];
}

- (void) changePage: (id) sender {
    [self setNeedsDisplay];
}

@end

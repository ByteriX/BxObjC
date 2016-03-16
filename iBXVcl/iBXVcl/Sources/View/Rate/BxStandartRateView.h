/**
 *	@file BxStandartRateView.h
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

#import <UIKit/UIKit.h>

@class BxStandartRateView;

@protocol BxStandartRateViewDelegate

- (void) standartRateView: (BxStandartRateView *) rateView ratingDidChange: (float) rating;

@end

//! Рейтинг с произвольным визуальным отображением
@interface BxStandartRateView : UIView

@property (nonatomic, retain) UIImage *notSelectedImage;
@property (nonatomic, retain) UIImage *halfSelectedImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) float rating;
@property (assign) BOOL editable;
@property (assign) BOOL rounded;
@property (nonatomic, assign) int maxRating;
@property (nonatomic, assign) int midMargin;
@property (nonatomic, assign) int leftMargin;
@property (nonatomic, assign) CGSize minImageSize;
@property (nonatomic, assign) id <BxStandartRateViewDelegate> delegate;

@end

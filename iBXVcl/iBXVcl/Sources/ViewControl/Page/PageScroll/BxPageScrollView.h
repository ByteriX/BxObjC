/**
 *	@file BxPageScrollView.h
 *	@namespace iBXVcl
 *
 *	@details Листалка страниц
 *	@date 09.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxPageView.h"

@class BxPageScrollView;

@protocol BxPageScrollTarget

- (void) pageScrollView: (BxPageScrollView*) pageScrollView updatePage: (BxPageView*) page fromIndex: (NSInteger) index;
- (void) pageScrollView: (BxPageScrollView*) pageScrollView showPage:(BxPageView*) page fromIndex: (NSInteger) index;

@end

//! Листалка страниц
@interface BxPageScrollView : UIScrollView <UIScrollViewDelegate> {
@protected
	NSInteger _currentPageIndex;
	NSInteger _centerPageIndex;
	NSMutableArray * _pages;
	NSInteger _currentPageCount;
	NSInteger _cashPageCount;
}

//! количество страниц, которые гарантированно будут находится в кеше
@property (nonatomic) int bufferPageCount;
//! отступ относительно краев для страниц
@property (nonatomic) float pageIndent;
//! цель делегирования
@property (nonatomic, assign) id<BxPageScrollTarget> target;

- (id) initWithFrame:(CGRect) rect target:(id<BxPageScrollTarget>) target;

- (void) startWithPageCount:(NSInteger) pageCount currentIndex:(NSInteger) index classPage: (Class) classPage;

@end

/**
 *	@file BxLoadedImageListViewController.h
 *	@namespace iBXVcl
 *
 *	@details Котролер списка кешируемых из сети изображений
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxBaseViewController.h"
#import "BxPageScrollView.h"

@interface BxLoadedImageListItem : NSObject

- (id) initWithUrl: (NSString*) url title: (NSString*) title;

+ (id) itemWithUrl: (NSString*) url title: (NSString*) title;

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;

@end

@interface BxLoadedImageListViewController : BxBaseViewController <UIScrollViewDelegate, BxPageScrollTarget>{
@protected
	BxPageScrollView * _pageScroll;
    NSInteger _currentIndex;
}

//! массив элементов BxLoadedImageListItem для отображения элементов на основе BxLoadedImagePageView
@property (nonatomic, retain) NSArray * itemsData;

- (void) startWithData:(NSArray*) itemsData currentIndex:(int) index;

// protected:
- (void) updatePageScroll;
- (void) updatePageWithItem: (BxLoadedImageListItem*) item;

@end

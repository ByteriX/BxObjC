/**
 *	@file BxViewItemsList.h
 *	@namespace iBXVcl
 *
 *	@details Линейный список
 *	@date 09.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxViewItem.h"

@class BxViewItemsList;
@class BxViewItemValue;
@class ItemsListPanGestureRecognizer;

// UITableView

@protocol BxViewItemsListSource <NSObject>

- (NSUInteger) numberOfLayersInContentItemScroll: (BxViewItemsList*) viewItemsList;

- (NSUInteger) viewItemsList: (BxViewItemsList*) viewItemsList numberOfItemsInLayer: (NSInteger) layer;

- (CGSize) viewItemsList: (BxViewItemsList*) viewItemsList sizeOfItemsInLayer: (NSUInteger) layer index: (NSUInteger) index;

- (UIView<BxViewItem>*) viewForViewItemsList: (BxViewItemsList*) viewItemsList layer: (NSUInteger) layer index: (NSUInteger) index;

@end

@protocol BxViewItemsListDelegate <NSObject>

@optional

- (void) viewItemsList: (BxViewItemsList*) viewItemsList changeLayer: (NSInteger) layer index: (NSInteger) index;

- (void) touthViewItemsList: (BxViewItemsList*) viewItemsList layer: (NSUInteger) layer index: (NSUInteger) index;

@end

typedef UIView<BxViewItem>* (^BxViewItemCreateHandler)();

typedef NS_ENUM(NSInteger, BxViewItemsListOrientation) {
    BxViewItemsListHorizontalOrientation,
    BxViewItemsListVerticalOrientation
};

//! Линейный список
@interface BxViewItemsList : UIView <UIGestureRecognizerDelegate>
{
@protected
    NSInteger _layersCount;
    NSMutableArray * _itemsValueLayers;
    NSMutableArray * _bufferedItemValues;
    NSMutableDictionary * _removedItemViews;
    NSInteger _currentIndex;
    CGFloat _currentShift;
    
    CGFloat _allPosition;
    CGFloat _endBorderedPosition;
    NSInteger _endBorderedIndex;

    ItemsListPanGestureRecognizer * _panGestureRecognizer;
    NSInteger _lastPadingPageIndex;
    CGSize _lastSize;
}
@property (nonatomic, assign) id<BxViewItemsListSource> dataSource;
@property (nonatomic, assign) id<BxViewItemsListDelegate> delegate;
@property (nonatomic) NSInteger bufferMinCount;
@property (nonatomic) BOOL isCentred;
@property (nonatomic) BOOL isSticked;
@property (nonatomic) BOOL isScale;
@property (nonatomic) BOOL isVisualBordered;
@property (nonatomic) BOOL isCentredOfFull;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic) double inertial;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BxViewItemsListOrientation orientation;
@property (nonatomic,retain) UIView * indicatorView;


- (void) updateWithIndex: (NSInteger) index;
- (void) updateWithoutRefreshWithIndex: (NSInteger) index;

- (void) refreshWithDeleteIndex: (NSUInteger) index animated: (BOOL) animated;
- (void) refreshWithAddIndex: (NSUInteger) index animated: (BOOL) animated;
- (void) refreshAnimated: (BOOL) animated;

- (UIView<BxViewItem>*)createBufferedViewWithIdentifier:(NSString *)identifier forLayer:(NSUInteger)layer index:(NSUInteger)index creator: (BxViewItemCreateHandler) creator;

- (BxViewItemValue*) getItemFromView: (UIView<BxViewItem>*) view;
- (UIView<BxViewItem>*) getViewFromIndex: (NSUInteger) index;

@end

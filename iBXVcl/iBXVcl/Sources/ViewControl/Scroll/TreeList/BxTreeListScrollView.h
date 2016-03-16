/**
 *	@file BxTreeListScrollView.h
 *	@namespace iBXVcl
 *
 *	@details Древовидный список
 *	@date 23.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BxTreeListItem.h"
#import "NSIndexPath+BxTreeListScrollView.h"

@class BxTreeListScrollView;
@class BxTreeListScrollViewItemData;

@protocol BxTreeListScrollViewDataSource <NSObject>

- (int)treeListScrollView:(BxTreeListScrollView *)treeListScrollView numberOfLevelIndexPath: (NSIndexPath*) indexPath;

- (CGFloat)treeListScrollView:(BxTreeListScrollView *)treeListScrollView heightOfViewIndexPath: (NSIndexPath*) indexPath;

- (UIView<BxTreeListItemProtocol>*)treeListScrollView:(BxTreeListScrollView *)treeListScrollView itemOfIndexPath: (NSIndexPath*) indexPath;

@optional

//! Если есть возможность загрузить корневую структуру документов извне, это будет быстрее через данный метод
- (BxTreeListScrollViewItemData *) getItemDataCustomDocumentTableView: (BxTreeListScrollView *) customDocumentTableView;

- (void)treeListScrollView:(BxTreeListScrollView *)treeListScrollView updateItemData: (BxTreeListScrollViewItemData *) itemData;

@end

@protocol BxTreeListScrollViewDelegate <UIScrollViewDelegate>

@end


@interface BxTreeListScrollViewItemData : NSObject
{

}

@property (nonatomic) CGFloat position;
@property (nonatomic) CGFloat allHeight;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic, retain) NSMutableArray * subitems;
@property (nonatomic, retain) UIView<BxTreeListItemProtocol> * view;

@end

//! Древовидный список
@interface BxTreeListScrollView : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray * _itemViewBuffer;
    id<UIScrollViewDelegate> _scrollDelegate;
    NSMutableArray * _itemBuffer;
}
@property (nonatomic, retain) NSObject<BxTreeListScrollViewDataSource> *dataSource;
@property (nonatomic, readonly) BxTreeListScrollViewItemData *rootItemData;

- (void) clearBuffer;
- (void) update;
- (void) updateFromIndexPath: (NSIndexPath*) indexPath;

- (NSIndexPath*) indexPathFromPoint: (CGPoint) point;
- (UIView<BxTreeListItemProtocol> *) viewFromPoint: (CGPoint) point;
- (NSIndexPath*) indexPathFromRect: (CGRect) rect;

//! работает быстро, за счет того что ищет по отображенным компонентам
- (NSIndexPath*) indexPathFromVisualView: (UIView<BxTreeListItemProtocol> *) view;

- (BxTreeListScrollViewItemData *) getItemDataFrom: (NSIndexPath*) indexPath;
- (CGPoint) topPointFromIndexPath: (NSIndexPath*) indexPath;
- (CGFloat) fixebaleShiftFromIndexPath: (NSIndexPath*) indexPath;
- (void) scrollToIndexPath: (NSIndexPath*) indexPath animated: (BOOL) animated;

- (void) shiftItemsWithY: (CGFloat) y afterView: (UIView<BxTreeListItemProtocol> *) afterView;

// protected

- (CGFloat) getHeightView: (UIView<BxTreeListItemProtocol> *) itemView itemData: (BxTreeListScrollViewItemData *) itemData;
- (void) updateView: (UIView*) view position: (CGFloat) position height: (CGFloat) height;

@end

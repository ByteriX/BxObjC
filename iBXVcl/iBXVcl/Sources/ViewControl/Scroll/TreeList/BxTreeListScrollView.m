/**
 *	@file BxTreeListScrollView.m
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

#import <UIKit/UIKit.h>
#import "BxTreeListScrollView.h"


@implementation BxTreeListScrollViewItemData

- (void) dealloc
{
    [self.view removeFromSuperview];
    self.view = nil;
    self.subitems = nil;
    [super dealloc];
}

@end

@implementation BxTreeListScrollView

- (id<UIScrollViewDelegate>) getDelegate
{
    return _scrollDelegate;
}

- (void) setDelegate: (id<UIScrollViewDelegate>) d
{
    _scrollDelegate = d;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        _itemBuffer = [[NSMutableArray alloc] initWithCapacity: 32];
        self.multipleTouchEnabled = YES;
        [super setDelegate: self];
        [_itemViewBuffer release];
        _itemViewBuffer = [[NSMutableArray alloc] initWithCapacity: 32];
    }
    return self;
}

- (BxTreeListScrollViewItemData *) getItemDataWithIndexPath: (NSIndexPath*) indexPath lastPosition: (CGFloat *) lastPosition
{
    BxTreeListScrollViewItemData * currentItemData = [[BxTreeListScrollViewItemData alloc] init];
    currentItemData.position = *lastPosition;
    int itemCount = [_dataSource treeListScrollView:self numberOfLevelIndexPath:indexPath];
    currentItemData.subitems = [NSMutableArray arrayWithCapacity: itemCount];
    currentItemData.itemHeight = [_dataSource treeListScrollView:self heightOfViewIndexPath:indexPath];
    *lastPosition = currentItemData.position + currentItemData.itemHeight;
    currentItemData.view = nil;

    if ([_dataSource respondsToSelector:@selector(treeListScrollView:updateItemData:)]) {
        [_dataSource performSelector:@selector(treeListScrollView:updateItemData:) withObject:self withObject:currentItemData];
    }

    for (int itemIndex = 0; itemIndex < itemCount; itemIndex++) {
        NSIndexPath * newIndexPath;
        if (indexPath) {
            newIndexPath = [indexPath indexPathByAddingIndex: itemIndex];
        } else {
            newIndexPath = [NSIndexPath indexPathWithIndex: itemIndex];
        }
        BxTreeListScrollViewItemData * newItemData = [self getItemDataWithIndexPath: newIndexPath lastPosition: lastPosition];
        [currentItemData.subitems addObject: newItemData];
    }

    currentItemData.allHeight = *lastPosition - currentItemData.position;

    return [currentItemData autorelease];
}

- (void) clearBuffer
{
    while (_itemBuffer.count > 0) {
        NSUInteger itemIndex = _itemBuffer.count - 1;
        BxTreeListScrollViewItemData * itemData = _itemBuffer[itemIndex];
        NSLog(@"Remove view: %@", itemData.view);
        [itemData.view removeFromSuperview];
        itemData.view = nil;
        [_itemBuffer removeObjectAtIndex:itemIndex];
    }
}

- (NSIndexPath*) indexPathFromPoint: (CGPoint) point
                    currentItemData: (BxTreeListScrollViewItemData **) currentItemData
                   currentIndexPath: (NSIndexPath*) currentIndexPath
{
    BxTreeListScrollViewItemData * itemData = *currentItemData;
    if (point.y < (*currentItemData).itemHeight + itemData.position + 0.1f &&
            point.y + 0.1f > itemData.position)
    {
        return currentIndexPath;
    }
    if (point.y < itemData.allHeight + itemData.position + 0.1f &&
            point.y + 0.1f > itemData.position)
    {
        int index = 0;
        for (BxTreeListScrollViewItemData * itemData in (*currentItemData).subitems) {
            if (point.y < itemData.allHeight + itemData.position + 0.1f &&
                    point.y + 0.1f > itemData.position)
            {
                *currentItemData = itemData;
                if (currentIndexPath) {
                    return [self indexPathFromPoint: point currentItemData: currentItemData currentIndexPath: [currentIndexPath indexPathByAddingIndex: index]];
                } else {
                    return [self indexPathFromPoint: point currentItemData: currentItemData currentIndexPath: [NSIndexPath indexPathWithIndex: index]];
                }
            }
            index++;
        }
    }
    return nil;
}

- (NSIndexPath*) indexPathFromPoint: (CGPoint) point
{
    BxTreeListScrollViewItemData * currentItemData = _rootItemData;
    return [self indexPathFromPoint: point currentItemData: &currentItemData currentIndexPath: nil];
}

- (CGFloat) getHeightView: (UIView<BxTreeListItemProtocol> *) itemView itemData: (BxTreeListScrollViewItemData *) itemData
{
    if (itemData.itemHeight < 0.1f) {
        return itemView.frame.size.height;
    } else {
        return itemData.itemHeight;
    }
}

- (void) updateView: (UIView*) view position: (CGFloat) position height: (CGFloat) height
{
    view.frame = CGRectMake(0.0f, position, self.frame.size.width, height);
}

- (UIView<BxTreeListItemProtocol> *) viewAddToBufferWithIndexPath: (NSIndexPath*) indexPath itemData: (BxTreeListScrollViewItemData *) itemData
{
    UIView<BxTreeListItemProtocol>* itemView = itemData.view;
    if (!itemView) {
        itemView = [_dataSource treeListScrollView:self itemOfIndexPath:indexPath];
        if (itemView) {
            CGFloat realItemPosition = itemData.position + [itemView shiftY];
            [self updateView: itemView position: realItemPosition height: [self getHeightView:itemView itemData:itemData]];
            [self insertSubview: itemView atIndex: 0];
            NSLog(@"Create view: %@", itemView);
        }
        itemData.view = itemView;
        [_itemBuffer addObject:itemData];
    }
    return itemView;
}

- (UIView<BxTreeListItemProtocol> *) viewFromPoint: (CGPoint) point
{
    BxTreeListScrollViewItemData * itemData = _rootItemData;
    NSIndexPath * indexPath = [self indexPathFromPoint: point currentItemData: &itemData currentIndexPath: nil];
    return [self viewAddToBufferWithIndexPath: indexPath itemData: itemData];
}

- (NSIndexPath*) indexPathFromRect: (CGRect) rect
                   currentItemData: (BxTreeListScrollViewItemData **) currentItemData
                  currentIndexPath: (NSIndexPath*) currentIndexPath
{
    BxTreeListScrollViewItemData * itemData = *currentItemData;
    if (rect.origin.y + rect.size.height < itemData.itemHeight + itemData.position + 0.1f &&
            rect.origin.y + 0.1f > itemData.position)
    {
        return currentIndexPath;
    }
    if (rect.origin.y + rect.size.height + 0.1f > itemData.allHeight + itemData.position &&
            rect.origin.y < itemData.position + 0.1f)
    {
        return currentIndexPath;
    }
    if (rect.origin.y + rect.size.height < itemData.allHeight + itemData.position + 0.1f &&
            rect.origin.y + 0.1f > itemData.position)
    {
        int index = 0;
        for (BxTreeListScrollViewItemData * itemData in (*currentItemData).subitems) {
            if (rect.origin.y + rect.size.height < itemData.allHeight + itemData.position + 0.1f &&
                    rect.origin.y + 0.1f > itemData.position)
            {
                *currentItemData = itemData;
                if (currentIndexPath) {
                    return [self indexPathFromRect: rect currentItemData: currentItemData currentIndexPath: [currentIndexPath indexPathByAddingIndex: index]];
                } else {
                    return [self indexPathFromRect: rect currentItemData: currentItemData currentIndexPath: [NSIndexPath indexPathWithIndex: index]];
                }
            }
            index++;
        }
    }
    return nil;
}

- (NSIndexPath*) indexPathFromRect: (CGRect) rect
{
    BxTreeListScrollViewItemData * currentItemData = _rootItemData;
    return [self indexPathFromRect: rect currentItemData: &currentItemData currentIndexPath: nil];
}

- (NSIndexPath*) indexPathFromVisualView: (UIView<BxTreeListItemProtocol> *) view
{
    if (view) {
        for (BxTreeListScrollViewItemData * itemData in _itemBuffer) {
            if (itemData.view == view) {
                return [self indexPathFromRect: CGRectMake(0.0f, itemData.position, self.contentSize.width, itemData.allHeight)];
            }
        }
    }
    return nil;
}

- (BxTreeListScrollViewItemData *) getItemDataFrom: (NSIndexPath*) indexPath
{
    BxTreeListScrollViewItemData * result = _rootItemData;
    for (int index = 0; index < [indexPath length]; index++) {
        NSUInteger arrayIndex = [indexPath indexAtPosition: index];
        if ( result.subitems.count > arrayIndex ) {
            result = [result.subitems objectAtIndex: arrayIndex];
        } else {
            return nil;
        }
    }
    return result;
}

- (CGPoint) topPointFromIndexPath: (NSIndexPath*) indexPath
{
    BxTreeListScrollViewItemData * result = [self getItemDataFrom: indexPath];
    return CGPointMake(0.0f, result.position);
}

- (CGFloat) fixebaleShiftFromIndexPath: (NSIndexPath*) indexPath
{
    CGFloat result = 0.0f;
    
    BxTreeListScrollViewItemData * itemData = [self getItemDataFrom: indexPath];
    [self viewAddToBufferWithIndexPath: indexPath itemData: itemData];
    if (itemData.view.stationingStyle != NormalItemStationingStyle) {
        result += itemData.view.stationingHeight - itemData.view.startTransformHeight;
    }
    if (indexPath.length > 1) {
        result += [self fixebaleShiftFromIndexPath: [indexPath indexPathByRemovingLastIndex]];
    }
    return result;
}

- (void) scrollToIndexPath: (NSIndexPath*) indexPath animated: (BOOL) animated
{
    if (indexPath) {
        CGPoint point = [self topPointFromIndexPath: indexPath];
        CGFloat shift = [self fixebaleShiftFromIndexPath: [indexPath indexPathByRemovingLastIndex]];
        point.y -= shift;
        [self setContentOffset: point animated: animated];
    }
}

- (void) shiftItemsWithY: (CGFloat) y afterView: (UIView<BxTreeListItemProtocol> *) afterView
{
    if (y > 0) {
        for (BxTreeListScrollViewItemData * currentItem in _itemBuffer) {
            if (currentItem.view.center.y - 0.9f > afterView.center.y) {
                currentItem.view.center = CGPointMake(currentItem.view.center.x, currentItem.view.center.y + y);
            }
        }
    }
}

- (CGFloat) topBufferHeight
{
    return self.frame.size.height;
}

//! Scroll

- (void) scrollItemData: (BxTreeListScrollViewItemData * ) currentItemData
         superItemShift: (CGFloat) superItemShift
              indexPath: (NSIndexPath*) indexPath
{
    int itemIndex = 0;
    while (_itemBuffer.count > itemIndex) {
        BxTreeListScrollViewItemData * itemData = [_itemBuffer objectAtIndex:itemIndex];
        BOOL isViewing = (itemData.position < self.contentOffset.y + [self topBufferHeight] &&
                itemData.position + itemData.allHeight > self.contentOffset.y) && (itemData.position < self.contentOffset.y + [self topBufferHeight]);
        if (!isViewing) {
            NSLog(@"Remove view: %@", itemData.view);
            [itemData.view removeFromSuperview];
            itemData.view = nil;
            [_itemBuffer removeObjectAtIndex:itemIndex];
        } else {
            itemIndex++;
        }
    }
    //[self updateBufferFrom: rootItemData indexPath: nil];
    itemIndex = 0;
    CGFloat newSuperItemShift = superItemShift;
    for (BxTreeListScrollViewItemData * itemData in currentItemData.subitems) {
        NSIndexPath * newIndexPath;

        if (itemData.position < self.contentOffset.y + [self topBufferHeight] &&
                itemData.position + itemData.allHeight > self.contentOffset.y)
            // в поле видимости этот элемент
        {

            if (indexPath) {
                newIndexPath = [indexPath indexPathByAddingIndex: itemIndex];
            } else {
                newIndexPath = [NSIndexPath indexPathWithIndex: itemIndex];
            }

            if (itemData.position < self.contentOffset.y + [self topBufferHeight]) {


                if (itemData.view) {
                } else {
                    [self viewAddToBufferWithIndexPath: newIndexPath itemData: itemData];
                }

                UIView<BxTreeListItemProtocol> * itemView = itemData.view;
                CGFloat headerHeight = [itemView stationingHeight];
                CGFloat realItemHeight = [self getHeightView:itemView itemData:itemData];
                CGFloat realItemPosition = itemData.position + [itemView shiftY];
                if (realItemPosition + realItemHeight - headerHeight > self.contentOffset.y + superItemShift  + [itemView shiftY] || itemView.stationingStyle == NormalItemStationingStyle) // эллемент не цепляется
                {
                    [self updateView: itemView position: realItemPosition height: realItemHeight];
                }
                else if (realItemPosition + itemData.allHeight - headerHeight + itemView.startTransformHeight < self.contentOffset.y + superItemShift  + [itemView shiftY]) // эллемент цепляется не уезжая
                {
                    [self updateView: itemView position: realItemPosition + itemData.allHeight - headerHeight + itemView.startTransformHeight height: headerHeight];

                    if (itemData.itemHeight < 0.1f) {
                        headerHeight -= realItemHeight + [itemView shiftY];
                    }

                    newSuperItemShift = itemView.frame.origin.y - self.contentOffset.y + headerHeight;
                }
                else // эллемент цепляется уезжая
                {
                    [self updateView: itemView position: self.contentOffset.y + superItemShift + [itemView shiftY] height: headerHeight];
                    if (itemData.itemHeight < 0.1f) {
                        headerHeight = 0.0f;
                    }
                    newSuperItemShift = superItemShift + headerHeight;
                }
                [itemView toStationingY: realItemHeight - itemView.frame.size.height];
            }
            [self scrollItemData: itemData superItemShift: newSuperItemShift indexPath: newIndexPath];

        } else {
            // можно осуществить выход из цикла при оптимизации
            //break;
        }
        itemIndex++;
    }
}

- (void) update
{
    //ParcsisLog(@"Start update");
    [self clearBuffer];

    [_rootItemData release];
    _rootItemData = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(getItemDataCustomDocumentTableView:)])
    {
        _rootItemData = [[_dataSource getItemDataCustomDocumentTableView:self] retain];
    }
    if (!_rootItemData) {
        CGFloat position = 0.0f;
        _rootItemData = [[self getItemDataWithIndexPath: nil lastPosition: &position] retain];
    }
    self.contentSize = CGSizeMake(self.frame.size.width, _rootItemData.allHeight);
    [self scrollItemData: _rootItemData superItemShift:0.0f indexPath:nil];
    NSLog(@"Stop update");
}

- (void) updateFromIndexPath: (NSIndexPath*) indexPath
{
    BxTreeListScrollViewItemData * itemData = [self getItemDataFrom: indexPath];
    if (itemData.view) {
        [itemData.view removeFromSuperview];
        itemData.view = nil;
        [_itemBuffer removeObjectIdenticalTo:itemData];
        [self scrollItemData:_rootItemData superItemShift:0.0f indexPath:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollDelegate && [_scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_scrollDelegate scrollViewDidScroll:scrollView];
    }

    [self scrollItemData:_rootItemData superItemShift:0.0f indexPath:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_scrollDelegate && [_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame: frame];
    //[self update];
    CGFloat resizeScale = 1.0f;
    if (_dataSource && [_dataSource respondsToSelector:@selector(getItemDataCustomDocumentTableView:)])
    {
        BxTreeListScrollViewItemData * itemData = [_dataSource getItemDataCustomDocumentTableView:self];
        if (itemData) {
            [self clearBuffer];
            resizeScale = itemData.allHeight / _rootItemData.allHeight;
            [_rootItemData release];
            _rootItemData = [itemData retain];
        }
    }
    self.contentSize = CGSizeMake(self.frame.size.width, _rootItemData.allHeight);
    self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y * resizeScale);
    [self scrollItemData:_rootItemData superItemShift:0.0f indexPath:nil];
}

/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView;                                               // any offset changes
 - (void)scrollViewDidZoom:(UIScrollView *)scrollView __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2); // any zoom scale changes

 // called on start of dragging (may require some time and or distance to move)
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
 // called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
 - (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
 // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

 - (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt

 - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;     // return a view that will be scaled. if delegate returns nil, nothing happens
 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2); // called before the scroll view begins zooming its content
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale; // scale between minimum and maximum. called after any 'bounce' animations

 - (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
 - (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
 */



- (void) dealloc
{
    [_itemBuffer autorelease];
    _itemBuffer = nil;
    self.dataSource = nil;
    [super dealloc];
}

@end
/**
 *	@file BxViewItemsList.m
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

#import "BxViewItemsList.h"
#import "ItemsListPanGestureRecognizer.h"
#import "QuartzCore/QuartzCore.h"

@interface BxViewItemValue : NSObject

@property (nonatomic) NSUInteger index;
@property (nonatomic) CGSize size;
@property (nonatomic, retain) UIView<BxViewItem>* view;
@property (nonatomic, retain) NSString * identyfier;

@end

@implementation BxViewItemsList {
    double _currentInertialDelta;
}

- (void) initObject
{
    _itemsValueLayers = [[NSMutableArray alloc] init];
    _bufferedItemValues = [[NSMutableArray alloc] init];
    _removedItemViews = [[NSMutableDictionary alloc] init];
    _bufferMinCount = 3;
    _inertial = 0;
    _isSticked = YES;
    _isScale = YES;
    _isCentred = YES;
    _isVisualBordered = NO;
    _enabled = YES;
    _orientation = BxViewItemsListVerticalOrientation;

    _panGestureRecognizer = [[ItemsListPanGestureRecognizer alloc] initWithTarget:self action:@selector(_gestureDidChange:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    _panGestureRecognizer.cancelsTouchesInView = NO;
    _panGestureRecognizer.delegate = self;

    _indicatorView = [[UIView alloc] initWithFrame: CGRectZero];
    _indicatorView.backgroundColor = [UIColor colorWithWhite: 0.3f alpha: 0.5f];
    _indicatorView.layer.cornerRadius = 5;
    _indicatorView.alpha = 0.0f;

    _lastSize = self.frame.size;
}

- (void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _panGestureRecognizer.enabled = enabled;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initObject];
    }
    return self;
}

- (CGFloat) getLength: (CGSize) size
{
    if (_orientation == BxViewItemsListHorizontalOrientation) {
        return size.width;
    } else if (_orientation == BxViewItemsListVerticalOrientation) {
        return size.height;
    } else {
        [NSException raise: @"NotSupportException" format: @"Current orientation not supported in getLength"];
    }
    return 0.0f;
}

- (CGRect) transformToVertical: (CGRect) frame
{
    if (_orientation == BxViewItemsListHorizontalOrientation) {
        return CGRectMake(frame.origin.y , frame.origin.x, frame.size.height, frame.size.width);
    } else if (_orientation == BxViewItemsListVerticalOrientation) {
        return frame;
    } else {
        [NSException raise: @"NotSupportException" format: @"Current orientation not supported in transfornHorizontalToVertical"];
    }
    return CGRectZero;
}

- (CGRect) transformToHorizontal: (CGRect) frame
{
    if (_orientation == BxViewItemsListHorizontalOrientation) {
        return frame;
    } else if (_orientation == BxViewItemsListVerticalOrientation) {
        return CGRectMake(frame.origin.y , frame.origin.x, frame.size.height, frame.size.width);
    } else {
        [NSException raise: @"NotSupportException" format: @"Current orientation not supported in transfornHorizontalToVertical"];
    }
    return CGRectZero;
}

- (CGFloat) getPosition: (CGPoint) point
{
    if (_orientation == BxViewItemsListHorizontalOrientation) {
        return point.x;
    } else if (_orientation == BxViewItemsListVerticalOrientation) {
        return point.y;
    } else {
        [NSException raise: @"NotSupportException" format: @"Current orientation not supported in getPosition"];
    }
    return 0.0f;
}

- (void) addToBufferItem: (BxViewItemValue*) addingItem
{
    if (!addingItem.view) {
        addingItem.view = [self.dataSource viewForViewItemsList: self layer: 0 index: addingItem.index];
        NSUInteger index = 0;
        for (; index < _bufferedItemValues.count; index++) {
            if (addingItem.index > index) {
                break;
            }
        }
        [_bufferedItemValues insertObject: addingItem atIndex: index];
        [self updateViewFromItem: addingItem];
        [self addSubview: addingItem.view];
    }
}

- (void) removeFromBufferItem: (BxViewItemValue*) removedItem
{
    [removedItem.view removeFromSuperview];
    // черезмерная проверка, потому как ничего пока не работает
    if (!removedItem.identyfier) {
        removedItem.identyfier = @"";
    }
    if ((!removedItem) || (!removedItem.view)) {
        return;
    }
    NSMutableArray * removedList = _removedItemViews[removedItem.identyfier];
    if (!removedList) {
        removedList = [[NSMutableArray alloc] init];
        _removedItemViews[removedItem.identyfier] = removedList;
        [removedList release];
    }
    [removedList addObject: removedItem.view];
    removedItem.view = nil;
    [_bufferedItemValues removeObjectIdenticalTo: removedItem];
}

- (UIView<BxViewItem>*)viewFromBufferWithIdentifier: (NSString*)identifier
{
    NSMutableArray * removedList = _removedItemViews[identifier];
    if (removedList && removedList.count > 0) {
        UIView<BxViewItem>* result = [removedList[removedList.count - 1] retain];
        [removedList removeObjectAtIndex: removedList.count - 1];
        return [result autorelease];
    }
    return nil;
}

- (UIView<BxViewItem>*)createBufferedViewWithIdentifier:(NSString *)identifier forLayer:(NSUInteger)layer index:(NSUInteger)index creator: (BxViewItemCreateHandler) creator
{
    BxViewItemValue * item = _itemsValueLayers[layer][index];
    item.identyfier = identifier;
    UIView<BxViewItem>* result = [self viewFromBufferWithIdentifier:identifier];
    if (!result) {
        result = creator();
    }
    return result;
}

- (BxViewItemValue*) getItemFromView: (UIView<BxViewItem>*) view
{
    for (BxViewItemValue* item in _bufferedItemValues) {
        if (item.view && item.view == view) {
            return item;
        }
    }
    return nil;
}

- (UIView<BxViewItem>*) getViewFromIndex: (NSUInteger) index
{
    for (BxViewItemValue* item in _bufferedItemValues) {
        if (item.view && item.index == index) {
            return item.view;
        }
    }
    return nil;
}

- (void) updateContentItemValue: (BxViewItemValue*) value withLayer: (NSUInteger) layerIndex itemIndex: (NSUInteger) itemIndex
{
    CGSize itemSize = [self.dataSource viewItemsList: self sizeOfItemsInLayer: layerIndex index: itemIndex];
    value.size = itemSize;
    value.index = itemIndex;
}

- (BxViewItemValue*) getContentItemValueWithLayer: (NSUInteger) layerIndex itemIndex: (NSUInteger) itemIndex
{
    BxViewItemValue * value = [[[BxViewItemValue alloc] init] autorelease];
    [self updateContentItemValue: value withLayer: layerIndex itemIndex: itemIndex];
    return value;
}

- (void) updateSize
{
    _allPosition = 0.0f;
    for (NSUInteger layerIndex = 0; layerIndex < _layersCount; layerIndex++) {
        NSMutableArray * currentLayer = _itemsValueLayers[layerIndex];
        NSUInteger itemsCount = (NSUInteger)[self.dataSource viewItemsList: self numberOfItemsInLayer: layerIndex];
        for (NSUInteger itemIndex = 0; itemIndex < itemsCount; itemIndex++) {
            BxViewItemValue * value = currentLayer[itemIndex];
            [self updateContentItemValue: value withLayer: layerIndex itemIndex: itemIndex];
            _allPosition += [self getLength: value.size];
        }
    }
}

- (BOOL) checkBoardPosition
{
    return _isCentredOfFull && _allPosition < [self getLength: self.frame.size];
}

- (void) updateWithoutRefreshWithIndex: (NSInteger) index
{
    _endBorderedIndex = 0;
    for (NSUInteger layerIndex = 0; layerIndex < _layersCount; layerIndex++) {
        NSMutableArray * currentLayer = _itemsValueLayers[layerIndex];
        NSUInteger itemsCount = [self.dataSource viewItemsList: self numberOfItemsInLayer: layerIndex];
        _endBorderedPosition = 0.0f;
        for (NSInteger itemIndex = itemsCount - 1; itemIndex >= 0; itemIndex--) {
            BxViewItemValue * value = currentLayer[(NSUInteger) itemIndex];
            _endBorderedPosition += [self getLength: value.size];
            if (_endBorderedPosition > [self getLength: self.frame.size]) {
                _endBorderedIndex = itemIndex;
                break;
            }
        }
    }
    if ([self checkBoardPosition]) {
        NSMutableArray * currentLayer = _itemsValueLayers[0];
        _currentIndex = currentLayer.count / 2;
    }
    _currentShift = [self borderLineShiftWithIndex: index];
    [self updateFromNewIndex: index animated: NO];
}

- (void) updateWithIndex: (NSInteger) index
{
    // clearing
    for (NSInteger i = _bufferedItemValues.count - 1; i >= 0; i--) {
        BxViewItemValue * removedItem = _bufferedItemValues[i];
        [self removeFromBufferItem: removedItem];
    }
    [_bufferedItemValues removeAllObjects];
    [_itemsValueLayers removeAllObjects];
    
    _layersCount = [self.dataSource numberOfLayersInContentItemScroll: self];
    _currentIndex = index;
    for (int layerIndex = 0; layerIndex < _layersCount; layerIndex++) {
        NSUInteger itemsCount = [self.dataSource viewItemsList: self numberOfItemsInLayer: layerIndex];
        NSMutableArray * currentLayer = [[NSMutableArray alloc] initWithCapacity: itemsCount];
        [_itemsValueLayers addObject: currentLayer];
        [currentLayer release];
        for (int itemIndex = 0; itemIndex < itemsCount; itemIndex++) {
            BxViewItemValue * value = [[[BxViewItemValue alloc] init] autorelease];
            [currentLayer addObject: value];
        }
    }
    [self updateSize];
    [self updateWithoutRefreshWithIndex: index];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (fabs(_lastSize.width - self.frame.size.width) > 0.5 || fabs(_lastSize.height - self.frame.size.height) > 0.5) {
        [self updateWithoutRefreshWithIndex: _currentIndex];
        _lastSize = self.frame.size;
    }
}

- (void) shiftViewPosition: (CGFloat) shift animated: (BOOL) animated
{
    _currentShift += shift;
    [self showIndicator];
    [self updateFromShiftWithAnimated: animated];
}

- (void)layoutIndicator
{
    CGRect boundsRect = [self transformToVertical: self.frame];
    CGFloat width = 10;
    CGFloat height = boundsRect.size.height;
    CGFloat position = 0;

    NSUInteger count = [self.dataSource viewItemsList: self numberOfItemsInLayer: 0];
    if (count > _currentIndex){
        height /= count;

        // TODO учет перемещения надо сделать более плавным, для этого надо задействовать мат аппарат целиком
        CGFloat currentLength;
        if (_currentShift > 0 && _currentIndex > 0) {
            BxViewItemValue * item = _itemsValueLayers[0][_currentIndex - 1];
            currentLength = [self getLength: item.size];
        } else {
            BxViewItemValue * item = _itemsValueLayers[0][_currentIndex];
            currentLength = [self getLength: item.size];
        }
        if (currentLength < 0.01){
            currentLength = 1;
        }



        // TODO _isCentred ? 0.5f : 0 это хак, надо более точное определение позиции
        position = boundsRect.size.height / count * ((CGFloat )_currentIndex - _currentShift / currentLength + (_isCentred ? 0.5f : 0.0f));
    }

    _indicatorView.frame = [self transformToVertical:
            CGRectMake(boundsRect.size.width - width, truncf(position), width, height)];
}

- (void)showIndicator {
    [self addSubview: _indicatorView];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(hideIndicator) object: nil];
    if (_indicatorView.alpha < 0.5){
        [self layoutIndicator];
        [UIView animateWithDuration: 0.25 animations: ^(){
            _indicatorView.alpha = 1.0f;
        }];
    } else {
        [UIView animateWithDuration: 0.1 animations: ^(){
            [self layoutIndicator];
        }];
    }
    [self performSelector: @selector(hideIndicator) withObject: nil afterDelay: 1.5];
}

- (void)hideIndicator {
    [UIView animateWithDuration: 0.75 animations: ^(){
        _indicatorView.alpha = 0.0f;
    }];
}

- (BxViewItemValue*) visualItemFrom: (NSInteger) index
{
    NSArray * layer = _itemsValueLayers[0];
    if (layer.count > index) {
        return layer[index];
    } else {
        return nil;
    }
}

- (UIView<BxViewItem>*) visualItemViewFrom: (NSInteger) index
{
    return [self visualItemFrom: index].view;
}

- (UIView<BxViewItem>*) currentItemView
{
    return [self visualItemViewFrom: _currentIndex];
}

- (void) updateFromNewIndex: (NSInteger) index animated: (BOOL) animated
{
    if (_itemsValueLayers.count < 1) {
        return;
    }
    NSInteger startIndex = index - _bufferMinCount / 2 + (_bufferMinCount + 1) % 2;
    NSInteger stopIndex = index + _bufferMinCount / 2;
    if (startIndex < 0) {
        stopIndex -= startIndex;
        startIndex = 0;
    }
    if (stopIndex >= ((NSArray*) _itemsValueLayers[0]).count) {
        stopIndex = ((NSArray*) _itemsValueLayers[0]).count - 1;
    }
    for (NSInteger i = (int)_bufferedItemValues.count - 1; i >= 0; i--) {
        BxViewItemValue * removedItem = _bufferedItemValues[(NSUInteger) i];
        if (removedItem.index < startIndex || removedItem.index > stopIndex) {
            [self removeFromBufferItem: removedItem];
        }
    }
    for (NSInteger i = startIndex; i < stopIndex + 1; i++) {
        BxViewItemValue * addingItem = [self visualItemFrom: i];
        [self addToBufferItem: addingItem];
    }
    // сортировка уже предусмотрена в методе addToBufferItem
    /*[bufferedItemValues sortUsingComparator: ^(ContentItemValue* obj1, ContentItemValue* obj2) {
     if (obj1.index > obj2.index) {
     return (NSComparisonResult)NSOrderedDescending;
     } else if (obj1.index < obj2.index) {
     return (NSComparisonResult)NSOrderedAscending;
     } else {
     return (NSComparisonResult)NSOrderedSame;
     }
     }];*/
    if (animated) {
        [UIView beginAnimations: nil context: nil];
    }
    for (BxViewItemValue * item in _bufferedItemValues) {
        [self updateViewFromItem: item];
    }
    if (animated) {
        [UIView commitAnimations];
    }
    if ([self.delegate respondsToSelector:@selector(viewItemsList:changeLayer:index:)]) {
        [self.delegate viewItemsList: self changeLayer: 0 index: index];
    }
}

- (CGFloat) borderLineShiftWithIndex: (NSInteger) index
{
    if ([self checkBoardPosition]) {
        NSMutableArray * currentLayer = _itemsValueLayers[0];
        NSUInteger count = currentLayer.count;
        if (count > 0) {
            BxViewItemValue * value = currentLayer[count / 2];
            if (count % 2 == 0) {
                return [self getLength: self.frame.size] / 2.0f;
            } else {
                return [self getLength: self.frame.size] / 2.0f - [self getLength: value.size] / 2.0f;
            }
        } else {
            return 0.0f;
        }
    }
    if (_isCentred) {
        if (_isVisualBordered && _itemsValueLayers.count > 0) {
            NSMutableArray * currentLayer = _itemsValueLayers[0];
            if (index == 0 && currentLayer.count > 0) {
                BxViewItemValue * value = currentLayer[0];
                return [self getLength: value.size] / 2.0f;
            } else if (currentLayer.count > 0 && index == currentLayer.count - 1){
                BxViewItemValue * value = currentLayer[currentLayer.count - 1];
                return [self getLength: self.frame.size] - [self getLength: value.size] / 2.0f;
            }
        }
        return [self getLength: self.frame.size] / 2.0f;
    } else {
        if (_isVisualBordered && _itemsValueLayers.count > 0) {
            NSMutableArray * currentLayer = _itemsValueLayers[0];
            if (currentLayer.count > 0 && _endBorderedIndex < currentLayer.count - 1 && index == _endBorderedIndex + 1)
            {
                BxViewItemValue * value = currentLayer[_endBorderedIndex];
                return [self getLength: value.size] - (_endBorderedPosition - [self getLength: self.frame.size]);
            }
        }
        return 0.0f;
    }
}

- (CGFloat) borderLineShift
{
    return [self borderLineShiftWithIndex: _currentIndex];
}

- (float) scaleOfValue: (float) value
{
    if (_isScale) {
        float scale = 1.0f * ABS(value);
        if (scale > 0.8f) {
            scale = 0.8f;
        }
        if (scale < 0.0f) {
            scale = 0.0f;
        }
        return 1.0f - scale;
    } else {
        return 1.0f;
    }
    
    //return 1.0f;
}

- (float) scaleOfPosition: (float) position
{
    CGFloat scale = [self getLength: self.frame.size];
    if (fabs(scale) < 0.01){
        scale = 1;
    }
    return [self scaleOfValue: (position - [self borderLineShift]) / scale];
}

- (CGFloat) getPositonFromItem: (BxViewItemValue*) item startPosition: (CGFloat) startPosition startIndex: (NSInteger) startIndex
{
    CGFloat position = startPosition;
    CGFloat scale = 1.0f; // странное поведение
    //CGFloat scale = [self scaleOfPosition: position];
    if (item.index > startIndex) {
        position += [self getLength: [self visualItemFrom: startIndex].size] * scale / 2.0f;
        for (NSInteger index = startIndex + 1; index < item.index; index++) {
            BxViewItemValue* lastItem = [self visualItemFrom: index];
            scale = [self scaleOfPosition: position];
            position += [self getLength: lastItem.size] * scale;
        }
        CGFloat scaleDiver = [self getLength: self.frame.size] - [self getLength: item.size] / 2.0f;
        if (fabs(scaleDiver) < 0.01) {
            scaleDiver = 1;
        }
        scale = [self scaleOfValue: (position - [self borderLineShiftWithIndex: startIndex]) / scaleDiver];
        position += [self getLength: item.size] * scale / 2.0f;
    } else if (item.index < startIndex) {
        position -= [self getLength: [self visualItemFrom: startIndex].size] * scale / 2.0f;
        for (NSInteger index = startIndex - 1; index > item.index; index--) {
            BxViewItemValue* lastItem = [self visualItemFrom: index];
            scale = [self scaleOfPosition: position];
            position -= [self getLength: lastItem.size] * scale;
        }
        // в этом случае последний минус должен был стать плюсом
        CGFloat scaleDiver = [self getLength: self.frame.size] - [self getLength: item.size] / 2.0f;
        if (fabs(scaleDiver) < 0.01) {
            scaleDiver = 1;
        }
        scale = [self scaleOfValue: (position - [self borderLineShiftWithIndex: startIndex]) / scaleDiver];
        position -= [self getLength: item.size] * scale / 2.0f;
    }
    return position;
}

- (CGFloat)getPositionFromItem: (BxViewItemValue*) item
{
    return [self getPositonFromItem: item startPosition: _currentShift startIndex: _currentIndex];
}

- (BOOL) itemIsCurrentWithIndex: (NSInteger) index
{
    BxViewItemValue * currentItem = [self visualItemFrom: index];
    CGFloat position = [self getPositionFromItem:currentItem];
    CGFloat scale = [self scaleOfPosition: position];
    return ABS(position - [self borderLineShiftWithIndex: index]) < scale * [self getLength: currentItem.size] * 0.8;
}

- (void) updateViewFromItem: (BxViewItemValue*) item
{
    CGFloat position = [self getPositionFromItem:item];
    CGFloat scale = [self scaleOfPosition: position];
    
    item.view.transform = CGAffineTransformMakeScale(scale, scale);
    if (_isCentred) {
        //position -= [self getLength: item.size] * scale / 2.0f;
    } else {
        // тут скорее всего currentIndex == item.index
        position += [self getLength: [self visualItemFrom: _currentIndex].size] / 2.0f;
    }
    
    if (_orientation == BxViewItemsListHorizontalOrientation) {
        item.view.frame = CGRectMake(position - item.size.width * scale / 2.0f,
                                     (self.frame.size.height - item.size.height * scale) / 2.0f,
                                     item.size.width * scale, item.size.height * scale);
    } else if (_orientation == BxViewItemsListVerticalOrientation) {
        item.view.frame = CGRectMake((self.frame.size.width - item.size.width * scale) / 2.0f,
                                     position - item.size.height * scale / 2.0f,
                                     item.size.width * scale, item.size.height * scale);
    } else {
        [NSException raise: @"NotSupportException" format: @"Current orientation not supported in updateViewFromItem"];
    }
    
}

- (BOOL) isBorderBeginCheckedIndex: (NSInteger) index
{
    if ([self checkBoardPosition]) {
        NSUInteger count = ((NSArray*) _itemsValueLayers[0]).count;
        return index == count / 2;
    }
    if (_isVisualBordered) {
        if (_isCentred) {
            BxViewItemValue* item = [self visualItemFrom: 0];
            CGFloat position = [self getPositonFromItem:item startPosition: [self borderLineShiftWithIndex: index] startIndex: index];
            CGFloat scale = [self scaleOfPosition: position];
            position = - position + [self getLength: item.size] * scale / 2.0f ;
            return position > 0;
        } else {
            return YES;
        }
    }
    return YES;
}

- (BOOL) isBorderEndCheckedIndex: (NSInteger) index
{
    if ([self checkBoardPosition]) {
        NSUInteger count = ((NSArray*) _itemsValueLayers[0]).count;
        return index == count / 2;
    }
    if (_isVisualBordered) {
        NSUInteger count = ((NSArray*) _itemsValueLayers[0]).count;
        if (count > 0) {
            BxViewItemValue* item = [self visualItemFrom: count - 1];
            CGFloat position = [self getPositonFromItem: item startPosition: [self borderLineShiftWithIndex: index] startIndex: index];
            CGFloat scale = [self scaleOfPosition: position];
            position += [self getLength: item.size] * scale / 2.0f;
            position += [self getLength: [self visualItemFrom: index].size] / 2.0f;
            return position > [self getLength: self.frame.size];
        }
    }
    return YES;
}

- (void) updateFromShiftWithAnimated: (BOOL) animated
{
    if ([self itemIsCurrentWithIndex: _currentIndex]) {
        if (animated) {
            [UIView beginAnimations: nil context: nil];
            //[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        }
        for (BxViewItemValue * item in _bufferedItemValues) {
            [self updateViewFromItem: item];
        }
        if (animated) {
            [UIView commitAnimations];
        }
    } else {
        // проверки краевых условий
        if (_currentIndex > 0 && _currentShift > [self borderLineShiftWithIndex: _currentIndex - 1] && [self isBorderBeginCheckedIndex: _currentIndex]) {
            CGFloat position = [self getPositionFromItem:[self visualItemFrom: _currentIndex - 1]];
            _currentIndex = _currentIndex - 1;
            _currentShift = position;
        } else if (_currentIndex < ((NSArray*) _itemsValueLayers[0]).count - 1 &&
                   _currentShift < [self borderLineShiftWithIndex: _currentIndex + 1] &&
                   [self isBorderEndCheckedIndex: _currentIndex])
        {
            CGFloat position = [self getPositionFromItem:[self visualItemFrom: _currentIndex + 1]];
            _currentIndex = _currentIndex + 1;
            _currentShift = position;
        }
        [self updateFromNewIndex: _currentIndex animated: animated];
    }
}

- (void)_gestureDidChange:(UIGestureRecognizer *)gesture
{
    static float delta = 0;
    static BOOL isTouch = 0;
    if (gesture == _panGestureRecognizer) {
        if (_panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            delta = 0;
            isTouch = YES;
            _lastPadingPageIndex = _currentIndex;//[self getPageIndexFromOffset: self.contentOffset.x cenredPaging: self.cenredPaging];
            [self cancelInertialMove];
        } else if (_panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            delta = [self getPosition: [_panGestureRecognizer translationInView:self]];
            isTouch = NO;
            [self shiftViewPosition: delta animated: NO];
            //[self setContentOffset: CGPointMake(self.contentOffset.x - delta, 0.0f)];
            [_panGestureRecognizer setTranslation:CGPointZero inView:self];
        } else if (_panGestureRecognizer.state == UIGestureRecognizerStateEnded )
                //|| _panGestureRecognizer.state == UIGestureRecognizerStateCancelled
                //|| _panGestureRecognizer.state == UIGestureRecognizerStateFailed)
        {
            if (_inertial > 0) {
                float inertialDelta = 1;
                if (fabs(_panGestureRecognizer.lastTime) > 0.01 ) {
                    inertialDelta = _panGestureRecognizer.lastTime;
                }
                _currentInertialDelta = delta / inertialDelta / 3.0;
                // ограничение на скорость пролистывания:
                CGFloat shiftLimit = [self transformToVertical: self.frame].size.height;
                if (ABS(_currentInertialDelta) > shiftLimit) {
                    _currentInertialDelta = shiftLimit * __inline_signbitd(_currentInertialDelta);
                }
            } else {
                _currentInertialDelta = 0;
            }

            [self endMove:delta isTouch: isTouch];
            
            if (isTouch) {
                if ([self.delegate respondsToSelector: @selector(touthViewItemsList:layer:index:)]) {
                    [self.delegate touthViewItemsList: self layer:0 index: _currentIndex];
                }
            }
        }
    }
}

- (BOOL) isInertial
{
    return ABS(_currentInertialDelta) > 1 && _inertial > 0;
}

- (void)endMove:(CGFloat)delta isTouch: (BOOL) isTouch{
    if (_isSticked || _isVisualBordered || [self isInertial]) {
        NSInteger index = _currentIndex;
        if (/*ABS(delta) > 1 && */ !isTouch) {
            if (_lastPadingPageIndex == index) {
                if (delta > 0 && index > 0 && [self isBorderBeginCheckedIndex: _currentIndex])
                {
                    index--;
                } else if (delta < 0 && index < ((NSArray*) _itemsValueLayers[0]).count - 1 &&
                        [self isBorderEndCheckedIndex: _currentIndex])
                {
                    index++;
                }
            }
        }
        CGFloat position = -[self getPositionFromItem:[self visualItemFrom:index]] + [self borderLineShiftWithIndex: index];

        if (_isSticked || (index < 1 && position < 0) || (index > ((NSArray*) _itemsValueLayers[0]).count - 2 && position > 0)){
            if ([self isInertial]) {
                [self inertialShift: _currentInertialDelta / 2.0];
            } else {
                [self shiftViewPosition: position animated: YES];
            }
        } else {
            if ([self isInertial]){
                [self inertialShift: _currentInertialDelta];
            }
        }
    }
}

- (void) cancelInertialMove
{
    _currentInertialDelta = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(inertialDelayShift) object: nil];
}

- (void)inertialDelayShift{
    [self shiftViewPosition:(CGFloat) trunc(_currentInertialDelta) animated:YES];
    [self endMove:(CGFloat) trunc(_currentInertialDelta) isTouch: NO];
}

- (void)inertialShift:(double)delta{
    _currentInertialDelta = delta * _inertial;
    if ([self isInertial]) {
        [self performSelector: @selector(inertialDelayShift) withObject: @(delta) afterDelay: 0.04];
    } else {
        [self endMove:(CGFloat) _currentInertialDelta isTouch: NO];
    }
}

- (void) refreshWithDeleteIndex: (NSUInteger) index animated: (BOOL) animated
{
    NSInteger newCount = [self.dataSource viewItemsList: self numberOfItemsInLayer: 0];
    NSInteger currentCount = ((NSArray*) _itemsValueLayers[0]).count;
    if (newCount != currentCount - 1){
        [NSException raise: @"RefreshException" format: @"The counts from deleted and not is not equals. Expected %d, reason %d", (int) currentCount - 1, (int)newCount];
    }
    NSInteger indexInBuffer = -1;
    for (BxViewItemValue * item in _bufferedItemValues) {
        indexInBuffer++;
        if (item.index == index && item.view) {
            break;
        }
    }

    if (indexInBuffer > -1 && indexInBuffer < _bufferedItemValues.count) {
        NSUInteger realIndexInBuffer = (NSUInteger) indexInBuffer;
        BxViewItemValue * removedItem = _bufferedItemValues[realIndexInBuffer];
        [UIView animateWithDuration: 0.5
                         animations: ^{
                             removedItem.view.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
                             [_bufferedItemValues removeObjectAtIndex: realIndexInBuffer];
                             [(NSMutableArray*) _itemsValueLayers[0] removeObjectAtIndex:index];
                             for (NSUInteger i = removedItem.index; i < ((NSArray*) _itemsValueLayers[0]).count; i++) {
                                 BxViewItemValue * item = ((NSArray *) _itemsValueLayers[0])[i];
                                 item.index--;
                             }
                             if (index < _currentIndex) {
                                 _currentIndex--;
                             }
                             [self updateFromNewIndex: _currentIndex animated: NO];
                         }
                         completion: ^(BOOL finished){
                             [self removeFromBufferItem: removedItem];
                         }];
    }
}

- (void) refreshWithAddIndex: (NSUInteger) index animated: (BOOL) animated
{
    NSInteger newCount = [self.dataSource viewItemsList: self numberOfItemsInLayer: 0];
    NSInteger currentCount = ((NSArray*) _itemsValueLayers[0]).count;
    if (newCount != currentCount + 1){
        [NSException raise: @"RefreshException" format: @"The counts from add and not is not equals. Expected %d, reason %d", (int) currentCount - 1, (int)newCount];
    }
    
    BxViewItemValue * addedItem = [self getContentItemValueWithLayer: 0 itemIndex: index];
    addedItem.view.transform  = CGAffineTransformMakeScale(0.001f, 0.001f);
    [((NSMutableArray*) _itemsValueLayers[0]) insertObject: addedItem atIndex: index];
    for (NSUInteger addingIndex = index + 1; addingIndex < ((NSArray*) _itemsValueLayers[0]).count; addingIndex++)
    {
        BxViewItemValue * item = ((NSArray *) _itemsValueLayers[0])[addingIndex];
        item.index++;
    }
    [self addToBufferItem: addedItem];
    
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         [self updateFromNewIndex: _currentIndex animated: NO];
                     }
                     completion: ^(BOOL finished){
                         //
                     }];
}

- (void) refreshAnimated: (BOOL) animated{
    NSInteger newCount = [self.dataSource viewItemsList: self numberOfItemsInLayer: 0];
    NSInteger currentCount = ((NSArray*) _itemsValueLayers[0]).count;
    if (newCount != currentCount){
        [NSException raise: @"RefreshException" format: @"The counts from refresh and not is not equals. Expected %d, reason %d", (int) currentCount - 1, (int)newCount];
    }
    [self updateSize];
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         //[self updateFromNewIndex: currentIndex];
                         //for (BxViewItemValue * item in bufferedItemValues) {
                         //    [self updateViewFromItem: item];
                         //}
                         [self updateFromShiftWithAnimated: NO];
                     }
                     completion: ^(BOOL finished){
                     }];
}

- (void) dealloc
{
    [_indicatorView autorelease];
    _indicatorView = nil;
    [_panGestureRecognizer autorelease];
    _panGestureRecognizer = nil;
    [_itemsValueLayers autorelease];
    _itemsValueLayers = nil;
    [_bufferedItemValues autorelease];
    _bufferedItemValues = nil;
    [_removedItemViews autorelease];
    _removedItemViews = nil;
    [super dealloc];
}

@end

@implementation BxViewItemValue

- (void) dealloc
{
    [_identyfier autorelease];
    _identyfier = nil;
    [_view autorelease];
    _view = nil;
    [super dealloc];
}

@end

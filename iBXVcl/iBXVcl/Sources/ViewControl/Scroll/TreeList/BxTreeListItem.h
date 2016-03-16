/**
 *	@file BxTreeListItem.h
 *	@namespace iBXVcl
 *
 *	@details Протокол элемента древовидного списка
 *	@date 23.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

typedef enum {
    NormalItemStationingStyle = 0,
    LevelFixedItemStationingStyle = 1,
    TransformFixedItemStationingStyle = 2,
} ItemStationingStyle;

//! Протокол элемента древовидного списка
@protocol BxTreeListItemProtocol <NSObject>

//! например у section = 0, у cell = 1
- (int) level;
//! например у section = LevelFixedItemStationingStyle, у cell = NormalItemStationingStyle
- (ItemStationingStyle) stationingStyle;
//! поле необходимо для трансформации секций с определенной высоты
- (CGFloat) stationingHeight;
//! сдвиг эллемента вниз, если требуется (это для многослойных таблиц используется)
- (CGFloat) shiftY;
//! служебное поле, вызывается для изменения поведения в зависимости от перемещения по документу
- (void) toStationingY: (CGFloat) y;
//! Высота, с которой начинает сдвигать текущий элемент одноуровнего
- (CGFloat) startTransformHeight;

@end
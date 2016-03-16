/**
 *	@file ItemsListPanGestureRecognizer.h
 *	@namespace iBXVcl
 *
 *	@details Жесты для линейного списка
 *	@date 24.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

//! Жесты для линейного списка
@interface ItemsListPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, readonly) double lastTime;
@end
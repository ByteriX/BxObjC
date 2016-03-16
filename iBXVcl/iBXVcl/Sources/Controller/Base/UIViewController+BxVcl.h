/**
 *	@file UIViewController+BxVcl.h
 *	@namespace iBXVcl
 *
 *	@details UIViewController категория для перехода на дизайн iOS 7
 *	@date 25.11.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface UIViewController (BxVcl)

//! Для любой версии iOS вернет края области, которая показывается на экране без наложенных на них панелей
- (CGRect) extendedEdgesBounds;

//! Для любой версии iOS вернет края области, которая показывается на экране без наложенных на них панелей
- (CGFloat) topExtendedEdges;
- (CGFloat) bottomExtendedEdges;

//! возвращает показанный на экране контроллер
+ (UIViewController *) topMostController;

@end

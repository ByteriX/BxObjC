/**
 *	@file BxUIUtils.h
 *	@namespace iBXCommon
 *
 *	@details Утилиты для интерфейса
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BxUIUtils : NSObject

//! Возвращает самое главное представление для текущего
+ (UIView*) getSuperParentView: (UIView*) view;

//! Возвращает размер занимаемый во view клавиатурой
+ (CGRect) getKeyboardFrameIn: (UIView *) view userInfo: (NSDictionary*) userInfo;

@end

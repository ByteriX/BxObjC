/**
 *	@file UIImage+BxUtils+Prefix.h
 *	@namespace iBXCommon
 *
 *	@details Категория для UIImage для идентификации префиксов в названии изображения
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface UIImage (BxUtilsPrefix)

//! Вызывается автоматически, для того чтобы идентифицировать '-568h' и '-ios7' до '@2x' в названии изображения
+ (void)load;

@end

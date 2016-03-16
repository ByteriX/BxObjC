/**
 *	@file BxLoadedImagePageView.h
 *	@namespace iBXVcl
 *
 *	@details Кешируемое изображение из сети на странице
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxPageView.h"
#import "BxLoadedImageViewItem.h"

@interface BxLoadedImagePageView : BxPageView

@property (nonatomic, retain) BxLoadedImageViewItem *imageView;

@end

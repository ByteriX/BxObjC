/**
 *	@file BxPageControl.h
 *	@namespace iBXVcl
 *
 *	@details UIPageControl с кастомным представлением индикатора
 *	@date 06.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface BxPageControl : UIPageControl

@property (nonatomic, retain) UIImage * activeImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIImage * inactiveImage UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat indention UI_APPEARANCE_SELECTOR;

@end

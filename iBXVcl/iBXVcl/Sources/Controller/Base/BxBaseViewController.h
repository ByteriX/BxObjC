/**
 *	@file BxBaseViewController.h
 *	@namespace iBXVcl
 *
 *	@details Базовый контролер
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface BxBaseViewController : UIViewController

//! автоматически прячет навигационную панель и дает возможность показать ее в нужный момент
@property (nonatomic) BOOL autoHideNavigationBar;

//! при первом показе скрывает навигационную панель при autoHideNavigationBar = YES
@property (nonatomic) BOOL autoHideNavigationBarFromShow;

//! Тап на контролелере всегда можно обработать иначе, чем при выбранном autoHideNavigationBar == YES
- (void) tapAction;

@end

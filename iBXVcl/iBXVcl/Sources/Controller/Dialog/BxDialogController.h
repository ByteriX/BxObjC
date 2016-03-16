/**
 *	@file DialogController.h
 *	@namespace iBXVcl
 *
 *	@details Нижняя панель с кнопками, в диалоговом режиме
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxServiceController.h"

@interface BxDialogController : BxServiceController {
@protected
	UIView * _contentView;
	UILabel * _titleLabel;
    UIImageView * _backMessagePanel;
    CGFloat _titleHeight;
}

@end

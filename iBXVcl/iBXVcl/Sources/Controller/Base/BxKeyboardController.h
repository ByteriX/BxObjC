/**
 *	@file BxKeyboardController.h
 *	@namespace iBXVcl
 *
 *	@details Контроллер подразумевающий использование клавиатуры
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxBaseViewController.h"

@interface BxKeyboardController : BxBaseViewController {
@protected
	BOOL _keyboardShown;
}
@property (nonatomic, readonly) UIView * contentView;

- (BOOL) isAlwaysShowKeyboard;
- (BOOL) isAlwaysHiddenKeyboard;
- (BOOL) isContentResize;

- (void) onWillChangeContentSizeWithShow: (BOOL) isKeyBoardWillShow;
- (void) onDidChangeContentSizeWithShow;

- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWasHidden:(NSNotification*)aNotification;

@end

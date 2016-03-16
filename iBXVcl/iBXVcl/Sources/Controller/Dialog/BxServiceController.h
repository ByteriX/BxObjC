/**
 *	@file ServiceController.h
 *	@namespace iBXVcl
 *
 *	@details Контролер, позволяющий показывать диалоговые представления
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxBaseViewController.h"

@class BxServiceController;

@protocol BxServiceControllerDelegate <NSObject>

@optional

- (BOOL) willDismiss: (BxServiceController*) serviceController;

@end


//! Экран, который как модальный блокирует все другие экраны
@interface BxServiceController : BxBaseViewController {
}

@property (readonly, getter = isPresented) BOOL presented;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, assign) id<BxServiceControllerDelegate> delegate;
//! позволяет автоматически закрываться, при нажатии в фоновую область
@property (nonatomic) BOOL autoDismiss;
//! позволяет автоматичекси подправлять фон в соответствии с ios 5-9 и далее
@property (nonatomic) BOOL autoBackground;
//! показывать контролер можно только этим методом, причем он закроет только экран parent,
//! соответственно, если вы передали, к примеру, navigationController.topViewController, то панель navigationBar он не закроет
- (void) presentFromParent: (UIViewController*) parent animated: (BOOL) animated;

- (void) dismissAnimated: (BOOL) animated;

- (UIView*) getViewFromParent: (UIViewController*) parent;

// методы необходимы для событий вычищения из памяти контролера
- (void) dismissWillStop;
- (void) dismissDidStop;

@end

/*@interface UIViewController (ServiceController)

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

@end*/

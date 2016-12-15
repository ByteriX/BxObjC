/**
 *	@file BxNavigationController.h
 *	@namespace iBXVcl
 *
 *	@details UINavigationController с кучей прибалуток
 *	@date 30.01.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@class BxNavigationController;
@class BxNavigationBar;

@interface UIViewController (BxNavigationController)

// get BxNavigationController instead UINavigationController
@property(strong, nonatomic, readonly) BxNavigationController *navController;

//! Если возвращает NO, то не позволяет покинуть контроллер, например для завершения операции. По умолчанию YES
- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController;
//! Этот контролер вызывается в случае pop батчем, правильнее его использовать совместно с функцией immediatePopViewController: animated:, однако он совершенно не покрывает navigationShouldPopController:
- (BOOL) navigationShouldPopController: (BxNavigationController*) navigationController toController: (UIViewController*) toController;

//! Перед реальным выходом вызывается
- (void) navigationWillPopController: (BxNavigationController*) navigationController;

//! Если определен как не nil, то эта понель по высоте будет показана ниже navigationBar. Высота панельки влияет на extendedEdgesBounds, учитывайте этот факт. Оптимальней будет, если вы это представление закешируете в своем контролере. Метод может вызываться до создания представления контролера.
- (UIView*) navigationToolPanelWithController: (BxNavigationController*) navigationController;
- (UIView*) navigationBackgroundWithController: (BxNavigationController*) navigationController;

@end

@interface BxNavigationController : UINavigationController

@property (nonatomic, weak, readonly) UIView * toolPanel;
@property (nonatomic, weak, readonly) UIView * backgroundView;

//! реальный, немедленный выход с контролера.
- (UIViewController *) immediatePopViewControllerAnimated:(BOOL)animated;
- (NSArray *) immediatePopViewController: (UIViewController *) toController animated:(BOOL)animated;

//! Производит проверку контролера на отображение панели сверху
- (void)checkPanelController:(UIViewController *)viewController animated: (BOOL) animated;

//! Прячет верхнюю панель
- (void) hidePanelAnimated: (BOOL) animated;

@end

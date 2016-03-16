/**
 *	@file BxSplashViewController.h
 *	@namespace iBXVcl
 *
 *	@details Отображение сплеша
 *	@date 15.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxVcl.h"

typedef void (^BxSplashAction)();

//! отображение сплеша
@interface BxSplashViewController : BxDialogController

@property (nonatomic, retain) UIImage * splashImage;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic, copy) BxSplashAction action;

+ (void) checkFromParent: (UIViewController*) viewController image: (UIImage*) image time: (NSTimeInterval) time action: (BxSplashAction) action;
+ (void) checkFromParent: (UIViewController*) viewController;

//! этот метод можно переопределить для выполнения фоновых действий, по умолчанию выполняется блок action
- (void) execute;

@end

/**
 *	@file BxAppearance.h
 *	@namespace iBXVcl
 *
 *	@details реализация патерна appearance
 *	@date 06.04.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface BxAppearance : NSObject

+ (id) appearanceForClass:(Class)thisClass;

- (void) startForwarding:(id)sender;

@end

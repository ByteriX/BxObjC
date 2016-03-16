/**
 *	@file BxIconWorkspacePageView.h
 *	@namespace iBXVcl
 *
 *	@details Страница для рабочего стола с иконками
 *	@date 29.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@class BxIconWorkspaceItemControl;


@interface BxIconWorkspacePageView : UIView
{
}

@property (nonatomic, strong, readonly) NSMutableArray * icons;

- (void) addIcon: (BxIconWorkspaceItemControl*) icon;
- (void) insertIcon: (BxIconWorkspaceItemControl*) icon atIndex: (NSUInteger) index;

@end
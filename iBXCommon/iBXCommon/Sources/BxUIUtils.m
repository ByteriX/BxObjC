/**
 *	@file BxUIUtils.m
 *	@namespace iBXCommon
 *
 *	@details Утилиты для интерфейса
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxUIUtils.h"

@implementation BxUIUtils

+ (UIView*) getSuperParentView: (UIView*) view
{
	if (view.superview && ![view.superview isKindOfClass: UIWindow.class]) {
		return [self getSuperParentView: view.superview];
	}
	return view;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (CGRect) keyBoardRect: (NSDictionary*) userInfo {
	NSObject * temp = [userInfo objectForKey: @"UIKeyboardFrameEndUserInfoKey"];
	if (temp) {
		NSValue* aValue = [userInfo objectForKey: UIKeyboardFrameEndUserInfoKey];
		return [aValue CGRectValue];
	} else {
#ifndef IPAD
		NSValue* aValue = [userInfo objectForKey: UIKeyboardCenterEndUserInfoKey];
		CGPoint point = [aValue CGPointValue];
		aValue = [userInfo objectForKey: UIKeyboardBoundsUserInfoKey];
		CGRect rect = [aValue CGRectValue];
		rect.origin.x = point.x - rect.size.width / 2.0f;
		rect.origin.y = point.y - rect.size.height / 2.0f;
		return rect;
#else
        return [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
#endif
	}
}
#pragma clang diagnostic pop

+ (CGRect) getKeyboardFrameIn: (UIView *) view userInfo: (NSDictionary*) userInfo
{
	CGRect keyBoardRect = [self keyBoardRect: userInfo];
	keyBoardRect =  [view convertRect: keyBoardRect fromView: nil];
	return keyBoardRect;
}

@end

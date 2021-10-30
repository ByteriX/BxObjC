/**
 *	@file BxActionSheet.h
 *	@namespace iBXCommon
 *
 *	@details Suggest for action
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxCommon.h"

typedef void(^BxActionSheetHandler)(NSInteger buttonIndex);

#if IS_OS_SDK_9_ALLOWED

@interface BxActionSheet : NSObject

//! стандартный ActionSheet через блоки
+ (void) showActionSheetWithTitle: (NSString *) title
                cancelButtonTitle: (NSString *) cancelButtonTitle
                otherButtonTitles: (NSArray *) otherButtonTitles
                   viewController: (UIViewController*) viewController
                          handler: (BxActionSheetHandler) handler;

#else

@interface BxActionSheet : UIActionSheet <UIActionSheetDelegate>

//! стандартный ActionSheet через блоки
+ (void) showActionSheetWithTitle: (NSString *) title
                cancelButtonTitle: (NSString *) cancelButtonTitle
                otherButtonTitles: (NSArray *) otherButtonTitles
                             view: (UIView*) view
                          handler: (BxActionSheetHandler) handler;

#endif

@end

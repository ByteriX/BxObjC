/**
 *	@file PhotoViewServiceController.h
 *	@namespace iBXVcl
 *
 *	@details Просмотр фото из определенной области
 *	@date 01.11.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxServiceController.h"

@interface BxPhotoViewServiceController : BxServiceController
{
@protected
    UIImageView * _photoView;
    CGRect _startRect;
}

- (void) presentFromParent: (UIViewController*) parent imageView: (UIImageView*) imageView animated: (BOOL) animated;

@end

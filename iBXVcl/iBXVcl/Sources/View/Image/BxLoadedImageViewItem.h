/**
 *	@file BxLoadedImageViewItem.h
 *	@namespace iBXVcl
 *
 *	@details Кешируемое изображение из сети
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxData.h"
#import "BxViewItem.h"

@class BxLoadedImageViewItem;

typedef void (^BxLoadedImageViewItemHandler)(BxLoadedImageViewItem * view);

@interface BxLoadedImageViewItem : UIView <BxViewItem>
{
@protected
    UIImageView * _contentImage;
    UIActivityIndicatorView * _activityView;
    UIButton * _btAction;
}
@property (nonatomic, readonly) UIActivityIndicatorView * activityView;
@property (nonatomic, readonly) UIImageView * contentImage;
@property (nonatomic, copy) BxLoadedImageViewItemHandler actionHandler;
@property (nonatomic, copy) BxLoadedImageViewItemHandler loadedHandler;

+ (BxDownloadOldFileCasher*) casher;
+ (NSOperationQueue*) queue;
+ (UIImage*) notLoadedImage;

- (void) initObject;

- (void) setImageURL: (NSString*) url;

+ (UIImage*) cashedImageFromURL: (NSString*) url;

@end

/**
 *	@file BxTextView.h
 *	@namespace iBXVcl
 *
 *	@details UITextView c placeholder
 *	@date 22.08.2015
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@interface BxTextView : UITextView{
@protected
    BOOL _shouldDrawPlaceholder;
}
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;


@end

/**
 *	@file BxOldInputTableCell.h
 *	@namespace iBXVcl
 *
 *	@details Устаревшая ячейка для табличного ввода
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@class BxOldInputTableController;

@interface BxOldInputTableCell : UITableViewCell {
@protected
	BOOL _isComment;
    CGFloat _height;
}
@property (nonatomic, readonly) UILabel * titleLable;
@property (nonatomic, readonly) UILabel * valueLabel;
@property (nonatomic, readonly) UILabel * subtitleLabel;
@property (nonatomic, assign) BxOldInputTableController * parent;

+ (id) cellFrom: (NSDictionary*) data parent: (BxOldInputTableController*) parent;

- (void) setComment: (NSString*) comment;

+ (CGFloat) tagWidth;

- (CGFloat) minValueWidth;

- (CGFloat) height;

- (void) update;

@end
/**
 *	@file BxIconWorkspaceItemControl.h
 *	@namespace iBXVcl
 *
 *	@details Иконка рабочего стола
 *	@date 29.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

@class BxIconWorkspaceView;

@interface BxIconWorkspaceItemControl : UIControl {
@protected
    BxIconWorkspaceView *_owner;
    SEL _action;
    BOOL _isStart;
    BOOL _isStartMoved;
    double _angleShift;
}

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, weak) BxIconWorkspaceView * target;
@property (nonatomic) CGFloat indention UI_APPEARANCE_SELECTOR;


@property (nonatomic, copy) NSString * idName;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action idName: (NSString*) idName;

@end
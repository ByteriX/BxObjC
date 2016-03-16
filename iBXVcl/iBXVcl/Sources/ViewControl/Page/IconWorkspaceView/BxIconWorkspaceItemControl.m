/**
 *	@file BxIconWorkspaceItemControl.m
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

#import "BxIconWorkspaceItemControl.h"
#import "BxIconWorkspaceView.h"
#import "BxUtils.h"

@interface BxIconWorkspaceItemControl ()

@property (nonatomic) double angle;
@property (nonatomic) BOOL isMoved;
@property (nonatomic, weak) UIView * backSuperView;

- (void) onStart;

@end

@interface BxIconWorkspaceView (BxIconWorkspaceItemControl)

@property (nonatomic) BOOL isMoved;
@property BOOL isClick;

- (void) checkPageForMovingPosition: (CGPoint) position;
- (void) sortWithMoving: (BxIconWorkspaceItemControl*) icon;

@end


@implementation BxIconWorkspaceItemControl

static float maxAngle = 0.07f;

- (void) setAngle: (double) angle
{

    _angle = angle;
    if (_angle > M_PI){
        _angle -= 2 * M_PI;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil]; // готовим вторую часть анимации
    [UIView setAnimationDelay: 0.0];
    [UIView setAnimationDuration: 0.1];

    [self setTransform: CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat) _angle)];

    [UIView commitAnimations];
}

- (void) stepAngle
{
    if (!_isMoved){
        if (fabs(_angle) > maxAngle){
            _angleShift *= -1.0f;
        }
        [self setAngle:_angle + _angleShift];
    }
}

- (void) randomAngle
{
    _angle = (1.0f - 2.0f * [BxUtils getRandom]) * maxAngle;
}

- (void) setIsStartSelected: (BOOL) isStartSelected
{
    [UIView beginAnimations:nil context:nil];
    if (isStartSelected){
        [UIView setAnimationDuration: 0.15f];
        _iconView.alpha = 0.3f;
        _isStart = YES;
    } else {
        [UIView setAnimationDuration: 0.30f];
        _iconView.alpha = 1.0f;
        _isStart = NO;
    }
    [UIView commitAnimations];
}

- (void) setIsMoved: (BOOL) isMoved
{
    _isMoved = isMoved;
    if (_isMoved){
        [self setAngle: 0];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.2];
        [self setTransform: CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)];
        self.alpha = 0.5;
        [UIView commitAnimations];
        self.backSuperView = self.superview;
        [_owner addSubview:self];
    } else {
        [self.backSuperView addSubview: self];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.2];
        [self setTransform: CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
        self.alpha = 1.0;
        [_owner updateIcons];
        [UIView commitAnimations];
    }
}

- (void) checkToStart
{
    [self setIsStartSelected: NO];
    _owner.isMoved = YES;
    [self onStart];
}

- (void) checkStart
{
    [NSThread sleepForTimeInterval: 0.75];
    if ((!_owner.isMoved) && _isStart)
    {
        if (_owner.editable){
            [self performSelectorOnMainThread:@selector(checkToStart) withObject: nil waitUntilDone: YES];
        } else {
            [self setIsStartSelected: NO];
        }
    }
}

- (void) checkToMove
{
    //[self setIsStartSelected: NO];
    if (_isStartMoved){
        self.isMoved = YES;
    }
    //UITouch * touch = [[event allTouches] anyObject];
    //self.center = [touch locationInView: _owner.view];
}

- (void) checkMove
{
    [NSThread sleepForTimeInterval: 0.0];
    if (_owner.isMoved){
        [self performSelectorOnMainThread:@selector(checkToMove) withObject: nil waitUntilDone: YES];
    }
}

- (void) onStart
{
    if (_owner.isMoved){
        _isStartMoved = YES;
        [NSThread detachNewThreadSelector:@selector(checkMove) toTarget:self withObject:nil];
    } else {
        [self setIsStartSelected: YES];
        [NSThread detachNewThreadSelector:@selector(checkStart) toTarget:self withObject:nil];
    }
}

- (void) onStartClick: (UIButton*) sender
{
    if (!_owner.isClick) {
        _owner.isClick = YES;
        [self onStart];
    }
}

/*- (void) setCenter: (CGPoint) center
{
	center.x += _owner.currentPageIndex * _owner.view.frame.size.width;
	[super setCenter: center];
}*/

- (void) onStartDrag: (UIButton*) sender event: (UIEvent *) event
{
    if (_isMoved)
    {
        UITouch * touch = [[event allTouches] anyObject];
        CGPoint position = [touch locationInView:_owner];


        [_owner checkPageForMovingPosition:position];

        self.center = position;

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.1];
        [_owner sortWithMoving:self];
        [UIView commitAnimations];
    } else {
        _isStartMoved = NO;
    }
}

- (void) onStopClicked: (BOOL) clicked
{
    _owner.isClick = NO;
    if (_isStart){
        [self setIsStartSelected: NO];
        if (clicked){
            if (_action && _target && [_target respondsToSelector: _action]){
                //[_target performSelector: _action withObject: self];
                // заменил на это:
                IMP imp = [_target methodForSelector: _action];
                void (*func)(id, SEL) = (void *)imp;
                func(_target, _action);
            }
        }
    } else if (_isStartMoved /*&& (!_owner.pageControlUsed)*/) {
        _isStartMoved = NO;
        if (_isMoved){
            self.isMoved = NO;
        }
    }

}

- (void) onStopClick: (UIButton*) sender
{
    [self onStopClicked: YES];
}

- (void) onStopDrag: (UIButton*) sender
{
    [self onStopClicked: NO];
}

- (CGFloat) getNameLabelWidth
{
    return self.frame.size.width;
}

- (UIFont*) getFont
{
    return [UIFont systemFontOfSize: 10.0f];
}

- (void) setStyleFor: (UILabel *) label
{
    label.textColor = [UIColor blackColor];
    label.font = [self getFont];
    label.numberOfLines = 3;
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.textAlignment = NSTextAlignmentCenter;
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action idName: (NSString*) idName
{
    self.target = target;
    _action = action;
    _indention = 8.0f;
    if (self = [super initWithFrame:CGRectMake(0, 0, 60, 60)]) {
        _idName = idName;
        _isStart = NO;
        _isMoved = NO;
        _isStartMoved = NO;
        _angle = 0.0f;
        _angleShift = 0.07f;
        if ([BxUtils getRandom] > 0.5){
            _angleShift *= -1.0;
        }

        self.autoresizesSubviews = NO;

        [self addTarget: self action: @selector(onStartDrag:event:) forControlEvents: UIControlEventTouchDragInside];
        //[self addTarget: self _action: @selector(onStopDrag:event:) forControlEvents: UIControlEventTouchDragOutside];

        [self addTarget: self action: @selector(onStartClick:) forControlEvents: UIControlEventTouchDown];
        [self addTarget: self action: @selector(onStopClick:) forControlEvents: UIControlEventTouchUpInside];
        [self addTarget: self action: @selector(onStopDrag:) forControlEvents: UIControlEventTouchDragExit];

        self.backgroundColor = [UIColor clearColor];
        _iconView = [[UIImageView alloc] initWithImage: image];
        _iconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconView];
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 60, 60)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self setStyleFor:_titleLabel];
        _titleLabel.text = title;


        [self addSubview:_titleLabel];
    }
    return self;
}

- (void) setOwner: (BxIconWorkspaceView*) owner
{
    _owner = owner;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
            _owner.iconSize.width - _indention * 2.0f,
            _owner.iconSize.height - _indention * 2.0f);
    _iconView.center = CGPointMake(truncf(self.frame.size.width / 2.0f),
            truncf(_iconView.frame.size.height / 2.0f + _indention));
    float nameLabelWidth = [self getNameLabelWidth] - _indention;
    float nameLabelY = _iconView.frame.size.height + _iconView.frame.origin.y + _indention;
    float nameLabelHeight = self.frame.size.height - nameLabelY;
    _titleLabel.frame = CGRectMake(truncf((self.frame.size.width - nameLabelWidth) / 2.0f),
            truncf(nameLabelY),
            truncf(nameLabelWidth),
            truncf(nameLabelHeight));
    CGRect titleRect = [_titleLabel textRectForBounds:_titleLabel.frame
                               limitedToNumberOfLines:_titleLabel.numberOfLines];
    CGFloat height = titleRect.size.height;
    titleRect = _titleLabel.frame;
    titleRect.size.height = height;
    _titleLabel.frame = titleRect;

}

@end
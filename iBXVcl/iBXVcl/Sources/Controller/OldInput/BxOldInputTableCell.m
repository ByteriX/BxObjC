/**
 *	@file BxOldInputTableCell.m
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

#import "BxOldInputTableCell.h"
#import "BxOldInputTableController.h"
#import "BxCommon.h"

@interface BxOldInputTableController ()

- (BOOL) isYESRow: (NSDictionary*) row fieldName: (const NSString * const) fieldName;
- (BOOL) isBooleanGroupedRow: (NSDictionary*) row;

@end


@interface BxOldInputTableCell ()
@property (nonatomic, retain) NSDictionary * rawData;
@property (nonatomic, retain) UISwitch * currentSwitch;

@end

@implementation BxOldInputTableCell

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	return [self initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
	if (self){
		self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	return self;
}

- (id) initWithData: (NSDictionary*) data1 reuseIdentifier:(NSString *)reuseIdentifier
{
	self.rawData = data1;
	return [self initWithStyle: UITableViewCellStyleDefault reuseIdentifier: reuseIdentifier];
}

+ (id) cellFrom: (NSDictionary*) data parent: (BxOldInputTableController*) parent
{
    BxOldInputTableCell * result = [[[self.class alloc] initWithData: data reuseIdentifier: @"BaseCell"] autorelease];
    result.parent = parent;
    CGRect rect = result.frame;
    rect.size.width = parent.view.frame.size.width;
    result.frame = rect;
    [result setStyle];
    return result;
}

+ (CGFloat) tagWidth
{
    return 10.0f;
}

- (UIColor *) titleTextColor
{
    return [UIColor blackColor];
}

- (UIColor *) subtitleTextColor
{
    return [UIColor blackColor];
}

- (UIColor *) valueTextColor
{
    return [UIColor blackColor];
}

- (UIColor *) placeholderColor
{
    return [UIColor lightGrayColor];
}

- (UIFont *) titleFont
{
    return [_parent.class getTitleFont];
}

- (UIFont *) subtitleFont
{
    return [_parent.class getSubtitleFont];
}

- (UIFont *) valueFont
{
    return [_parent.class getValueFont];
}

- (CGFloat) minValueWidth
{
    return 80.0f;
}

- (void) setStyle
{
	self.backgroundColor = [UIColor whiteColor];
    
    CGFloat tagWidth = [[self class] tagWidth];
    if (_parent.lineShift) {
        tagWidth = _parent.lineShift;
    }
    
    CGFloat cellHeight = self.contentView.frame.size.height;
    
	NSDictionary * element = _rawData;
	
	NSString * title = [element objectForKey: FNInputTableRowHint];
    UIFont * titleFont = [self titleFont];
    if (_parent.titleFont) {
        titleFont = _parent.titleFont;
    }
    
    CGSize titleSize = [title sizeWithFont:titleFont];
    
    BOOL isValue = NO;
	
    CGFloat maxTitleWidth = CGRectGetWidth(self.frame) - 2.0f * tagWidth;
    if([[_rawData objectForKey: FNInputTableRowIsAction] boolValue]) {
        maxTitleWidth -= 40.0f;
        isValue = YES;
    } else if([[_rawData objectForKey: FNInputTableRowIsSwitch] boolValue]) {
        maxTitleWidth -= [self customSwitchWidth];
    } else if ([BxOldInputTableController isBooleanRow: _rawData]) {
        maxTitleWidth -= 40;
    } else {
        maxTitleWidth -= [self minValueWidth];
        isValue = YES;
    }
    
    NSNumber * isEnabled = [element objectForKey:FNInputTableRowIsEnabled];
    if (![[_rawData objectForKey: FNInputTableRowIsAction] boolValue]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (isEnabled && ![isEnabled boolValue]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CGFloat textShift = tagWidth;
    
    id icon = _rawData[FNInputTableRowIcon];
    if (icon) {
        CGFloat iconSize = 40.0f;/*[_parent cellHeightWithData: _rawData]*/;
        textShift = iconSize;
        UIImageView * iconView = [[UIImageView alloc] initWithFrame: CGRectMake(0, truncf((cellHeight - iconSize) / 2.0f), iconSize, iconSize)];
        if ([icon isKindOfClass: NSString.class]) {
            iconView.image = [UIImage imageNamed: icon];
        } else if ([icon isKindOfClass: UIImage.class]) {
            iconView.image = icon;
        }
        iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview: iconView];
        [iconView release];
    }
    maxTitleWidth -= textShift;
    
    if (isValue) {
        maxTitleWidth = MIN(titleSize.width + 1, maxTitleWidth);
    }
    
    NSLineBreakMode lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (_parent.isFloatCellSize) {
        CGSize heightSize = [title sizeWithFont: titleFont constrainedToSize: CGSizeMake(maxTitleWidth + 1, 400) lineBreakMode:lineBreakMode];
        _height = truncf(heightSize.height) + 2.0f * tagWidth;
    } else {
        _height = [_parent cellHeight];
        if (_rawData) {
            NSString * subtitle = [_rawData objectForKey: FNInputTableRowSubtitle];
            if (subtitle) {
                _height += 18.0f;
            }
        }
    }
    
	_titleLable = [[UILabel alloc] initWithFrame: CGRectMake(textShift, 0.0f,
                                                            maxTitleWidth,
                                                            cellHeight)];
    if (_parent.isFloatCellSize) {
        _titleLable.numberOfLines = 0;
    } else {
        _titleLable.numberOfLines = 1;
    }
	_titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.lineBreakMode = lineBreakMode;
	_titleLable.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    _titleLable.font = titleFont;
    if (_parent.titleTextColor) {
        _titleLable.textColor = _parent.titleTextColor;
    } else {
        _titleLable.textColor = [self titleTextColor];
    }
    _titleLable.text = title;
    [self.contentView addSubview: _titleLable];
	[_titleLable release];
    
    
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLable.frame) + 10.0f, 2.0f, CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(_titleLable.frame) - 20.0f, cellHeight - 4.0f)];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    _valueLabel.textAlignment = NSTextAlignmentRight;
    if (_parent.valueFont) {
        _valueLabel.font = _parent.valueFont;
    } else {
        _valueLabel.font = [self valueFont];
    }
    
    [self.contentView addSubview: _valueLabel];
    [_valueLabel release];
    
    NSString * subtitle = [element objectForKey: FNInputTableRowSubtitle];
    if(subtitle) {
        UIView * titleContentView = [[UIView alloc] init];
        titleContentView.backgroundColor = [UIColor clearColor];
        titleContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:titleContentView];
        [titleContentView release];
        
        UIFont * subtitleFont = [self subtitleFont];
        if (_parent.subtitleFont) {
            subtitleFont = _parent.subtitleFont;
        }
        titleSize = [subtitle sizeWithFont:subtitleFont];
        
        [_titleLable sizeToFit];
        _titleLable.frame = CGRectMake(_titleLable.frame.origin.x, 0.0f, CGRectGetWidth(_titleLable.frame), CGRectGetHeight(_titleLable.frame));
        _titleLable.autoresizingMask = UIViewAutoresizingNone;
        [_titleLable retain];
        [_titleLable removeFromSuperview];
        [titleContentView addSubview: _titleLable];
        [_titleLable release];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(tagWidth, CGRectGetMaxY(_titleLable.frame) + 2.0f, titleSize.width, titleSize.height)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _subtitleLabel.autoresizingMask = UIViewAutoresizingNone;
        _subtitleLabel.font = subtitleFont;
        if (_parent.subtitleTextColor) {
            _subtitleLabel.textColor = _parent.subtitleTextColor;
        } else {
            _subtitleLabel.textColor = [self subtitleTextColor];
        }
        _subtitleLabel.text = subtitle;
        [titleContentView addSubview: _subtitleLabel];
        [_subtitleLabel release];
        
        CGFloat titleContentHeight = CGRectGetHeight(_titleLable.frame) + CGRectGetHeight(_subtitleLabel.frame) + 2.0f;
        titleContentView.frame = CGRectMake(tagWidth, truncf((cellHeight - titleContentHeight) / 2.0f), MAX(CGRectGetWidth(_titleLable.frame), CGRectGetWidth(_subtitleLabel.frame)), titleContentHeight);
        
        _valueLabel.frame = CGRectMake(CGRectGetMaxX(titleContentView.frame) + 10.0f, CGRectGetMinY(_valueLabel.frame), CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(titleContentView.frame) - 20.0f, cellHeight);
    }
    
    id value = [_rawData objectForKey: FNInputTableRowValue];
    NSNumber * isSwitch = [element objectForKey: FNInputTableRowIsSwitch];
	if (isSwitch && [isSwitch boolValue] && [value isKindOfClass: NSNumber.class]){
        [self addCustomSwitchWithValue: [value boolValue] onX: _titleLable.frame.origin.x + _titleLable.frame.size.width + tagWidth];
    } else {
        self.currentSwitch = nil;
    }

    if (IS_OS_7_OR_LATER) {
        self.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetMinX(_titleLable.frame), 0.0f, 0.0f);
    }
    
    [self update];
}

- (BOOL) isEnabled
{
    NSNumber * enabled = [_rawData objectForKey: FNInputTableRowIsEnabled];
    return (!enabled) || [enabled boolValue];
}

- (CGFloat) customSwitchWidth
{
    if (IS_OS_7_OR_LATER){
        return 51.0f;
    } else {
        return 96.0f;
    }
}

- (void) addCustomSwitchWithValue: (BOOL) value onX: (CGFloat) x
{
    UISwitch * currentSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
    currentSwitch.frame = CGRectMake(x,
                                     truncf((self.contentView.frame.size.height - currentSwitch.frame.size.height) / 2.0f), currentSwitch.frame.size.width, currentSwitch.frame.size.height);
    currentSwitch.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview: currentSwitch];
    [currentSwitch release];
    self.currentSwitch = currentSwitch;
    [currentSwitch addTarget: self action: @selector(editSwith:) forControlEvents: UIControlEventValueChanged];
}

- (void) editSwith:(UISwitch *) editSwitch
{
    NSMutableDictionary * element = (NSMutableDictionary*)_rawData;
    [element setValue: @(editSwitch.isOn) forKey: (NSString*)FNInputTableRowValue];
    [self.parent didChangedValue: @(editSwitch.isOn) fromFieldName: element[FNInputTableRowFieldName]];
}

- (void) setComment: (NSString*) comment
{
	if (_isComment) {
		_valueLabel.text = comment;
        _subtitleLabel.hidden = YES;
	}
}

- (void) update
{
    _valueLabel.text = @"";
    id value = [_rawData objectForKey: FNInputTableRowValue];
	if (value){
		_isComment = NO;
		if ([value isKindOfClass: NSString.class]) {
            NSNumber * isSecurity = [_rawData objectForKey: FNInputTableRowIsSecurity];
            if (isSecurity && [isSecurity boolValue]) {
                NSString * securityText = @"";
                for (int i = 0; i < ((NSString*)value).length; i++) {
                    securityText = [securityText stringByAppendingString:@"●"];
                }
                _valueLabel.text = securityText;
            } else {
                _valueLabel.text = value;
            }
		} else if ([value isKindOfClass: NSDictionary.class]) {
            if ([value objectForKey: @"name"]) {
                _valueLabel.text = [value objectForKey: @"name"];
            }
        }
	} else {
		_isComment = YES;
	}
    
    if (self.currentSwitch && [value isKindOfClass: NSNumber.class]) {
        self.currentSwitch.enabled = [self isEnabled];
        [self.currentSwitch setOn: [value boolValue]];
    }
    
    NSString * placeholder = [_rawData objectForKey: FNInputTableRowPlaceholder];
    if (_valueLabel.text.length < 1 && placeholder) {
        if (_parent.placeholderColor) {
            _valueLabel.textColor = _parent.placeholderColor;
        } else {
            _valueLabel.textColor = [self placeholderColor];
        }
        _valueLabel.text = placeholder;
    } else {
        if (_parent.valueTextColor) {
            _valueLabel.textColor = _parent.valueTextColor;
        } else {
            _valueLabel.textColor = [self valueTextColor];
        }
    }
    
    if (_parent.isNormalShowingDisadledCell || [self isEnabled]) {
        _titleLable.alpha = 1.0f;
        _subtitleLabel.alpha = 1.0f;
        _valueLabel.alpha = 1.0f;
    } else {
        _titleLable.alpha = 0.5f;
        _subtitleLabel.alpha = 0.5f;
        _valueLabel.alpha = 0.5f;
    }
    
    if ([_parent isYESRow: _rawData fieldName: FNInputTableRowValue] && [_parent isBooleanGroupedRow: _rawData]) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([_parent isYESRow: _rawData fieldName: FNInputTableRowIsAction]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (CGFloat) height
{
    return _height;
}

- (void) dealloc
{
    self.currentSwitch = nil;
    self.rawData = nil;
    [super dealloc];
}

@end

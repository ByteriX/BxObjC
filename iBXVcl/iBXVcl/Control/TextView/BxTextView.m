/**
 *	@file BxTextView.m
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

#import "BxTextView.h"

@interface BxTextView ()

- (void) initialize;
- (void) updateShouldDrawPlaceholder;
- (void) textChanged:(NSNotification *)notification;

@end


@implementation BxTextView
#pragma mark - Accessors

- (void)setText:(NSString *)string {
    [super setText:string];
    [self updateShouldDrawPlaceholder];
}

- (void)setPlaceholder:(NSString *)string {
    if (![string isEqual:_placeholder]) {
        [_placeholder autorelease];
        _placeholder = [string retain];
        [self updateShouldDrawPlaceholder];
    }
}

- (void)setPlaceholderColor:(UIColor *)color {
    [_placeholderColor autorelease];
    if (color) {
        _placeholderColor = [color retain];
    } else {
        _placeholderColor = nil;
    }
    [self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
    [_placeholder autorelease];
    _placeholder = nil;
    [_placeholderColor autorelease];
    _placeholderColor = nil;
    [super dealloc];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        UIColor * placeholderColor = _placeholderColor;
        if (placeholderColor == nil) {
            if (self.textColor) {
                placeholderColor = [self.textColor colorWithAlphaComponent: 0.25];
            } else {
                placeholderColor = [UIColor lightGrayColor];
            }
        }
        
        CGRect rect = CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [_placeholder drawInRect: rect
                      withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                       self.font, NSFontAttributeName,
                                       placeholderColor, NSForegroundColorAttributeName, nil]
             ];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [placeholderColor set];
            [_placeholder drawInRect: rect withFont:self.font];
#pragma clang diagnostic pop
        }
        
    }
}


#pragma mark - Private

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = [UIColor lightGrayColor];
    _shouldDrawPlaceholder = NO;
    self.contentMode = UIViewContentModeRedraw;
}


- (void)updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)textChanged:(NSNotification *)notificaiton {
    [self updateShouldDrawPlaceholder];
}

@end

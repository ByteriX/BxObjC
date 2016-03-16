/**
 *	@file BxHighlightedLabel.m
 *	@namespace iBXVcl
 *
 *	@details Отображение текста с подсветками
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxHighlightedLabel.h"
#import "BxHighlightedTextInfo.h"
#import "BxHighlightedRect.h"
#import "BxCommon.h"

@implementation BxHighlightedLabel

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
{
    self = [self initWithFrame: CGRectMake(position.x, position.y, labelWidth, 0.0f)];
	if ( self ) {
        self.textColor = [UIColor blackColor];
        self.highlightedColor = [UIColor blackColor];
        self.width = labelWidth;
		_isHighlightedTextFound = YES;
		_isLineWordwrap = YES;
		self.backgroundColor = [UIColor clearColor];
		[self setFont: font];
		self.highlightedFont = font;
        self.markColorForAreaInFocus = [UIColor colorWithHex: 0xFFF777];
	}
	return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
    //[self update]; кто до такого додумался???
}

- (void) update
{
    [self sizeToFit];
	[self setNeedsDisplay];
}

- (void) setWidth:(CGFloat)width
{
    _width = width;
    self.highlightedLines = nil;
    [self sizeToFit];
	[self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame: frame];
    [self setNeedsDisplay];
}

- (void) setText: (NSString*) text areas: (NSArray*) areas
{
	self.text = text;
	self.areas = areas;
	//self.numberOfLines = 0;
	[self update];
}

- (void) setTextAlignment: (NSTextAlignment) value
{
    _textAlignment = value;
    [self update];
}

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
			   areas: (NSArray*) areas
		   markColor: (UIColor*) markColor
{
    self = [self initWithWidth: labelWidth position: position font: font];
	if ( self ) {
		self.markColor = markColor;
		[self setText: text areas: areas];
	}
	return self;
}

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
       highlightText: (NSString*) highlightText 
		   markColor: (UIColor*) markColor
{
    NSArray * areas = [BxHighlightedArea areasFromText: text highlightText: highlightText highlightType: HighlightTypeMarked];
    self = [self initWithWidth: labelWidth
                      position: position
                          font: font
                          text: text
                         areas: areas
                     markColor: markColor];
	return self;
}

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
       highlightText: (NSString*) highlightText 
		   markColor: (UIColor*) markColor
       textAlignment: (NSTextAlignment) textAlignment
{
    _textAlignment = textAlignment;
    self = [self initWithWidth: labelWidth
                      position: position
                          font: font
                          text: text
                 highlightText: highlightText 
                     markColor: markColor];
	return self;
}

- (NSArray *) sortAreas: (NSArray *) areasValue
{
    NSArray *sortedArray = [NSArray array];
    if (areasValue && areasValue.count > 0) {
        sortedArray = [areasValue sortedArrayUsingSelector:@selector(comparePosition:)];
    }
    return sortedArray;
}

- (void) setAreas:(NSArray *)areasValue
{
    [_areas autorelease];
    if (areasValue) {
        _areas = [[self sortAreas:areasValue] retain];
    } else {
        _areas = nil;
    }
    self.highlightedLines = nil;
}

- (void) setHighlightedFont:(UIFont *) value
{
    [_highlightedFont release];
    if (value) {
        _highlightedFont = [value retain];
    } else {
        _highlightedFont = nil;
    }
    self.highlightedLines = nil;
}

- (void) setHighlightText: (NSString*) value
{
    NSArray * areas = [BxHighlightedArea areasFromText: _text highlightText: value highlightType: HighlightTypeMarked];
    [self setText: _text areas: areas];
}

static NSLineBreakMode lineBreakMode = NSLineBreakByTruncatingTail;

- (BOOL) isHighlightedTextFound
{
	return _isHighlightedTextFound && _areas && _areas.count > 0 && (_highlightedColor || _markColor);
}

- (void) checkHighlightedLines
{
    if (!_highlightedLines) {
        self.highlightedLines = [self preparedTextInfoWithWidth: self.frame.size.width];
    }
}

- (void) sizeToFit
{
	if ([self isHighlightedTextFound]) {
		[self checkHighlightedLines];
		if (_highlightedLines.count > 0) {
			CGSize spaceSize = [@" " sizeWithFont: self.font];
			BxHighlightedTextInfo * info = [_highlightedLines lastObject];
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (info.levelIndex + 1) * spaceSize.height);
		} else {
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.0f);
		}

	} else {
		CGSize size = [_text sizeWithFont: _font
					   constrainedToSize: CGSizeMake(self.frame.size.width, 1.0e+20f)
						   lineBreakMode: lineBreakMode];
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
	}
}

- (void) drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ([self isHighlightedTextFound]) {
		[self showMarks: context];
	} else {
		CGRect bounds = CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height);
//		CGContextSetFillColorWithColor(context, [[UIUtils default].colorDarkGray CGColor]);
        
        UIColor * color = _textColor;
        if (_selected && _selectedTextColor) {
            color = _selectedTextColor;
        }
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
		[_text drawInRect: bounds withFont: _font lineBreakMode: lineBreakMode alignment: _textAlignment];
	}
}

- (BOOL) isValidRect: (CGRect) rect
{
	return rect.size.width > 0.5f && rect.size.height > 0.5f;
}


- (BOOL) isValidRect: (CGRect) rect size: (CGSize) size
{
	return rect.size.width > 0.5f && rect.size.height >= size.height;
}


- (void) insertParagraphsTo: (NSMutableArray*) result
{
	int adjustmentLevel = 0;
	int index = 0;
	while ( index < result.count ) {
		BxHighlightedTextInfo * textInfo = [result objectAtIndex: index];
		NSRange range = [textInfo.text rangeOfCharacterFromSet: [NSCharacterSet newlineCharacterSet]];
		if (range.length > 0) { // еще условие того что не заканчивается и есть там символ
			BxHighlightedTextInfo * insertedTextInfo = [[textInfo copy] autorelease];
			NSUInteger insertedTextPosition = range.location + range.length;
			insertedTextInfo.text = [textInfo.text substringFromIndex: insertedTextPosition];
			insertedTextInfo.area.position = insertedTextInfo.area.position + insertedTextPosition;
			insertedTextInfo.area.length = insertedTextInfo.area.length - insertedTextPosition;
			[result insertObject: insertedTextInfo atIndex: index + 1];
			
			textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
			textInfo.text = [textInfo.text substringToIndex: range.location];
			textInfo.area.length = range.location;
			
			adjustmentLevel++;
		} else {
			textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
		}
		index++;
	}
}

- (CGSize) sizeFrom: (BxHighlightedTextInfo *) textInfo text: (NSString*) currentText
{
	CGSize size;
    HighlightType type = textInfo.area.type;
	if ((type | HighlightTypeColor) == type && _highlightedFont) {
		size = [currentText sizeWithFont: _highlightedFont];
	} else {
		size = [currentText sizeWithFont: _font];
	}
	return size;
}

- (CGSize) sizeFrom: (BxHighlightedTextInfo *) textInfo
{
	return [self sizeFrom: textInfo text: textInfo.text];
}

- (void) detectRealetivePositons: (NSMutableArray*) result
{
    if (!result || result.count < 1) {
        return;
    }
	CGFloat position = 0.0f;
	int lastLevel = 0;
    for (BxHighlightedTextInfo * textInfo in result) {
        if (textInfo.levelIndex > lastLevel) {
            lastLevel = textInfo.levelIndex;
            position = 0.0f;
        }
        CGSize size = [self sizeFrom: textInfo];
        textInfo.width = size.width;
        textInfo.x = position;
        position += size.width;
    }
}

- (NSArray*) preparedTextInfo
{
	if (!_text || _text.length == 0) {
		return [NSMutableArray array];
	}
	
	NSMutableArray * result = [NSMutableArray arrayWithCapacity: 2 + 2 * _areas.count];
	
	// проверки корректности областей
	NSUInteger position = 0;
    
#ifdef DEBUG
	BxHighlightedArea * mainArea = [[[BxHighlightedArea alloc] initWithPosition: 0 length: _text.length] autorelease];
#endif
	for (BxHighlightedArea * area in _areas) {
#ifdef DEBUG
		/*if ( area.length < 1 ) {
			[WorkingException raise: @"NotCorrectedAreaException" 
							 format: @"preparedTextInfo has not corrected areas for heiglighting (empty area)"];
		}*/
		for (BxHighlightedArea * newArea in _areas) {
            if ( area != newArea ){
                BxHighlightedArea * intersection = [newArea intersectionWith: area];
                if ( intersection ) {
                    [BxException raise: @"NotCorrectedAreaException"
                                     format: @"preparedTextInfo has not corrected areas for heiglighting (having intersections)"]; 
                }
			}
		}
		BxHighlightedArea * intersection = [mainArea intersectionWith: area];
		if (intersection.length != area.length) {
			[BxException raise: @"NotCorrectedAreaException"
							 format: @"preparedTextInfo has not corrected areas for heiglighting (out of bounds)"];
		}
		if ( area.position < position ) {
			[BxException raise: @"NotCorrectedAreaException"
							 format: @"preparedTextInfo has not corrected areas for heiglighting (not sorted)"];
		}
#endif
		if ( area.position >  position ) {
			BxHighlightedArea * simpleTextArea = [[[BxHighlightedArea alloc] initWithPosition: position length: area.position -  position] autorelease];
			NSString * simpleText = [_text substringWithRange: simpleTextArea.range];
			BxHighlightedTextInfo * infoText = [[BxHighlightedTextInfo alloc] initWithText: simpleText];
			infoText.levelIndex = 0;
			infoText.area = simpleTextArea;
			[result addObject: infoText];
			[infoText release];
		}
		
		NSString * markText = [_text substringWithRange: area.range];
		BxHighlightedTextInfo * infoMarkText = [[BxHighlightedTextInfo alloc] initWithText: markText];
		infoMarkText.levelIndex = 0;
        BxHighlightedArea * newTempArray = [area copy];
		infoMarkText.area = newTempArray;
        [newTempArray release];
		[result addObject: infoMarkText];
		[infoMarkText release];
		
		position = area.position + area.length;
	}
	if (position < _text.length) {
		BxHighlightedArea * simpleTextArea = [[[BxHighlightedArea alloc] initWithPosition: position length: _text.length -  position] autorelease];
		NSString * simpleText = [_text substringFromIndex: position];
		BxHighlightedTextInfo * infoText = [[BxHighlightedTextInfo alloc] initWithText: simpleText];
		infoText.levelIndex = 0;
		infoText.area = simpleTextArea;
		[result addObject: infoText];
		[infoText release];
	}
	[self insertParagraphsTo: result];
	[self detectRealetivePositons: result];
	return result;
}

- (void) toLineSeparateTextInfoWithWidth: (CGFloat) labelWidth lines: (NSMutableArray*) lines
{
    CGSize spaceSize = [@" " sizeWithFont: self.font];
	
	int adjustmentLevel = 0;
	CGFloat adjustmentPosition = 0.0f;
	int index = 0;
	int lastLevel = 0;
	while ( index < lines.count ) {
		BxHighlightedTextInfo * textInfo = [lines objectAtIndex: index];
		
		if (textInfo.levelIndex > lastLevel) {
			lastLevel = textInfo.levelIndex;
			adjustmentPosition = 0.0f;
		}
		
		textInfo.x = textInfo.x + adjustmentPosition;
		
		/*if (textInfo.x < 2.0f) {
         CGFloat oldWidth = textInfo.width;
         NSRange range = [textInfo.text rangeOfCharacterFromSet: [NSCharacterSet whitespaceCharacterSet]];
         while (range.length > 0 && range.location == 0) {
         textInfo.text = [textInfo.text substringFromIndex: range.length];
         range = [textInfo.text rangeOfCharacterFromSet: [NSCharacterSet whitespaceCharacterSet]];
         }
         textInfo.width = [self sizeFrom: textInfo].width;
         adjustmentPosition -= oldWidth - textInfo.width;
         }*/
		
		CGSize textSize = [self sizeFrom: textInfo];
		if (textInfo.x + textSize.width > labelWidth) {
			NSRange range = NSMakeRange(0, 0);
			NSRange lastRange = NSMakeRange(0, 0);
			do {
				CGFloat position = range.location + range.length;
				NSRange findRange = NSMakeRange(position, textInfo.text.length - position);
				if (findRange.length > 0) {
					range = [textInfo.text rangeOfCharacterFromSet: [NSCharacterSet whitespaceCharacterSet] 
														   options: NSCaseInsensitiveSearch //NSBackwardsSearch 
															 range: findRange];
				} else {
					break;
				}
				if (range.length > 0) {
					BxHighlightedTextInfo * newTextInfo = [[textInfo copy] autorelease];
					newTextInfo.text = [textInfo.text substringToIndex: range.location];
					CGSize newTextSize = [self sizeFrom: newTextInfo];
					if (newTextInfo.x + newTextSize.width <= labelWidth){
						lastRange = range;
					} else {
						break;
					}
				} else {
					break;
				}
			} while (range.length > 0);
			
			
			
			if (lastRange.length > 0) { // еще условие того что не заканчивается и есть там символ
				BxHighlightedTextInfo * insertedTextInfo = [[textInfo copy] autorelease];
				NSString * sourceText = textInfo.text;
				
				textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
				
				textInfo.text = [sourceText substringToIndex: lastRange.location];
				textInfo.width = [self sizeFrom: textInfo].width;
				textInfo.area.length = lastRange.location;
				
				NSUInteger insertedTextPosition = lastRange.location + lastRange.length;
				insertedTextInfo.text = [sourceText substringFromIndex: insertedTextPosition];
				insertedTextInfo.area.position = insertedTextInfo.area.position + insertedTextPosition;
				insertedTextInfo.area.length = insertedTextInfo.area.length - insertedTextPosition;
                    insertedTextInfo.x = textInfo.x + textInfo.width + 
                    [self sizeFrom: textInfo text: [sourceText  substringWithRange: lastRange]].width -
                    adjustmentPosition;
				insertedTextInfo.width = [self sizeFrom: insertedTextInfo].width;
				
				if (insertedTextInfo.text.length > 0) {
					[lines insertObject: insertedTextInfo atIndex: index + 1];
				}
                
				adjustmentPosition = -insertedTextInfo.x;
				
				adjustmentLevel++;
			} else {
				if (textInfo.x > labelWidth / 2.0f) {
					adjustmentLevel++;
					adjustmentPosition -= textInfo.x;
					textInfo.x = 0.0f;
				}
				if (_isLineWordwrap && textInfo.x + textInfo.width > labelWidth) {
					
					BxHighlightedTextInfo * insertedTextInfo = [[textInfo copy] autorelease];
					NSString * sourceText = textInfo.text;
                    
					CGFloat mod = labelWidth - textInfo.x;
					int lastPosition = MIN((int) truncf(mod / spaceSize.width), (int)sourceText.length);
					BxHighlightedTextInfo * tempTextInfo = [[textInfo copy] autorelease];
					tempTextInfo.text = [sourceText substringToIndex: lastPosition];
					tempTextInfo.width = [self sizeFrom: tempTextInfo].width;
					if (tempTextInfo.x + tempTextInfo.width > labelWidth) {
						while (lastPosition > 0 && tempTextInfo.x + tempTextInfo.width > labelWidth) {
							tempTextInfo.text = [sourceText substringToIndex: lastPosition];
							tempTextInfo.width = [self sizeFrom: tempTextInfo].width;
							lastPosition--;
						}
					}
                    
                    textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
                    textInfo.text = [sourceText substringToIndex: lastPosition];
                    textInfo.width = [self sizeFrom: textInfo].width;
                    textInfo.area.length = lastRange.location;
                    
                    insertedTextInfo.text = [sourceText substringFromIndex: lastPosition];
                    insertedTextInfo.area.position = insertedTextInfo.area.position + lastPosition;
                    insertedTextInfo.area.length = insertedTextInfo.area.length - lastPosition;
                    insertedTextInfo.x = textInfo.x + textInfo.width - adjustmentPosition;
                    insertedTextInfo.width = [self sizeFrom: insertedTextInfo].width;
                    [lines insertObject: insertedTextInfo atIndex: index + 1];
                    
                    adjustmentPosition = -insertedTextInfo.x;
                    adjustmentLevel++;
				} else {
					textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
				}
                
				
			}
		} else {
			textInfo.levelIndex = textInfo.levelIndex + adjustmentLevel;
		}
        
        
		index++;
	}
    
    // обновление позиций
    if (_textAlignment == NSTextAlignmentLeft) {
        // все расчитано уже
    } else if (_textAlignment == NSTextAlignmentRight) {
        BxHighlightedTextInfo * lastInfo = [lines objectAtIndex: lines.count - 1];
        int lastLevel = lastInfo.levelIndex;
        CGFloat position = _width - lastInfo.x - lastInfo.width;
        for (BxHighlightedTextInfo * textInfo in [lines reverseObjectEnumerator]) {
            if (textInfo.levelIndex < lastLevel) {
                lastLevel = textInfo.levelIndex;
                position = _width - textInfo.x - textInfo.width;
            }
            textInfo.x = textInfo.x + position;
        }
    } else if (_textAlignment == NSTextAlignmentCenter) {
        BxHighlightedTextInfo * lastInfo = [lines objectAtIndex: lines.count - 1];
        int lastLevel = lastInfo.levelIndex;
        CGFloat position = truncf((_width - lastInfo.x - lastInfo.width) / 2.0f);
        for (BxHighlightedTextInfo * textInfo in [lines reverseObjectEnumerator]) {
            if (textInfo.levelIndex < lastLevel) {
                lastLevel = textInfo.levelIndex;
                position = truncf((_width - textInfo.x - textInfo.width) / 2.0f);
            }
            textInfo.x = textInfo.x + position;
        }
    } else {
        [NSException raise: @"NotSupportException" format: @"Данный textAlignment не поддерживается в HighlightLabel"];
    }
}

- (NSArray*) preparedTextInfoWithWidth: (CGFloat) labelWidth
{
	NSMutableArray * lines = (NSMutableArray *)[self preparedTextInfo];
    [self toLineSeparateTextInfoWithWidth: labelWidth lines: lines];
	return lines;
}

- (NSArray*) getLineSeparateTextInfoWithWidth: (CGFloat) labelWidth
{
	NSMutableArray * lines = [NSMutableArray array];
    
    BxHighlightedTextInfo * infoText = [[BxHighlightedTextInfo alloc] initWithText: _text];
    infoText.levelIndex = 0;
    BxHighlightedArea * simpleTextArea = [[[BxHighlightedArea alloc] initWithPosition: 0 length: _text.length] autorelease];
    infoText.area = simpleTextArea;
    [lines addObject: infoText];
    [infoText release];
    
    [self insertParagraphsTo: lines];
	[self detectRealetivePositons: lines];
    [self toLineSeparateTextInfoWithWidth: labelWidth lines: lines];
	return lines;
}

- (NSArray*) getHighlightRectsWith: (HighlightType) type
{
    
    CGRect mainBounds = CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height);
	
	CGSize spaceSize = [@" " sizeWithFont: self.font];
	[self checkHighlightedLines];
	
    NSMutableArray * result = [NSMutableArray arrayWithCapacity: _highlightedLines.count];
    
	for (int index = 0; index < _highlightedLines.count; index++) {
		BxHighlightedTextInfo * info = [_highlightedLines objectAtIndex: index];
		CGRect currentBounds = CGRectMake(info.x, info.levelIndex * spaceSize.height, info.width, spaceSize.height);
		CGRect rect = CGRectIntersection(mainBounds, currentBounds);
		if ([self isValidRect: rect]) {
            HighlightType currentType = info.area.type;
			if ((type | currentType) == currentType) {
                BxHighlightedRect * currentRect = [[BxHighlightedRect alloc] init];
                currentRect.rect = rect;
                [result addObject: currentRect];
                [currentRect release];
			}
		} else {
			if (info.width > 1.0f) {
				break;
			}
		}
        
	}
    return result;
}

- (NSArray*) getHighlightRects
{
    return [self getHighlightRectsWith: HighlightTypeMarked];
}

- (CGRect) rectFromArea: (BxHighlightedArea*) area
{
    CGSize spaceSize = [@" " sizeWithFont: self.font];
	[self checkHighlightedLines];
    
    BOOL isFirstFound = NO;
    
    CGFloat x0 = 0.0f, y0 = 0.0f, x = 0.0f, y = 0.0f;
    
    for (int index = 0; index < _highlightedLines.count; index++) {
		BxHighlightedTextInfo * info = _highlightedLines[index];
        
        if (isFirstFound) {
            if ([info.area intersectionWith: area]) {
                x = info.x + info.width;
                y = (info.levelIndex + 1) * spaceSize.height;
            } else {
                break;
            }
        } else {
            if ([info.area intersectionWith: area]) {
                x0 = info.x;
                y0 = info.levelIndex * spaceSize.height;
                x = info.x + info.width;
                y = (info.levelIndex + 1) * spaceSize.height;
                isFirstFound = YES;
            }
        }
    }
    CGFloat resultHeight = y - y0;
    CGFloat resultWidth = x - x0;
    if (resultHeight > 1.5f * spaceSize.height) {
        x0 = 0.0f;
        resultWidth = self.frame.size.width;
    }
    return CGRectMake(x0, y0, resultWidth, resultHeight);
}

- (void)showTextFromInfo:(BxHighlightedTextInfo *)info rect:(CGRect)rect context:(CGContextRef)context
{
    BOOL isSampleText;
    isSampleText = YES;
    HighlightType type = info.area.type;
    BOOL isHighlightArea = (type | HighlightTypeColor) == type && _highlightedColor;
    if ((type | HighlightTypeMarked) == type && _markColor) {
        UIColor * currentMarkColor = _markColor;
        if (info.area.isAreaInFocus) {
            currentMarkColor = _markColorForAreaInFocus;
        }
        CGContextSetFillColorWithColor(context, [currentMarkColor CGColor]);
        CGContextBeginPath(context);
        CGContextAddRect(context, rect);
        CGContextClosePath(context);
        CGContextFillPath(context);
        if (_markTextColor && (!isHighlightArea)) {
            CGContextSetFillColorWithColor(context, [_markTextColor CGColor]);
            [info.text drawInRect: rect withFont: _font lineBreakMode: lineBreakMode];
            isSampleText = NO;
        }
    }
    if (isHighlightArea) {
        CGContextSetFillColorWithColor(context, [_highlightedColor CGColor]);
        [info.text drawInRect: rect withFont: _highlightedFont lineBreakMode: lineBreakMode];
        isSampleText = NO;
    }
    if (isSampleText) {
        
        UIColor * color = _textColor;
        if (_selected && _selectedTextColor && !((type | HighlightTypeMarked) == type)) {
            color = _selectedTextColor;
        }
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        [info.text drawInRect: rect withFont: _font lineBreakMode: lineBreakMode];
    }
}

- (void) showMarks: (CGContextRef) context
{
	if (context) {
		CGContextSaveGState(context);
	}
    
    [self checkHighlightedLines];
    
	CGRect mainBounds = CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height);
	CGSize spaceSize = [@" " sizeWithFont: self.font];
    
	for (int index = 0; index < _highlightedLines.count; index++) {
		BxHighlightedTextInfo * info = [_highlightedLines objectAtIndex: index];
		CGRect currentBounds = CGRectMake(info.x, info.levelIndex * spaceSize.height, info.width, spaceSize.height);
		CGRect rect = CGRectIntersection(mainBounds, currentBounds);
		if (context && [self isValidRect: rect size: spaceSize]) {
			if (index < _highlightedLines.count - 1) {
				BxHighlightedTextInfo * nextInfo = _highlightedLines[index + 1];
				if (nextInfo.width > 1.0f) {
					CGRect nextBounds = CGRectMake(nextInfo.x, nextInfo.levelIndex * spaceSize.height, nextInfo.width, spaceSize.height);
					CGRect nextRect = CGRectIntersection(mainBounds, nextBounds);
					if (![self isValidRect: nextRect size: spaceSize]) {
						info.text = [info.text stringByAppendingFormat: @"%@...", nextInfo.text, nil];
					}
				}
			}
            [self showTextFromInfo:info rect:rect context:context];
		} else {
			if (info.width > 1.0f) {
				break;
			}
		}

	}
	
	if (context) {
		CGContextRestoreGState(context);
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize spaceSize = [@" " sizeWithFont: self.font];
    CGPoint point = [[touches anyObject] locationInView: self];
    [self checkHighlightedLines];
    BOOL isExclusive = NO;
    CGFloat offset = 8.0f;
    for (BxHighlightedTextInfo * info in _highlightedLines) {
        CGRect rect = CGRectMake(info.x - offset, spaceSize.height * info.levelIndex - offset + 2.0f, info.width + 2 * offset, spaceSize.height + offset * 2);
        if (CGRectContainsPoint(rect, point)) {
            isExclusive = [info.area onExclusiveClick: self];
            if (isExclusive) {
                break;
            }
        }
    }
    if (!isExclusive) {
        [super touchesBegan: touches withEvent: event];
    }
}

- (BOOL) charIsRang: (unichar) symbol
{
    return [[NSCharacterSet punctuationCharacterSet] characterIsMember: symbol] ||
    [[NSCharacterSet whitespaceCharacterSet] characterIsMember: symbol];
}

- (CGPoint) getStartWordPointFromPoint: (CGPoint) point indexPosition: (NSUInteger*) indexPosition isWord: (BOOL) isWord
{
    if (point.x < 0.0f ) {
        point.x = 0.0f;
    }
    if (point.y < 0.0f ) {
        point.y = 0.0f;
    }
    CGRect mainBounds = CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height);
	CGSize spaceSize = [@" " sizeWithFont: self.font];
    
    NSArray* lines = [self getLineSeparateTextInfoWithWidth: self.frame.size.width];
    int currentPosition = 0;
    for (int index = 0; index < lines.count; index++) {
		BxHighlightedTextInfo * info = [lines objectAtIndex: index];
		CGRect currentBounds = CGRectMake(info.x, info.levelIndex * spaceSize.height, info.width, spaceSize.height);
		CGRect rect = CGRectIntersection(mainBounds, currentBounds);
		if (  point.y > rect.origin.y - 1.1f && point.y < rect.origin.y + rect.size.height + 1.1f) 
        {
            if (CGRectContainsPoint(rect, point)) {
                CGFloat shift = point.x - rect.origin.x;
                CGFloat lastX = 0.0f;
                int position = 0;
                if (shift > lastX) {
                    for (int symbolIndex = 0; symbolIndex < info.text.length; symbolIndex++) {
                        if (isWord && (![self charIsRang: [info.text characterAtIndex: symbolIndex]])) {
                            continue;
                        }
                        CGFloat currentX = [self sizeFrom: info text: [info.text substringToIndex: symbolIndex]].width;
                        if (shift < currentX) {
                            break;
                        }
                        lastX = currentX;
                        position = symbolIndex;
                        if (isWord){
                            lastX += spaceSize.width;
                            position++;
                        }
                    }
                }
                if (indexPosition) {
                    *indexPosition = position + currentPosition;
                }
                return CGPointMake(rect.origin.x + lastX, rect.origin.y);
            }
            if (indexPosition) {
                *indexPosition = currentPosition;
            }
            return CGPointMake(rect.origin.x, rect.origin.y);
        }
        currentPosition += info.text.length + 1;
    }
    *indexPosition = -1;
    return CGPointZero;
}

- (CGPoint) getStopWordPointFromPoint: (CGPoint) point indexPosition: (NSUInteger*) indexPosition  isWord: (BOOL) isWord
{
    if (point.x < 0.0f ) {
        point.x = 0.0f;
    }
    if (point.y < 0.0f ) {
        point.y = 0.0f;
    }
    CGRect mainBounds = CGRectMake(0.0f, 0.0f, self.frame.size.width , self.frame.size.height);
	CGSize spaceSize = [@" " sizeWithFont: self.font];
    
    NSArray* lines = [self getLineSeparateTextInfoWithWidth: self.frame.size.width];
    NSUInteger currentPosition = 0;
    for (int index = 0; index < lines.count; index++) {
		BxHighlightedTextInfo * info = [lines objectAtIndex: index];
		CGRect currentBounds = CGRectMake(info.x, info.levelIndex * spaceSize.height, info.width, spaceSize.height);
		CGRect rect = CGRectIntersection(mainBounds, currentBounds);
		if (  point.y > rect.origin.y - 1.1f && point.y < rect.origin.y + rect.size.height + 1.1f) 
        {
            if (CGRectContainsPoint(rect, point)) {
                CGFloat shift = point.x - rect.origin.x;
                CGFloat lastX = 0.0f;
                NSUInteger position = 0;
                if (shift > lastX) {
                    lastX = rect.size.width;
                    position = info.text.length;
                    for (int symbolIndex = 0; symbolIndex < info.text.length; symbolIndex++) {
                        if (isWord && (![self charIsRang: [info.text characterAtIndex: symbolIndex]])) {
                            continue;
                        }
                        CGFloat currentX = [self sizeFrom: info text: [info.text substringToIndex: symbolIndex]].width;
                        if (shift < currentX) {
                            lastX = currentX;
                            position = symbolIndex;
                            /*if (isWord){
                                lastX -= spaceSize.width;
                                position--;
                            }*/
                            break;
                        }
                    }
                }
                if (indexPosition) {
                    *indexPosition = position + currentPosition;
                }
                return CGPointMake(rect.origin.x + lastX, rect.origin.y + rect.size.height);
            }
            if (indexPosition) {
                *indexPosition = currentPosition + info.text.length;
            }
            return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        }
        if (index == lines.count - 1) {
            if (indexPosition) {
                *indexPosition = currentPosition + info.text.length;
            }
            return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        }
        currentPosition += info.text.length + 1;
    }
    return CGPointMake(self.frame.size.width, self.frame.size.height);
}

- (void)setHighlighted: (BOOL)highlighted animated: (BOOL)animated
{
    self.selected = highlighted;
    [self setNeedsDisplay];
}

- (BOOL) isHighlighted
{
    return self.selected;
}

- (void)setHighlighted: (BOOL)highlighted
{
    self.selected = highlighted;
    [self setNeedsDisplay];
}

- (void) dealloc
{
	self.areas = nil;
	self.font = nil;
	self.text = nil;
	self.textColor = nil;
	self.markColor = nil;
    self.markTextColor = nil;
	self.highlightedColor = nil;
	self.highlightedFont = nil;
    self.selectedTextColor = nil;
    self.markColorForAreaInFocus = nil;
	[super dealloc];
}

@end

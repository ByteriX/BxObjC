/**
 *	@file BxHighlightedLabel.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BxHighlightedArea.h"

@interface BxHighlightedLabel : UIView {
@protected
	CGFloat _height;
	BOOL _isHighlightedTextFound;
	BOOL _isLineWordwrap;
}

@property (nonatomic) CGFloat width;
@property (nonatomic, retain) NSArray * areas;
@property (nonatomic, retain) UIFont * font;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UIColor * textColor;
@property (nonatomic, retain) UIColor * markColor;
@property (nonatomic, retain) UIColor * markTextColor;
@property (nonatomic, retain) UIColor * highlightedColor;
@property (nonatomic, retain) UIFont * highlightedFont;
@property (nonatomic, retain) NSArray * highlightedLines;
@property (nonatomic, retain) UIColor * markColorForAreaInFocus;

@property (nonatomic, retain) UIColor * selectedTextColor;
@property (nonatomic, assign) BOOL selected;
//! аналогичен selected с selectedTextColor
@property(nonatomic,getter=isHighlighted, setter = setHighlighted:) BOOL highlighted;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic, readonly, getter = getHighlightRects) NSArray * highlightRects;

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
       highlightText: (NSString*) highlightText 
		   markColor: (UIColor*) markColor;

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text 
			   areas: (NSArray*) areas 
		   markColor: (UIColor*) markColor;

/*- (id) initWithWidth: (CGFloat) labelWidth
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
       highlightText: (NSString*) highlightText 
		   markColor: (UIColor*) markColor;*/

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text
       highlightText: (NSString*) highlightText 
		   markColor: (UIColor*) markColor
       textAlignment: (NSTextAlignment) textAlignment;

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font;

- (void) showMarks: (CGContextRef) context;

- (NSArray*) preparedTextInfoWithWidth: (CGFloat) labelWidth;

- (NSArray*) getHighlightRectsWith: (HighlightType) type;

- (void) setText: (NSString*) text1 areas: (NSArray*) areas1;

- (void) setHighlightText: (NSString*) value;

- (void) update;

- (CGPoint) getStartWordPointFromPoint: (CGPoint) point indexPosition: (NSUInteger*) indexPosition isWord: (BOOL) isWord;

- (CGPoint) getStopWordPointFromPoint: (CGPoint) point indexPosition: (NSUInteger*) indexPosition  isWord: (BOOL) isWord;

/**
 *  Возвращает прямоугольную область канвы фразы, пересекаемую area
 *  Если в область входит больше одной строки то по ширине компонента результат.
 */
- (CGRect) rectFromArea: (BxHighlightedArea*) area;

@end

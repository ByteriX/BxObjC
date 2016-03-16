/**
 *	@file BxHighlightedTagLabel.h
 *	@namespace iBXVcl
 *
 *	@details Отображение текста с выделенным текстом внутри тега.
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxHighlightedLabel.h"

@interface BxHighlightedTagLabel : BxHighlightedLabel {
    
}

- (id) initWithWidth: (CGFloat) labelWidth 
			position: (CGPoint) position 
				font: (UIFont*) font
				text: (NSString*) text 
			startTag: (NSString*) startTag 
			 stopTag: (NSString*) stopTag;

- (id) initWithWidth: (CGFloat) labelWidth
			position: (CGPoint) position
				font: (UIFont*) font
            markfont: (UIFont*) markfont
				text: (NSString*) text
			startTag: (NSString*) startTag
			 stopTag: (NSString*) stopTag;

@end

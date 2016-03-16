/**
 *	@file BxHighlightedArea.h
 *	@namespace iBXVcl
 *
 *	@details Область выделения текста
 *	@date 18.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! тип выделения текста
typedef enum {
    HighlightTypeNone = 0,
    HighlightTypeColor = 1,
    HighlightTypeMarked = 2,
    HighlightTypeReserved = 4
} HighlightType;


@interface BxHighlightedArea : NSObject <NSCopying> {
}
@property (nonatomic) NSUInteger position;
@property (nonatomic) NSUInteger length;
@property (nonatomic) HighlightType type;
@property (nonatomic) BOOL isAreaInFocus;

+ (NSArray *) areasFromText: (NSString*) text
              highlightText: (NSString*) highlightText 
              highlightType: (HighlightType) highlightType;

+ (NSArray *) margedAareasFromFirst: (NSArray*) firstArray second: (NSArray*) secondArray;

- (id) initWithPosition: (NSUInteger) position
				 length: (NSUInteger) length;

- (BxHighlightedArea*) intersectionWith: (BxHighlightedArea*) area;

- (NSRange) range;

- (BOOL) onExclusiveClick: (id) sender;

- (NSComparisonResult)comparePosition:(BxHighlightedArea *)otherObject;

@end

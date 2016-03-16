/**
 *	@file BxHighlightedTextInfo.h
 *	@namespace iBXVcl
 *
 *	@details Информация об подцвечиваемой части текста
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

@interface BxHighlightedTextInfo : NSObject <NSCopying> {
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) BxHighlightedArea * area;
@property (nonatomic) int levelIndex;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat width;

- (id) initWithText: (NSString*) text;

@end

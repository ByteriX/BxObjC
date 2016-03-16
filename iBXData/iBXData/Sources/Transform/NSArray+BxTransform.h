/**
 *	@file NSArray+BxTransformDate.h
 *	@namespace iBXData
 *
 *	@details NSArray категория конвертации данных
 *	@date 25.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! NSArray категория конвертации данных
@interface NSArray (BxTransform)

- (NSString*) notNullString;
- (float) notNullFloat;
- (double) notNullDouble;
- (int) notNullInt;
- (BOOL) notNullBool;
- (NSDictionary*) notNullDictionary;
- (NSArray*) notNullArray;

- (BOOL) isNotNil;

@end

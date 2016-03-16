/**
 *	@file NSString+BxTransform.h
 *	@namespace iBXData
 *
 *	@details NSString категория конвертации данных
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! NSString категория конвертации данных
@interface NSString (BxTransform)

- (NSString*) notNullString;
- (float) notNullFloat;
- (double) notNullDouble;
- (int) notNullInt;
- (BOOL) notNullBool;
- (NSArray*) notNullArray;
- (NSDictionary*) notNullDictionary;

- (BOOL) isNotNil;

@end

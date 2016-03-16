/**
 *	@file NSNumber+BxTransform.h
 *	@namespace iBXData
 *
 *	@details NSNumber категория конвертации данных
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! NSNumber категория конвертации данных
@interface NSNumber (BxTransform)

- (NSString*) notNullString;
- (float) notNullFloat;
- (double) notNullDouble;
- (int) notNullInt;
- (BOOL) notNullBool;
- (NSArray*) notNullArray;
- (NSDictionary*) notNullDictionary;

- (BOOL) isNotNil;

@end

/**
 *	@file NSDictionary+BxTransformDate.h
 *	@namespace iBXData
 *
 *	@details NSDictionary категория конвертации данных
 *	@date 25.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! NSDictionary категория конвертации данных
@interface NSDictionary (BxTransform)

- (NSString*) notNullString;
- (float) notNullFloat;
- (double) notNullDouble;
- (int) notNullInt;
- (BOOL) notNullBool;
- (NSArray*) notNullArray;
- (NSDictionary*) notNullDictionary;

- (BOOL) isNotNil;

@end

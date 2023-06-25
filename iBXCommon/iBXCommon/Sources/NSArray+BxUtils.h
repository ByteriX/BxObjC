/**
 *	@file NSArray+BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Категория для NSArray
 *	@date 09.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

typedef id (^BxArrayTransformFromDictionaryHandler) (NSDictionary * data);

@interface NSArray (BxUtils)

//! Получение строки в формате x-www-forms
- (NSString*) xFormsString;

- (NSArray*) arrayByTransformHandler: (BxArrayTransformFromDictionaryHandler) transformHandler;

@end

@interface NSMutableArray (BxUtils)

- (void) transformHandler: (BxArrayTransformFromDictionaryHandler) transformHandler;

@end

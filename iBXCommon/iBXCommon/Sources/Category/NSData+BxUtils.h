/**
 *	@file NSData+BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Категория для NSData
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

@interface NSData (BxUtils)

+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

//! data from resource fileName, if not found return nil
+ (NSData *) dataWithResourceFileName: (NSString*) fileName;

@end

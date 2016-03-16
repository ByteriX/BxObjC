/**
 *	@file BxException.h
 *	@namespace iBXCommon
 *
 *	@details Исключения
 *	@date 29.08.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

@interface BxException : NSException {
}

//! содержание ошибки, полученое из источника
@property (nonatomic, retain) NSError *error;

//! ручная инициализация
- (id) initWith: (NSError *) mainError;

//! получить самоудаляемый экземпляр
+ (id) exceptionWith: (NSError *) mainError;

@end

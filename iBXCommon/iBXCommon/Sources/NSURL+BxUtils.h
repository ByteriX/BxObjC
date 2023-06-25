/**
 *	@file NSURL+BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Категория для NSURL
 *	@date 12.01.2015
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

@interface NSURL (BxUtils)

//! Методы работы с восстанавливаемыми данными, исключений не вызывают
- (BOOL) hasSkipBackupAttribute;
- (BOOL) addSkipBackupAttribute;
- (BOOL) removeSkipBackupAttribute;

@end
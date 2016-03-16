/**
 *	@file NSIndexPath+BxTreeListScrollView.h
 *	@namespace iBXVcl
 *
 *	@details NSIndexPath категория для древовидного список
 *	@date 23.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>

//! NSIndexPath категория для древовидного список
@interface NSIndexPath (BxTreeListScrollView)

- (NSIndexPath*) jointIndexPath: (NSIndexPath*) indexPath;

- (BOOL) isEqualToIndexPath: (NSIndexPath*) indexPath;

- (NSComparisonResult)compareWithoutLevel:(NSIndexPath *)otherObject;

@end
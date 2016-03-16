/**
 *	@file Collection+Copy.h
 *	@namespace iBXData
 *
 *	@details Копирование коллекций
 *	@date 01.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/NSObject.h>
#import <Foundation/NSEnumerator.h>


@interface NSArray (Copy)

- (NSMutableArray*) getInstanceCopy;

@end

@interface NSDictionary (Copy)

- (NSMutableDictionary*) getInstanceCopy;

@end

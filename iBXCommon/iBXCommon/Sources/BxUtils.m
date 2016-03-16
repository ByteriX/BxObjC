/**
 *	@file BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Утилиты
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxUtils.h"
#include "stdlib.h"

#define RANDOM_MAX 0x100000000

@implementation BxUtils

+ (NSString *) getWordFromCount: (int) count with3Words: (NSArray*) words
{
	int div = count % 100;
	if (div > 10 && div < 20){
		return [words objectAtIndex: 2];
	}
	div = count % 10;
	if (div == 1){
		return [words objectAtIndex: 0];
	} else if (div == 2 | div == 3 | div == 4) {
		return [words objectAtIndex: 1];
	}
	return [words objectAtIndex: 2];
}

+ (double) getRandom
{
    return (double)arc4random() / (double)RANDOM_MAX;
}

@end

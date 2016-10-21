/**
 *	@file BxGoogleGeocoder.h
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного, адаптированный под решение Google
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxGeocoder.h"

@interface BxGoogleGeocoder : BxGeocoder


// protected for override in Swift
- (NSString*) geocodingUrlFrom: (NSString*) address;

@end

/**
 *	@file BxArcgisGeocoder.h
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного, адаптированный под решение ArcGIS
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxGeocoder.h"

@interface BxArcgisGeocoder : BxGeocoder

- (id) initWithUrl: (NSString*) url;

@end

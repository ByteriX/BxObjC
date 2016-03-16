/**
 *	@file BxGeometry.h
 *	@namespace iBXCommon
 *
 *	@details Геометрические функции
 *	@date 05.12.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#ifndef iBXCommon_BxGeometry_h
#define iBXCommon_BxGeometry_h

#include <CoreGraphics/CoreGraphics.h>

CG_INLINE CGPoint CGRectCenterPoint(CGRect rect);

CG_INLINE CGPoint CGRectCenterPoint(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f);
}

#endif

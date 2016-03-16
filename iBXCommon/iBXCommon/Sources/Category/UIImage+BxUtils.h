/**
 *	@file UIImage+BxUtils.h
 *	@namespace iBXCommon
 *
 *	@details Категория для UIImage
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>

/**
 *	Определение производит перевод из 24 битного значения цвета в объект UIColor
 */
#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0f \
    blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0]

#define UIColorFromRGBA(rgbValue,aValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0f \
    blue:((float)(rgbValue & 0xFF))/255.0f alpha:aValue]

@interface UIImage (BxUtils)

//! Загрузка изображения по урлу. Потоковая (с сервера) и файловая (с устройства) загрузка определяется автоматически по урлу
+ (UIImage*) imageWithContentsOfStringURL: (NSString*) url;
+ (UIImage*) imageWithContentsOfURL: (NSURL*) currentUrl;

//! получение оизображения из видеобуфера
+ (UIImage*) imageFromBuffer: (CVImageBufferRef) imageBuffer;

//! получение скриншета с полотна представления, без учета дочерних элементов
+ (UIImage *) imageWithUIView:(UIView *)view;
//! получение скриншета с полотна представления, с учетом дочерних элементов
+ (UIImage *) imageWithAllUIView:(UIView *)view;
//! получение скриншетов [не используется]
+ (UIImage *) imageFromView:(UIView *)view;


//! делает растягиваемым изображение не зависимо от SDK
- (UIImage *) stretchableImageWithLeftAndRightCap: (NSInteger) leftAndRightCap
                                  topAndBottomCap: (NSInteger) topAndBottomCap;

//! растягивает изображения, полностью вписывая его в заданную область
- (UIImage*)imageWithSize:(CGSize)newSize;
//! вписывает изображение до максимального размера, если изображение меньше, его не трогают
- (UIImage*)imageWithMaxSize:(CGSize) inscribedSize;
//! вписывает изображение в прямоугольник, сохраняя пропорции с обрезанием ненужных краев
- (UIImage *)imageWithFitSize:(CGSize)targetSize;

//! Blur эффекты различных вендеров по эффективности
- (UIImage *) blurOfStackWithRadius: (CGFloat) radius;

- (UIImage *)blurWithRadius: (CGFloat) radius;

@end

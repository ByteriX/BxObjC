/**
 *	@file BxDownloadOldFileImageCasher.h
 *	@namespace iBXData
 *
 *	@details Кешированная закачка для изображений из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadOldFileCasher.h"
#import "BxImageDownloadFormat.h"

//! Кешированная закачка для изображений из Веб-сервиса
@interface BxDownloadOldFileImageCasher : BxDownloadOldFileCasher
{
@protected
    NSMutableArray * _formats;
}

- (void) addFormat: (BxImageDownloadFormat*) format;
- (void) addImageFormat: (BxImageFormat) imageFormat size: (CGSize) size;

// formatIndex нумеруется начиная с 0. При 0 возвращается исходная картинка, а больше 0 берется из очереди картинок в соответствии с индексом добавленного формата
- (NSString *) getDownloadedPathFrom: (NSString*) url errorConnection: (BOOL) errorConnection progress: (id<BxDownloadProgress>) progress formatIndex: (int) formatIndex;
- (NSString*) getLocalDownloadedPathFrom: (NSString*) url formatIndex: (int) formatIndex;

@end

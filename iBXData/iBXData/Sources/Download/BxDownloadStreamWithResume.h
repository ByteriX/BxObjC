/**
 *	@file BxDownloadStreamWithResume.h
 *	@namespace iBXData
 *
 *	@details Загрузка ресурсов с дозакачкой из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <Foundation/Foundation.h>
#import "BxDownloadUtils.h"

typedef enum {
    BxDownloadStreamWithResumeFileExistTypeNone,
    BxDownloadStreamWithResumeFileExistTypeError,
    BxDownloadStreamWithResumeFileExistTypeResume
} BxDownloadStreamWithResumeFileExistType;

//! Загрузка ресурсов с дозакачкой из Веб-сервиса
@interface BxDownloadStreamWithResume : NSObject <BxDownloadStreamProtocol>
{
@protected
	//! Прирост уровня загрузке
	float _progressScale;
	//! Максимально возможный уровень загрузки
	float _maxProgress;
	//! Интерфейс индикации уровня загрузки
	id<BxDownloadProgress> _progress;
@protected
    //! This flag is needing for check double stoping, for example respond error status and finished session
    BOOL _isStopped;
    //!
	NSCondition * _condition; // property
    //!
    unsigned long long _startPosition;
    //!
    int _dataPacketBytesCount;
}

//! закачиваемые данные, которые будут сохранены в файл.
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSOutputStream * fileStream;
//! соединение для закачки данных
@property (nonatomic, retain) NSURLConnection * urlDownload;
//! Ошибка возникшая в процессе закачки
@property (nonatomic, retain) NSError * error;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSMutableURLRequest * request;

+ (void) loadFromUrl: (NSString*) url
         maxProgress: (float) maxProgress
            delegate: (id<BxDownloadProgress>) delegate
            filePath: (NSString*) filePath;

- (void) cancel;

@end

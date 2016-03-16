/**
 *	@file BxServiceDataSet.h
 *	@namespace iBXData
 *
 *	@details Хранилище данных, полученных через Веб-сервис
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataSet.h"
#import "BxDownloadProgress.h"

@class BxDownloadStream;
@class BxAbstractDataParser;

//! Хранилище данных, полученных через Веб-сервис
@interface BxServiceDataSet : BxAbstractDataSet<BxDownloadProgress> {
@protected
	//! парсер из текста в данные
	BxAbstractDataParser * _parser;
    //! для управления потоком данных
    BxDownloadStream * _downloadStream;
}

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * post;

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser;

//! @protected
- (void) updateRequest: (NSMutableURLRequest*) request;

//! эти методы помогают внести корректировки при необходимости, перед самой отсылкой
- (NSString*) getRequestUrl;
- (NSString*) getRequestPost;

- (NSDictionary*) checkResult: (NSDictionary*) dataResult;

@end
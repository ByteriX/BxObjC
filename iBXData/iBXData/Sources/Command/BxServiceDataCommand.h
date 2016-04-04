/**
 *	@file BxServiceDataCommand.h
 *	@namespace iBXData
 *
 *	@details Команда, выполняющая действие на серевере, через веб-сервис
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataCommand.h"
#import "BxDownloadStream.h"
#import "BxAbstractDataParser.h"

typedef enum
{
    BxServiceMethodGET,
    BxServiceMethodPOST,
    BxServiceMethodPUT,
    BxServiceMethodDELETE
} BxServiceMethod;

//! Команда, выполняющая действие на серевере, через веб-сервис
@interface BxServiceDataCommand : BxAbstractDataCommand{
@protected
	NSString * _caption;
    NSString * _requestBody;
    BxServiceMethod _method;
    BxDownloadStream * _stream;
}
@property (nonatomic, readonly, nonnull) NSString * url;
@property (nonatomic, readonly, nullable) NSDictionary * result;
@property (nonatomic, readonly, nullable) NSDictionary * rawResult;
@property (nonatomic, readonly, nullable) id data;
@property (nonatomic, retain, nonnull) BxAbstractDataParser * parser;

//! The file name of a resource with test data (the service data with url  will ignored)
@property (nonatomic, retain, nullable) NSString * mockResourceFileName;
//! Time for imetated mockup loading (in sec) Default is 0. if mockResourceFileName = nil is ignored
@property (nonatomic) NSTimeInterval mockDelay;

- (nonnull instancetype) initWithUrl: (nonnull NSString*) url
                                data: (nullable id) data
                              method: (BxServiceMethod) method
                             caption: (nullable NSString*) caption;

//! Если объект data1 пустой, то вызовется GET, иначе POST
- (nonnull instancetype) initWithUrl: (nonnull NSString*) url
                                data: (nullable id) data
                             caption: (nullable NSString*) caption;

//! @private
- (void) updateRequest: (nonnull NSMutableURLRequest*) request;
//! @private
- (nullable NSString *) getRequestBody;

- (nullable NSDictionary*) checkResult: (nullable NSDictionary*) dataResult;



@end
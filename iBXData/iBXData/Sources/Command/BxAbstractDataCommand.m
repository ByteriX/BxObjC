/**
 *	@file BxAbstractDataCommand.m
 *	@namespace iBXData
 *
 *	@details Абстрактная команда, выполняющая действие
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataCommand.h"
#import "BxException.h"

NSString *const FNDataCommandName = @"name";

@implementation BxAbstractDataCommand

- (id) init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString*) getCaption
{
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataCommand method getCaption is not implement"];
	return nil;
}

//! это поле должно быть статичным по сути!
- (NSString*) getName
{
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataCommand method getName is not implement"];
	return nil;
}

- (void) execute
{
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataCommand method execute is not implement"];
}

- (NSMutableDictionary*) saveToData
{
	//! TODO
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataCommand method saveToData is not implement"];
	return nil;
}

- (void) loadFromData: (NSMutableDictionary*) data
{
	//! TODO
	[NSException raise: @"NotImplementException"
				format: @"AbstractDataCommand method loadFromData is not implement"];
}

+ (void) errorWithCode: (NSInteger) code message: (NSString*) message
{
    if (!message){
        message = @"";
    }
    @throw [BxException exceptionWith: [NSError errorWithDomain: NSStringFromClass(self.class)
                                                           code: code
                                                       userInfo: @{NSLocalizedDescriptionKey : message}]];
}

- (void) updateFrom: (BxAbstractDataCommand*) command
{}

- (void)cancel
{
    
}

- (void) executeWithSuccess: (BxDataCommandSuccessHandler) successHandler
               errorHandler: (BxDataCommandErrorHandler) errorHandler
              cancelHandler: (BxDataCommandCancelHandler) cancelHandler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            [self execute];
            if (_isCanceled) {
                if (cancelHandler) {
                    cancelHandler();
                }
            } else {
                if (successHandler) {
                    successHandler(self);
                }
            }
        }
        @catch (NSException *exception) {
            if (errorHandler) {
                NSError * error = nil;
                if ([exception isKindOfClass: BxException.class]){
                    error = ((BxException*)exception).error;
                }
                if (!error) {
                    NSDictionary * dictErrors = [NSDictionary dictionaryWithObject: exception.reason forKey: NSLocalizedDescriptionKey];
                    error = [[[NSError alloc] initWithDomain: exception.name
                                                        code: 0
                                                    userInfo: dictErrors] autorelease];
                }
                if (error) {
                    errorHandler(error);
                }
            }
        }
        @finally {
            //
        }
    });
}

@end

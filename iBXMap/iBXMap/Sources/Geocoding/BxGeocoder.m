/**
 *	@file BxGeocoder.m
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxGeocoder.h"

@implementation BxGeocoderData

- (void) completionWithResult: (NSArray*) result errorMessage: (NSString*) errorMessage
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.handler(result, errorMessage, self);
    });
}

- (void) completionWithResult: (NSArray*) result
{
    [self completionWithResult: result errorMessage: nil];
}

- (void) completionWithErrorMessage: (NSString*) errorMessage
{
    [self completionWithResult: nil errorMessage: errorMessage];
}

- (void) cancel
{
    self.handler = nil;
}

- (void) dealloc
{
    [_address release];
    self.handler = nil;
    [super dealloc];
}

@end

@implementation BxResultGeocoder

- (id) initWithAddress: (NSString*) address coordinate: (CLLocationCoordinate2D) coordinate
{
    self = [self init];
    if (self) {
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (void) dealloc
{
    [_address release];
    [super dealloc];
}

@end

@implementation BxGeocoder

- (id) init
{
    self = [super init];
    if (self) {
        allRequests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void) geocodingThreadWithData: (BxGeocoderData*) data
{
    [NSException raise: @"NotImplementException" format: @"Not implement the method geocodingThreadWithData:"];
}

- (BxGeocoderData *) startGeocodingWithAdress: (NSString*) address completionHandler: (BxGeocoderHandler) completionHandler
{
    __block BxGeocoderData * data = [[[BxGeocoderData alloc] init] autorelease];
    data.address = address;
    data.handler = completionHandler;
    [self startWithData: data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            [self geocodingThreadWithData: data];
        }
        @catch (NSException *exception) {
            [data completionWithErrorMessage: [exception reason]];
        }
        @finally {
            [self stopWithData: data];
        }
    });
    return data;
}

- (void) reverseGeocodingThreadWithData: (BxGeocoderData*) data
{
    [NSException raise: @"NotImplementException" format: @"Not implement the method reverseGeocodingThreadWithData:"];
}

- (BxGeocoderData *) startReverseGeocodingWithCoordinate: (CLLocationCoordinate2D) coordinate completionHandler: (BxGeocoderHandler) completionHandler
{
    __block BxGeocoderData * data = [[[BxGeocoderData alloc] init] autorelease];
    data.coordinate = coordinate;
    data.handler = completionHandler;
    [self startWithData: data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            [self reverseGeocodingThreadWithData: data];
        }
        @catch (NSException *exception) {
            [data completionWithErrorMessage: [exception reason]];
        }
        @finally {
            [self stopWithData: data];
        }
    });
    return data;
}

- (void) startWithData: (BxGeocoderData *) data
{
    @synchronized(allRequests){
        [allRequests addObject: data];
    }
}

- (void) stopWithData: (BxGeocoderData *) data
{
    @synchronized(allRequests){
        [allRequests removeObject: data];
    }
}

- (void) allCancel
{
    @synchronized(allRequests){
        for (BxGeocoderData * data in allRequests) {
            [data cancel];
        }
        [allRequests removeAllObjects];
    }
}

- (void) dealloc
{
    [self allCancel];
    [allRequests release];
    [super dealloc];
}

@end
/**
 *	@file BxGeocoder.h
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

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class BxGeocoderData;

typedef void(^BxGeocoderHandler)(NSArray * result, NSString * errorMesage, BxGeocoderData * data);

@interface BxGeocoderData : NSObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) BxGeocoderHandler handler;

- (void) completionWithResult: (NSArray*) result;
- (void) completionWithErrorMessage: (NSString*) errorMessage;

- (void) cancel;

@end

@interface BxResultGeocoder : NSObject
{
    
}
- (id) initWithAddress: (NSString*) address coordinate: (CLLocationCoordinate2D) coordinate;

@property (nonatomic, readonly) NSString * address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

@interface BxGeocoder : NSObject
{
@protected
    NSMutableSet * allRequests;
}

- (BxGeocoderData *) startGeocodingWithAdress: (NSString*) address completionHandler: (BxGeocoderHandler) completionHandler;
- (BxGeocoderData *) startReverseGeocodingWithCoordinate: (CLLocationCoordinate2D) coordinate completionHandler: (BxGeocoderHandler) completionHandler;

- (void) allCancel;

@end

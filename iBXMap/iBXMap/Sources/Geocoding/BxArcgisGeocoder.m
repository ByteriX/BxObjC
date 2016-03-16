/**
 *	@file BxArcgisGeocoder.m
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

#import "BxArcgisGeocoder.h"
#import "BxCommon.h"
#import "BxData.h"

@interface BxArcgisGeocoder (){
@protected
    BxJsonKitDataParser * _parser;
    NSString * _url;
}

@end

@implementation BxArcgisGeocoder

- (id) init
{
    self = [super init];
    if (self) {
        [NSException raise: @"NotSupportException" format: @"Please use initWithUrl: message from ArcGis geocoder"];
    }
    return self;
}

- (id) initWithUrl: (NSString*) url
{
    self = [super init];
    if (self) {
        _parser = [[BxJsonKitDataParser alloc] init];
        _url = [url copy];
    }
    return self;
}

- (void) geocodingThreadWithData: (BxGeocoderData*) data
{
    if (!_url) {
        [NSException raise: @"NotSettedURLException" format: @"Your ArcGis geocoder is not set url"];
    }
    NSString * url = [NSString stringWithFormat: @"%@/findAddressCandidates?SingleLine=%@&outFields=&outSR=&searchExtent&f=json", _url, [data.address getAddingPercentEscapes]];
    NSDictionary * serverData = [_parser loadFromUrl: url];
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary * item in [serverData objectForKey: @"candidates"]) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[[item objectForKey: @"location"] objectForKey: @"y"] doubleValue];
        coordinate.longitude = [[[item objectForKey: @"location"] objectForKey: @"x"] doubleValue];
        
        NSString * address = [item objectForKey: @"address"];
        
        BxResultGeocoder * resultItem = [[[BxResultGeocoder alloc] initWithAddress: address coordinate: coordinate] autorelease];
        [result addObject: resultItem];
        
    }
    [data completionWithResult: result];
}

- (BxResultGeocoder*) resultFromCoordinate: (CLLocationCoordinate2D) coordinate
{
    if (!_url) {
        [NSException raise: @"NotSettedURLException" format: @"Your ArcGis geocoder is not set url"];
    }
    NSString * url = [NSString stringWithFormat: @"%@/reverseGeocode?location={x:%@,y:%@}&distance=1000&outSR=&f=json", _url, [NSNumber numberWithDouble: coordinate.longitude], [NSNumber numberWithDouble: coordinate.latitude]];
    NSDictionary * serverData = [_parser loadFromUrl: [url getAddingPercentEscapes]];
    NSDictionary * addressData = [serverData objectForKey: @"address"];
    NSDictionary * locationData = [serverData objectForKey: @"location"];
    
    if (!locationData) {
        return nil;
    }
    
    NSString * StreetTypeInput = [addressData objectForKey: @"StreetTypeInput"];
    NSString * StreetNameInput = [addressData objectForKey: @"StreetNameInput"];
    NSString * AddrNumInput = [addressData objectForKey: @"AddrNumInput"];
    
    BxResultGeocoder *result = nil;
    BOOL correctAddress = ![StreetTypeInput isKindOfClass:[NSNull class]] &&
    ![StreetNameInput isKindOfClass:[NSNull class]] &&
    ![AddrNumInput isKindOfClass:[NSNull class]];
    if (correctAddress){
        NSString * address = correctAddress ? [NSString stringWithFormat: @"%@ %@, %@", StreetTypeInput, StreetNameInput, AddrNumInput] : nil;
        coordinate.latitude = [[locationData objectForKey: @"y"] doubleValue];
        coordinate.longitude = [[locationData objectForKey: @"x"] doubleValue];
        result = [[[BxResultGeocoder alloc] initWithAddress: address coordinate: coordinate] autorelease];
    }
    
    return result;
}

- (void) reverseGeocodingThreadWithData: (BxGeocoderData*) data
{
    BxResultGeocoder* result = [self resultFromCoordinate: data.coordinate];
    
    if (result) {
        [data completionWithResult: [NSArray arrayWithObject: result]];
    } else {
        [data completionWithResult: nil];
    }
}

- (void) dealloc
{
    [_parser release];
    [_url release];
    [super dealloc];
}

@end

/**
 *	@file BxGoogleGeocoder.m
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного, адаптированный под решение Google
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxGoogleGeocoder.h"
#import "BxData.h"
#import "BxCommon.h"

@interface BxGoogleGeocoder (){
@protected
    BxJsonKitDataParser * _parser;
}

@end

@implementation BxGoogleGeocoder

// https://maps.googleapis.com/maps/api/geocode/json?address=%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0+%D0%94%D1%83%D0%B1%D0%BD%D0%B8%D0%BD%D1%81%D0%BA%D0%B0%D1%8F+%D1%83%D0%BB.,+%D0%B4.+12,+%D1%81%D0%BE%D0%BE%D1%80.+1&sensor=false


- (id) init
{
    self = [super init];
    if (self) {
        _parser = [[BxJsonKitDataParser alloc] init];
    }
    return self;
}

- (NSString*) geocodingUrlFrom: (NSString*) address
{
    return [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [address getAddingPercentEscapes]];
}

- (void) geocodingThreadWithData: (BxGeocoderData*) data
{
    NSString * url = [self geocodingUrlFrom: data.address];
    NSDictionary * serverData = [_parser loadFromUrl: url];
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary * item in serverData[@"results"]) {
        [result addObject: [self googleDataFrom: item]];
    }
    [data completionWithResult: result];
}

- (BxResultGeocoder *) googleDataFrom: (NSDictionary*) data
{
    NSDictionary * coordsData = data[@"geometry"][@"location"];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [coordsData[@"lat"] doubleValue];
    coordinate.longitude = [coordsData[@"lng"] doubleValue];
    
    NSString * address = data[@"formatted_address"];
    
    return [[[BxResultGeocoder alloc] initWithAddress: address coordinate: coordinate] autorelease];
}

- (BxResultGeocoder*) resultFromCoordinate: (CLLocationCoordinate2D) coordinate
{
    NSString * url = [NSString stringWithFormat: @"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", [NSNumber numberWithDouble: coordinate.latitude], [NSNumber numberWithDouble: coordinate.longitude]];
    NSDictionary * serverData = [_parser loadFromUrl: [url getAddingPercentEscapes]];
    NSArray * locationData = serverData[@"results"];
    
    if (!locationData || locationData.count < 1) {
        return nil;
    }
    
    NSDictionary * data = locationData[0];
    
    return [self yandexDataFrom: data];
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
    [super dealloc];
}


@end

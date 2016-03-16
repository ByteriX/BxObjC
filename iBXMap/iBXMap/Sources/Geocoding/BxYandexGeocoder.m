/**
 *	@file BxYandexGeocoder.m
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного, адаптированный под решение Yandex
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxYandexGeocoder.h"
#import "BxCommon.h"
#import "BxData.h"

@interface BxYandexGeocoder (){
@protected
    BxJsonKitDataParser * _parser;
}

@end

@implementation BxYandexGeocoder

- (id) init
{
    self = [super init];
    if (self) {
        _parser = [[BxJsonKitDataParser alloc] init];
    }
    return self;
}

- (void) geocodingThreadWithData: (BxGeocoderData*) data
{
    NSString * url = [NSString stringWithFormat: @"http://geocode-maps.yandex.ru/1.x/?format=json&geocode=%@", [data.address getAddingPercentEscapes]];
    NSDictionary * serverData = [_parser loadFromUrl: url];
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary * item in serverData[@"response"][@"GeoObjectCollection"][@"featureMember"]) {
        NSDictionary * data = item[@"GeoObject"];
        [result addObject: [self yandexDataFrom: data]];
    }
    [data completionWithResult: result];
}

- (BxResultGeocoder *) yandexDataFrom: (NSDictionary*) data
{
    NSString * coords = data[@"Point"][@"pos"];
    NSArray * coordinates = [coords componentsSeparatedByString: @" "];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [coordinates[1] doubleValue];
    coordinate.longitude = [coordinates[0] doubleValue];
    
    //NSString * address = [data objectForKey: @"name"];
    NSString * address = data[@"metaDataProperty"][@"GeocoderMetaData"][@"text"];
    
    return [[[BxResultGeocoder alloc] initWithAddress: address coordinate: coordinate] autorelease];
}

- (BxResultGeocoder*) resultFromCoordinate: (CLLocationCoordinate2D) coordinate
{
    NSString * url = [NSString stringWithFormat: @"http://geocode-maps.yandex.ru/1.x/?format=json&geocode=%@%%20%@", [NSNumber numberWithDouble: coordinate.longitude], [NSNumber numberWithDouble: coordinate.latitude]];
    NSDictionary * serverData = [_parser loadFromUrl: [url getAddingPercentEscapes]];
    NSArray * locationData = serverData[@"response"][@"GeoObjectCollection"][@"featureMember"];
    
    if (!locationData || locationData.count < 1) {
        return nil;
    }
    
    NSDictionary * data = locationData[0][@"GeoObject"];
    
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

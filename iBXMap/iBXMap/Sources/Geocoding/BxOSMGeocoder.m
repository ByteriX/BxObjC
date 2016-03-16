/**
 *	@file BxOSMGeocoder.m
 *	@namespace iBXMap
 *
 *	@details Интерфейс геокодинга, в том числе и обратного, адаптированный под решение OpenStreetMap
 *	@date 24.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxOSMGeocoder.h"
#import "BxCommon.h"
#import "BxData.h"
//#import "NSString+BxUtils.h"

@interface BxOSMGeocoder (){
@protected
    BxJsonKitDataParser * _parser;
}

@end

@implementation BxOSMGeocoder

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
    NSString * url = [NSString stringWithFormat: @"http://nominatim.openstreetmap.org/search?q=%@&format=json", [data.address getAddingPercentEscapes]];
    NSArray * serverData = (NSArray*)[_parser loadFromUrl: url];
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary * item in serverData) {
        [result addObject: [self osmDataFrom: item]];
    }
    [data completionWithResult: result];
}

- (BxResultGeocoder *) osmDataFrom: (NSDictionary*) data
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [data[@"lat"] doubleValue];
    coordinate.longitude = [data[@"lon"] doubleValue];
    
    NSString * address = data[@"display_name"];
    
    return [[[BxResultGeocoder alloc] initWithAddress: address coordinate: coordinate] autorelease];
}

- (BxResultGeocoder*) resultFromCoordinate: (CLLocationCoordinate2D) coordinate
{
    NSString * url = [NSString stringWithFormat: @"http://nominatim.openstreetmap.org/search?q=%@%%20%@&format=json", [NSNumber numberWithDouble: coordinate.latitude], [NSNumber numberWithDouble: coordinate.longitude]];
    NSArray * serverData = (NSArray*)[_parser loadFromUrl: [url getAddingPercentEscapes]];
    
    if (!serverData || serverData.count < 1) {
        return nil;
    }
    
    NSDictionary * data = serverData[0];
    
    return [self osmDataFrom: data];
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

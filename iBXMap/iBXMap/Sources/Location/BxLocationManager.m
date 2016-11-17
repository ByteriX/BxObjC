/**
 *	@file BxLocationManager.m
 *	@namespace iBXMap
 *
 *	@details Работа по опредлению местоположения в iOS
 *	@date 11.06.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxLocationManager.h"
#import "BxCommon.h"

@interface BxLocationManager ()

@property (nonatomic, retain) NSError * error;
@property (nonatomic, copy) BxOneLocationHandler locationFound;

@end

@implementation BxLocationManager

#define StandartErrorMessage StandartLocalString(@"MapLocationError")

+ (BxLocationManager *) defaultLocationManager
{
    static BxLocationManager * _default = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        _default = [[self allocWithZone: NULL] init];
    });
    return _default;
}

- (id) init
{
    self = [super init];
    if (self) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        [_manager setDesiredAccuracy: kCLLocationAccuracyBest]; // вообщето он итак по умолчанию
        _isOneCheck = NO;
        _isStarted = NO;
        self.maxRefreshTime = 0.2;
        self.timeout = 30.0;
        [self requestAuthorization];
    }
    return self;
}

- (void) requestAuthorization
{
    if ([_manager.class authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // iOS8+
            [_manager requestWhenInUseAuthorization];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    if (_isStartedOne) {
        if (!_isOneCheck) {
            if (self.locationFound) {
                self.locationFound(newLocation, nil);
            }
            @synchronized(self){
                _isOneCheck = YES;
                self.locationFound = nil;
            }
        }
    } else {
        if (self.locationFound && _isStarted) {
            [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(ignoreNewPosition) object: nil];
            //self.locationFound(newLocation, nil);
            [self performSelector: @selector(ignoreNewPosition) withObject: nil afterDelay: _maxRefreshTime];
        }
    }
}

- (void) ignoreNewPosition
{
    if (self.locationFound){
        self.locationFound(_manager.location, nil);
        @synchronized(self){
            self.locationFound = nil;
            _isStarted = NO;
        }
    }
}

/*- (void)locationManager:(CLLocationManager *)manager
 didUpdateLocations:(NSArray *)locations
 {
 //
 }*/

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.error = error;
    if (self.locationFound) {
        NSString * messageError = [error localizedFailureReason];
        if (messageError) {
            self.locationFound(nil, messageError);
        } else {
            self.locationFound(nil, StandartErrorMessage);
        }
        @synchronized(self){
            self.locationFound = nil;
        }
    }
    [self cancel];
}

- (void) startLocationBlock: (BxOneLocationHandler) locationFound
{
    if (![CLLocationManager locationServicesEnabled]) {
        if (locationFound){
            locationFound(nil, StandartLocalString(@"MapLocationDisabledError"));
        }
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        if (locationFound){
            locationFound(nil, StandartLocalString(@"MapLocationDeniedError"));
        }
        return;
    }
    [self cancel];
    @synchronized(self){
        _isOneCheck = NO;
        _isStarted = YES;
        [_manager startUpdatingLocation];
        self.locationFound = locationFound;
        self.error = nil;
    }
    [self performSelector: @selector(stopForTimeout) withObject: nil afterDelay: _timeout];
}

- (void)finishedFindingLocation:(CLLocation *)newLocation
{
    
}

- (void) getOneLocationBlock: (BxOneLocationHandler) locationFound
{
    @synchronized(self){
        _isStartedOne = YES;
    }
    [self startLocationBlock: locationFound];
}

- (void) getLocationBlock: (BxOneLocationHandler) locationFound
{
    @synchronized(self){
        _isStartedOne = NO;
    }
    [self startLocationBlock: locationFound];
}

- (void) stopForTimeout
{
    if (self.locationFound) {
        self.locationFound(nil, StandartErrorMessage);
    }
    [self stop];
}

- (void) stop
{
    @synchronized(self){
        _isStarted = NO;
        [_manager stopUpdatingLocation];
        self.locationFound = nil;
    }
}

- (void) cancel
{
    [self stop];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(stop) object: nil];
}

- (void) dealloc
{
    [self cancel];
    _manager.delegate = nil;
    [_error autorelease];
    _error = nil;
    [_manager autorelease];
    _manager = nil;
    [super dealloc];
}

@end

/**
 *	@file BxLocationManager.h
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

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

typedef void (^BxOneLocationHandler) (CLLocation *location, NSString * messageError);

@interface BxLocationManager : NSObject <CLLocationManagerDelegate>
{
@protected
    CLLocationManager * _manager;
    BOOL _isOneCheck;
    BOOL _isStarted;
    BOOL _isStartedOne;
}

+ (BxLocationManager*) defaultLocationManager;

//! Generate messageError, if location not found in this time. Default 30 sec
@property NSTimeInterval timeout;

//! For getLocationBlock the max time at update location. Default 0.2 sec
@property NSTimeInterval maxRefreshTime;

// Method for displaying authorization dialogue in iOS8+ (called authomatically during singletone initaialization)
// Don't forget to include in your app plist:

//	<key>NSLocationAlwaysUsageDescription</key>
//  <string></string>
//  <key>NSLocationWhenInUseUsageDescription</key>
//  <string></string>

- (void) requestAuthorization;

//! only first detected location return
- (void) getOneLocationBlock: (BxOneLocationHandler) locationFound;

//! detected location with refreshing, limited maxRefreshTime
- (void) getLocationBlock: (BxOneLocationHandler) locationFound;

- (void) cancel;

@end

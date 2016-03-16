//
//  BxGeocoderTests.m
//  iBXTest
//
//  Created by Balalaev Sergey on 7/24/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "BxGeocoderTests.h"
#import "BxMap.h"

@implementation BxGeocoderTests

- (void) testOSM
{
    BxGeocoder * geocoder = [[BxOSMGeocoder alloc] init];
    __block NSArray * osmResult = nil;
    [geocoder startGeocodingWithAdress: @"Москва, Арбат 12"
                     completionHandler:
     ^(NSArray *result, NSString *errorMesage, BxGeocoderData *data) {
         if (errorMesage) {
             STAssertTrue(NO, errorMesage);
              [self notify:SenAsyncTestCaseStatusFailed];
         }
         osmResult = [result retain];
          [self notify:SenAsyncTestCaseStatusSucceeded];
     }];
    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout: DISPATCH_TIME_FOREVER];
    STAssertTrue(osmResult.count > 0, @"Нет Арбата???");
    BxResultGeocoder * data = osmResult[0];
    [osmResult autorelease];
    osmResult = nil;
    [geocoder startReverseGeocodingWithCoordinate: data.coordinate completionHandler:
     ^(NSArray *result, NSString *errorMesage, BxGeocoderData *data) {
         if (errorMesage) {
             STAssertTrue(NO, errorMesage);
             [self notify:SenAsyncTestCaseStatusFailed];
         }
         osmResult = [result retain];
         [self notify:SenAsyncTestCaseStatusSucceeded];
     }];
    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout: DISPATCH_TIME_FOREVER];
     STAssertTrue(osmResult.count > 0, @"Нет Координат???");
    [osmResult autorelease];
}

- (void) testYandex
{
    BxGeocoder * geocoder = [[BxYandexGeocoder alloc] init];
    __block NSArray * yaResult = nil;
    [geocoder startGeocodingWithAdress: @"Москва, Арбат 12"
                     completionHandler:
     ^(NSArray *result, NSString *errorMesage, BxGeocoderData *data) {
         if (errorMesage) {
             STAssertTrue(NO, errorMesage);
             [self notify:SenAsyncTestCaseStatusFailed];
         }
         yaResult = [result retain];
         [self notify:SenAsyncTestCaseStatusSucceeded];
     }];
    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout: DISPATCH_TIME_FOREVER];
    STAssertTrue(yaResult.count > 1, @"Нет Арбата???");
    BxResultGeocoder * data = yaResult[1];
    [yaResult autorelease];
    yaResult = nil;
    [geocoder startReverseGeocodingWithCoordinate: data.coordinate completionHandler:
     ^(NSArray *result, NSString *errorMesage, BxGeocoderData *data) {
         if (errorMesage) {
             STAssertTrue(NO, errorMesage);
             [self notify:SenAsyncTestCaseStatusFailed];
         }
         yaResult = [result retain];
         [self notify:SenAsyncTestCaseStatusSucceeded];
     }];
    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout: DISPATCH_TIME_FOREVER];
    STAssertTrue(yaResult.count > 0, @"Нет Координат???");
    [yaResult autorelease];
}

@end

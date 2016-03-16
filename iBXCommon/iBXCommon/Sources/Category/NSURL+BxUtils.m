/**
 *	@file NSURL+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для NSURL
 *	@date 12.01.2015
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "NSURL+BxUtils.h"


@implementation NSURL (BxUtils)

- (BOOL) hasSkipBackupAttribute
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.1){
        return YES;
    }

    NSError *error = nil;

    id flag = nil;
    BOOL success = [self getResourceValue: &flag
                                   forKey: NSURLIsExcludedFromBackupKey error: &error];

    if(!success){

        NSLog(@"Error excluding %@ from backup %@", [self lastPathComponent], error);
        return NO;
    }

    if (!flag)
        return NO;

    return [flag boolValue];
}

- (BOOL) addSkipBackupAttribute
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.1){
        return NO;
    }

    NSError *error = nil;

    BOOL success = [self setResourceValue: @YES
                                   forKey: NSURLIsExcludedFromBackupKey error: &error];

    if(!success){

        NSLog(@"Error excluding %@ from backup %@", [self lastPathComponent], error);

    }

    return success;

}

- (BOOL) removeSkipBackupAttribute
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.1){
        return NO;
    }

    NSError *error = nil;

    BOOL success = [self setResourceValue: @NO
                                   forKey: NSURLIsExcludedFromBackupKey error: &error];

    if(!success){

        NSLog(@"Error excluding %@ from backup %@", [self lastPathComponent], error);

    }

    return success;

}

@end
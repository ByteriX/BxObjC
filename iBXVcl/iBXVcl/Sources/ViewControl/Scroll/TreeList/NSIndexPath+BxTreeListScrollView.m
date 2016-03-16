/**
 *	@file NSIndexPath+BxTreeListScrollView.m
 *	@namespace iBXVcl
 *
 *	@details NSIndexPath категория для древовидного список
 *	@date 23.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSIndexPath+BxTreeListScrollView.h"


@implementation NSIndexPath (CustomDocumentTableView)

- (NSIndexPath*) jointIndexPath: (NSIndexPath*) indexPath
{
    NSIndexPath* result = nil;
    if (self.length > 0 && indexPath.length > 0) {
        if ( [self indexAtPosition: 0] == [indexPath indexAtPosition: 0] ) {
            result = [NSIndexPath indexPathWithIndex: [self indexAtPosition: 0]];
            NSUInteger count = MIN(self.length, indexPath.length);
            for (int index = 1; index < count; index++) {
                if ( [self indexAtPosition: index] == [indexPath indexAtPosition: index] ){
                    result = [result indexPathByAddingIndex: [self indexAtPosition: index]];
                } else {
                    break;
                }
            }
        }
    }
    return result;
}

- (BOOL) isEqualToIndexPath: (NSIndexPath*) indexPath
{
    if (self.length == indexPath.length) {
        for (int index = 0; index < self.length; index++) {
            if ( [self indexAtPosition: index] != [indexPath indexAtPosition: index] ){
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (NSComparisonResult)compareWithoutLevel:(NSIndexPath *)otherObject
{
    NSUInteger count = MIN(self.length, otherObject.length);
    for (int index = 0; index < count; index++) {
        if ([self indexAtPosition: index] > [otherObject indexAtPosition: index]) {
            return NSOrderedDescending;
        } else if ([self indexAtPosition: index] < [otherObject indexAtPosition: index]) {
            return NSOrderedAscending;
        }
    }
    // WithoutLevel!!!
    return NSOrderedSame;
    /*if (self.length == otherObject.length){
     return NSOrderedSame;
     } else if (self.length > otherObject.length){
     return NSOrderedDescending;
     } else {
     return NSOrderedAscending;
     }*/
}

@end
//
//  TestDatabase.m
//  iBXTest
//
//  Created by Balalaev Sergey on 7/9/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "TestDatabase.h"

@implementation TestDatabase

- (NSString *) getResurcePath{
    return [[NSBundle bundleForClass: [self class]] pathForResource: [fileName stringByDeletingPathExtension]
                                           ofType: [fileName pathExtension]];
}

@end

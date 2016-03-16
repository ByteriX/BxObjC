//
//  BxXmlDataParserTests.m
//  iBXData
//
//  Created by Balalaev Sergey on 8/27/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "BxXmlDataParserTests.h"
#import "BxXmlDataParser.h"
#import "BxCommon.h"
#import "NSString+BxUtils.h"

@implementation BxXmlDataParserTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (NSString*) pathFromResourceFileName
{
    NSString * fileName = @"test.xml";
    return [[NSBundle bundleForClass:[self class]] pathForResource: [fileName stringByDeletingPathExtension]
                                           ofType: [fileName pathExtension]];
}

- (void) testXmlDataParser
{
    BxXmlDataParser * parser = [[BxXmlDataParser alloc] init];
    NSString * fileName = [self pathFromResourceFileName];
    NSDictionary * data = [parser loadFromFile: fileName];
    STAssertNotNil(data, @"Parser return nil object");
    STAssertTrue([[data childNodes][@"Test"][0][@"Output"] isEqualToString: @"One"], @"Check falues");
    NSLog(@"childNodes: %@", [data childNodes]);
    NSLog(@"attributes: %@", [data attributes]);
}

@end

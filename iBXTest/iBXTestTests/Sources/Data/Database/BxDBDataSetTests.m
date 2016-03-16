//
//  BxDBDataSetTests.m
//  iBXData
//
//  Created by Balalaev Sergey on 7/9/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "BxDBDataSetTests.h"
#import "BxData.h"
#import "TestDatabase.h"

@implementation BxDBDataSetTests

static int tableRecordsCount = 200;

- (void)setUp
{
    [super setUp];
    [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: @"DELETE FROM 'table'"];
    for (int i = 0; i < tableRecordsCount; i++) {
         BOOL result = [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: [NSString stringWithFormat: @"INSERT INTO 'table' ('name') VALUES ('name_%3d')", (int)(i + 1)]];
        if (!result) {
            [NSException raise: @"NotSetupException" format: @"%@", [[TestDatabase default] lastErrorMessage]];
        }
    }
}

- (void)tearDown
{
    // Tear-down code here.
    [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: @"DELETE FROM 'table'"];
    [super tearDown];
}

- (void) testNotNullTable
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    STAssertEquals(dataSet.count, tableRecordsCount, @"Проблема создания таблички");
}

- (void) checkPositionFrom: (BxDBDataSet*) dataSet startIndex: (int) startIndex revert: (BOOL) revert;
{
    for (int i = startIndex; revert ? i >= 0 : i < dataSet.count; revert ? i-- : i++) {
        NSDictionary * data = [dataSet dataFromIndex: i];
        NSString * expectedValue = [NSString stringWithFormat: @"name_%3d", (int)(i + 1)];
        NSString * actualValue = data[@"name"];
        STAssertEqualObjects(expectedValue, actualValue, nil);
    }
}

- (void) testGet0
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet1
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 39];
    [dataSet dataFromIndex: 8];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet3
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    for (int i = 0; i < 68; i++) {
        [dataSet dataFromIndex: i];
    }
    [dataSet update];
    [dataSet dataFromIndex: 50];
    [dataSet dataFromIndex: 20];
    [dataSet dataFromIndex: 8];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet4
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    for (int i = 0; i < 68; i++) {
        [dataSet dataFromIndex: i];
    }
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet5
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    for (int i = 0; i < 68; i++) {
        [dataSet dataFromIndex: i];
    }
    [dataSet update];
    [dataSet dataFromIndex: 50];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet6
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 50];
    [dataSet update];
    [dataSet dataFromIndex: 50];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet7
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 50];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet8
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 99];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet9
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 70];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet10
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 70];
    [self checkPositionFrom: dataSet startIndex: 99 revert: YES];
}

- (void) testGet11
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 40];
    [self checkPositionFrom: dataSet startIndex: 50 revert: YES];
}

- (void) testGet12
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 50 revert: YES];
}

- (void) testGet13
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 80];
    [self checkPositionFrom: dataSet startIndex: 50 revert: YES];
    [self checkPositionFrom: dataSet startIndex: 50 revert: NO];
}

- (void) testGet14
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 99 revert: YES];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testGet15
{
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    [self checkPositionFrom: dataSet startIndex: 99 revert: YES];
}

- (void) testBugGetFromListed
{
    // Дополняем табличку до 233
    for (int i = tableRecordsCount; i < 233; i++) {
        BOOL result = [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: [NSString stringWithFormat: @"INSERT INTO 'table' ('name') VALUES ('name_%3d')", (int)(i + 1)]];
        if (!result) {
            [NSException raise: @"NotSetupException" format: @"%@", [[TestDatabase defaultDatabase] lastErrorMessage]];
        }
    }
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    [self checkPositionFrom: dataSet startIndex: 226 revert: YES];
    // повторяем проверку
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    [self checkPositionFrom: dataSet startIndex: 232 revert: YES];
}

- (void) testBugGetFromListedDebug
{
    // Дополняем табличку до 233
    for (int i = tableRecordsCount; i < 233; i++) {
        BOOL result = [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: [NSString stringWithFormat: @"INSERT INTO 'table' ('name') VALUES ('name_%3d')", (int)(i + 1)]];
        if (!result) {
            [NSException raise: @"NotSetupException" format: @"%@", [[TestDatabase defaultDatabase] lastErrorMessage]];
        }
    }
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    for (int i = 226; i > 209; i--) {
        [dataSet dataFromIndex: i];
    }
    [dataSet dataFromIndex: 209];
    [self checkPositionFrom: dataSet startIndex: 209 revert: YES];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
}

- (void) testFreeGet1
{
    // Дополняем табличку до 233
    for (int i = tableRecordsCount; i < 233; i++) {
        BOOL result = [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: [NSString stringWithFormat: @"INSERT INTO 'table' ('name') VALUES ('name_%3d')", (int)(i + 1)]];
        if (!result) {
            [NSException raise: @"NotSetupException" format: @"%@", [[TestDatabase defaultDatabase] lastErrorMessage]];
        }
    }
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 200];
    [dataSet dataFromIndex: 210];
    [dataSet dataFromIndex: 220];
    [dataSet dataFromIndex: 232];
    [dataSet dataFromIndex: 209];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    [self checkPositionFrom: dataSet startIndex: 232 revert: YES];
}

- (void) testFreeGet2
{
    // Дополняем табличку до 233
    for (int i = tableRecordsCount; i < 233; i++) {
        BOOL result = [BxDBDataSet executeFromDB: [TestDatabase defaultDatabase] sql: [NSString stringWithFormat: @"INSERT INTO 'table' ('name') VALUES ('name_%3d')", (int)(i + 1)]];
        if (!result) {
            [NSException raise: @"NotSetupException" format: @"%@", [[TestDatabase defaultDatabase] lastErrorMessage]];
        }
    }
    BxDBDataSet * dataSet = [[[BxDBDataSet alloc] initWithDB: [TestDatabase defaultDatabase] tableName: @"'table'" orders: @"name"] autorelease];
    [dataSet update];
    [dataSet dataFromIndex: 200];
    [dataSet dataFromIndex: 210];
    [dataSet dataFromIndex: 220];
    [dataSet dataFromIndex: 232];
    [self checkPositionFrom: dataSet startIndex: 232 revert: YES];
    [dataSet dataFromIndex: 209];
    [dataSet dataFromIndex: 187];
    [dataSet dataFromIndex: 137];
    [dataSet dataFromIndex: 158];
    [self checkPositionFrom: dataSet startIndex: 158 revert: YES];
    [self checkPositionFrom: dataSet startIndex: 0 revert: NO];
    
}

@end

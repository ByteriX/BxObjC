/**
 *	@file BxDBDataSet.m
 *	@namespace iBXDB
 *
 *	@details Набор данных SQLite
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDBDataSet.h"
#import "BxFMDatabase.h"

@interface BxDBDataSet ()

@property (nonatomic, retain) NSString * countSQL;
@property (nonatomic, retain) NSString * itemsSQL;
@property (nonatomic, retain) NSString * itemSQL;

@end

@implementation BxDBDataSet

- (id) initWithDB: (BxDatabase*) db countSQL: (NSString*) countSQL itemsSQL: (NSString*) itemsSQL
{
    self = [self init];
    _isLoaded = NO;
    if (self) {
        _dataBase = [db retain];
        self.countSQL = countSQL;
        self.itemsSQL = itemsSQL;
        self.itemSQL = [NSString stringWithFormat: @"%@ LIMIT ? OFFSET ?", itemsSQL];
        _bufferCount = 40;
        _bufferOffset = -1;
        _bufferArray = [[NSMutableArray alloc] initWithCapacity: _bufferCount];
    }
    return self;
}

- (id) initWithDB: (BxDatabase*) db tableName: (NSString*) tableName orders: (NSString*) orders
{
    NSString * countSQL = [NSString stringWithFormat: @"SELECT count(rowid) FROM %@", tableName];
    NSString * itemsSQL = [NSString stringWithFormat: @"SELECT * FROM %@ ORDER BY %@", tableName, orders];
    return [self initWithDB: db countSQL: countSQL itemsSQL: itemsSQL];
}

- (id) initWithTableName: (NSString*) tableName orders: (NSString*) orders
{
    return [self initWithDB: [BxDatabase defaultDatabase] tableName: tableName orders: orders];
}

- (id) initWithCountSQL: (NSString*) countSQL itemsSQL: (NSString*) itemsSQL
{
    return [self initWithDB: [BxDatabase defaultDatabase] countSQL: countSQL itemsSQL: itemsSQL];
}

- (void) update
{
    [_dataBase open];
    _count = 0;
    _bufferOffset = -1;
    [_bufferArray removeAllObjects];
    BxFMResultSet * result = [_dataBase.database executeQuery: self.countSQL];
    if (result && [result next]){
        _count = [result longForColumnIndex: 0];
    } else {
        _count = 0;
    }
    _isLoaded = YES;
}

- (NSInteger) count
{
    if (!_isLoaded) {
        [self update];
    }
    return _count;
}

- (NSInteger) updateBufferWithIndex: (NSInteger) index
{
    NSInteger startIndex = index - _bufferCount / 2 + (_bufferCount + 1) % 2;
    NSInteger stopIndex = index + _bufferCount / 2;
    if (startIndex < 0) {
        stopIndex -= startIndex;
        startIndex = 0;
    }
    if (stopIndex >= _count) {
        stopIndex = _count - 1;
    }
    BOOL isEndedFil = YES;
    NSRange addRange;
    addRange.length = 0;
    if (_bufferOffset < 0) {
        addRange = NSMakeRange(startIndex, stopIndex - startIndex + 1);
        _bufferOffset = startIndex;
    } else {
        NSRange removeRange;
        if (_bufferOffset < startIndex) {
            NSInteger deletedCount = startIndex - _bufferOffset;
            _bufferOffset = startIndex;
            if (deletedCount > _bufferArray.count) {
                deletedCount = _bufferArray.count;
            }
            removeRange = NSMakeRange(0, deletedCount);
            [_bufferArray removeObjectsInRange: removeRange];
            NSInteger addIndex = startIndex + _bufferArray.count;
            addRange = NSMakeRange(addIndex, stopIndex - addIndex + 1);
        } else {
            if (_bufferOffset > startIndex) {
                NSInteger deletedCount = _bufferOffset - startIndex;
                //int deletedIndex = _bufferOffset - startIndex;
                if (deletedCount < _bufferArray.count) {
                    removeRange = NSMakeRange(_bufferArray.count - deletedCount, deletedCount);
                    [_bufferArray removeObjectsInRange: removeRange];
                } else {
                    [_bufferArray removeAllObjects];
                }
                addRange = NSMakeRange(startIndex, stopIndex - startIndex - _bufferArray.count + 1);
                _bufferOffset = startIndex;
                isEndedFil = NO;
            }
        }
    }
    
    if (addRange.length > 0) {
        BxFMResultSet * result = [_dataBase.database executeQuery: self.itemSQL withArgumentsInArray: @[@(addRange.length), @(addRange.location)]];
        if (result) {
            int insertedIndex = 0;
            while ([result next]) {
                if (isEndedFil) {
                    [_bufferArray addObject: [result resultDictionary]];
                } else {
                    [_bufferArray insertObject: [result resultDictionary] atIndex: insertedIndex];
                }
                insertedIndex++;
            }
            // надо какую то реакцию. Если не удалось получить элемент
        }
    }
    
    return index - _bufferOffset;
}

- (id) dataFromIndex: (NSInteger) index
{
    if (!_isLoaded) {
        [NSException raise: @"NotCorrectException" format: @"DBDataSet is not right init"];
    }
    
    [_dataBase open];
    
    if (_bufferCount < 2) {
        BxFMResultSet * result = [_dataBase.database executeQuery: self.itemSQL withArgumentsInArray: @[@1, @(index)]];
        if (result && [result next]) {
            return [result resultDictionary];
        }
    } else {
        if (_bufferOffset > -1 && index > _bufferOffset - 1 && index < _bufferOffset + _bufferArray.count) {
            return _bufferArray[index - _bufferOffset];
        } else {
            NSInteger bufferIndex = [self updateBufferWithIndex: index];
            if (_bufferArray.count > bufferIndex) {
                return _bufferArray[bufferIndex];
            }
        }
    }
    return nil;
}

- (NSArray*) allData
{
    if (!_isLoaded) {
        [self update];
    }
    [_dataBase open];
    BxFMResultSet * result = [_dataBase.database executeQuery: self.itemsSQL];
    NSMutableArray * returnResult = [NSMutableArray arrayWithCapacity: _count];
    while ([result next]) {
        [returnResult addObject: [result resultDictionary]];
    }
    return returnResult;
}

+ (BOOL) executeWith: (NSString*) sql
{
    return [self executeFromDB: [BxDatabase defaultDatabase] sql: sql];
}

+ (BOOL) executeFromDB: (BxDatabase*) database sql: (NSString*) sql
{
    [database open];
    return [database.database executeUpdate: sql];
}

+ (NSNumber*) executeNumberFunctionWith: (NSString*) sql
{
    [[BxDatabase defaultDatabase] open];
    BxFMResultSet * result = [[BxDatabase defaultDatabase].database executeQuery: sql];
    if (result && [result next]){
        return [NSNumber numberWithLong: [result longForColumnIndex: 0]];
    } else {
        return nil;
    }
}

+ (NSArray*) allDataWith: (NSString*) sql
{
    [[BxDatabase defaultDatabase] open];
    BxFMResultSet * result = [[BxDatabase defaultDatabase].database executeQuery: sql];
    NSMutableArray * returnResult = [NSMutableArray array];
    while ([result next]) {
        [returnResult addObject: [result resultDictionary]];
    }
    return returnResult;
}

- (void) dealloc
{
    [_bufferArray autorelease];
    _bufferArray = nil;
    [_dataBase autorelease];
    _dataBase = nil;
    self.countSQL = nil;
    self.itemsSQL = nil;
    self.itemSQL = nil;
    [super dealloc];
}

@end


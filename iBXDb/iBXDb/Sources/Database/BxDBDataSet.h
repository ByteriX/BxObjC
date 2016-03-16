/**
 *	@file BxDBDataSet.h
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

#import <Foundation/Foundation.h>
#import "BxDatabase.h"

//! Набор данных SQLite
@interface BxDBDataSet : NSObject
{
@protected
    BOOL _isLoaded;
    NSInteger _count;
    BxDatabase * _dataBase;
    NSInteger _bufferCount;
    NSMutableArray * _bufferArray;
    NSInteger _bufferOffset;
}
- (id) initWithDB: (BxDatabase*) db countSQL: (NSString*) countSQL itemsSQL: (NSString*) itemsSQL;
- (id) initWithDB: (BxDatabase*) db tableName: (NSString*) tableName orders: (NSString*) orders;
- (id) initWithTableName: (NSString*) tableName orders: (NSString*) orders;
- (id) initWithCountSQL: (NSString*) countSQL itemsSQL: (NSString*) itemsSQL;

- (void) update;

- (NSInteger) count;

- (id) dataFromIndex: (NSInteger) index;

- (NSArray*) allData;

//! Эти методы некорректны и никакого отношения не имеют к наборам данных, они перенесены в BxDatabase
+ (BOOL) executeFromDB: (BxDatabase*) database sql: (NSString*) sql NS_DEPRECATED(10_0, 10_8, 2_0, 7_0);
+ (BOOL) executeWith: (NSString*) sql NS_DEPRECATED(10_0, 10_8, 2_0, 7_0);
+ (NSNumber*) executeNumberFunctionWith: (NSString*) sql NS_DEPRECATED(10_0, 10_8, 2_0, 7_0);
+ (NSArray*) allDataWith: (NSString*) sql NS_DEPRECATED(10_0, 10_8, 2_0, 7_0);

@end
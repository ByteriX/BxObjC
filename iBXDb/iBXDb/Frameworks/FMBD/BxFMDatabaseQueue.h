//
//  BxFMDatabaseQueue.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bx_unicode_sqlite3.h"

@class BxFMDatabase;

@interface BxFMDatabaseQueue : NSObject {
    NSString            *_path;
    dispatch_queue_t    _queue;
    BxFMDatabase          *_db;
}

@property (atomic, retain) NSString *path;

+ (id)databaseQueueWithPath:(NSString*)aPath;
- (id)initWithPath:(NSString*)aPath;
- (void)close;

- (void)inDatabase:(void (^)(BxFMDatabase *db))block;

- (void)inTransaction:(void (^)(BxFMDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(BxFMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use BxFMDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(BxFMDatabase *db, BOOL *rollback))block;
#endif

@end


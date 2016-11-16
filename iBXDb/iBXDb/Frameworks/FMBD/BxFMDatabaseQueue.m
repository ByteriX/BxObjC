//
//  BxFMDatabaseQueue.m
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "BxFMDatabaseQueue.h"
#import "BxFMDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 BxFMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */
 
@implementation BxFMDatabaseQueue

@synthesize path = _path;

+ (id)databaseQueueWithPath:(NSString*)aPath {
    
    BxFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    BxFMDBAutorelease(q);
    
    return q;
}

- (id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [BxFMDatabase databaseWithPath:aPath];
        BxFMDBRetain(_db);
        
        if (![_db open]) {
            NSLog(@"Could not create database queue for path %@", aPath);
            BxFMDBRelease(self);
            return 0x00;
        }
        
        _path = BxFMDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (void)dealloc {
    
    BxFMDBRelease(_db);
    BxFMDBRelease(_path);
    
    if (_queue) {
        BxFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    BxFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        [_db close];
        BxFMDBRelease(_db);
        _db = 0x00;
    });
    BxFMDBRelease(self);
}

- (BxFMDatabase*)database {
    if (!_db) {
        _db = BxFMDBReturnRetained([BxFMDatabase databaseWithPath:_path]);
        
        if (![_db open]) {
            NSLog(@"BxFMDatabaseQueue could not reopen database for path %@", _path);
            BxFMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(BxFMDatabase *db))block {
    BxFMDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        BxFMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [BxFMDatabaseQueue inDatabase:]");
        }
    });
    
    BxFMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(BxFMDatabase *db, BOOL *rollback))block {
    BxFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    BxFMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(BxFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(BxFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(BxFMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    BxFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
            
        }
    });
    BxFMDBRelease(self);
    return err;
}
#endif

@end

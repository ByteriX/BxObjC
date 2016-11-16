//
//  BxFMDatabaseUnicode.m
//  FullTextSearch
//
//  Created by Balalaev Sergey on 3/25/13.
//  Copyright (c) 2013 Balalaev Sergey. All rights reserved.
//

#import "BxFMDatabaseUnicode.h"
#import "sqlite3_unicode.h"
#import "sqlite3_fts_extension.h"
#import "sqlite3_utils_extension.h"

@interface BxFMDatabaseUnicode (private)

- (const char*)sqlitePath;

@end

@implementation BxFMDatabaseUnicode

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags {
    bx_unicode_sqlite3_fts_extension_load();
    bx_unicode_sqlite3_unicode_load();
    int err = bx_unicode_sqlite3_open_v2([self sqlitePath], &_db, flags, NULL /* Name of VFS module to use */);
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    }
    return YES;
}
#endif

- (BOOL)open {
    if (_db) {
        return YES;
    }
    bx_unicode_sqlite3_utils_extension_load();
    bx_unicode_sqlite3_fts_extension_load();
    bx_unicode_sqlite3_unicode_load();
    int err = bx_unicode_sqlite3_open_v2([self sqlitePath], &_db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, 0);
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    }
    
    return YES;
}

/*- (BOOL)open {
    bx_unicode_sqlite3_unicode_load();
    return [self open];
}*/

- (BOOL)close {
    BOOL result = [super close];
    bx_unicode_sqlite3_unicode_free();
    return result;
}

@end

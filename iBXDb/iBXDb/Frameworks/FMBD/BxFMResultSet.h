#import <Foundation/Foundation.h>
#import "bx_unicode_sqlite3.h"

#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

@class BxFMDatabase;
@class BxFMStatement;

@interface BxFMResultSet : NSObject {
    BxFMDatabase          *_parentDB;
    BxFMStatement         *_statement;
    
    NSString            *_query;
    NSMutableDictionary *_columnNameToIndexMap;
}

@property (atomic, retain) NSString *query;
@property (readonly) NSMutableDictionary *columnNameToIndexMap;
@property (atomic, retain) BxFMStatement *statement;

+ (id)resultSetWithStatement:(BxFMStatement *)statement usingParentDatabase:(BxFMDatabase*)aDB;

- (void)close;

- (void)setParentDB:(BxFMDatabase *)newDb;

- (BOOL)next;
- (BOOL)hasAnotherRow;

- (int)columnCount;

- (int)columnIndexForName:(NSString*)columnName;
- (NSString*)columnNameForIndex:(int)columnIdx;

- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;

- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;

- (long long int)longLongIntForColumn:(NSString*)columnName;
- (long long int)longLongIntForColumnIndex:(int)columnIdx;

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;
- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;

- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;

- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;

- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;

- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;

- (NSData*)dataForColumn:(NSString*)columnName;
- (NSData*)dataForColumnIndex:(int)columnIdx;

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;
- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName;

// returns one of NSNumber, NSString, NSData, or NSNull
- (id)objectForColumnName:(NSString*)columnName;
- (id)objectForColumnIndex:(int)columnIdx;

- (id)objectForKeyedSubscript:(NSString *)columnName;
- (id)objectAtIndexedSubscript:(int)columnIdx;

/*
If you are going to use this data after you iterate over the next row, or after you close the
result set, make sure to make a copy of the data first (or just use dataForColumn:/dataForColumnIndex:)
If you don't, you're going to be in a world of hurt when you try and use the data.
*/
- (NSData*)dataNoCopyForColumn:(NSString*)columnName NS_RETURNS_NOT_RETAINED;
- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx NS_RETURNS_NOT_RETAINED;

- (BOOL)columnIndexIsNull:(int)columnIdx;
- (BOOL)columnIsNull:(NSString*)columnName;


/* Returns a dictionary of the row results mapped to case sensitive keys of the column names. */
- (NSDictionary*)resultDictionary;
 
/* Please use resultDictionary instead.  Also, beware that resultDictionary is case sensitive! */
- (NSDictionary*)resultDict  __attribute__ ((deprecated));

- (void)kvcMagic:(id)object;

 
@end

/**
 *	@file BxExpiredDataCasher.m
 *	@namespace iBXData
 *
 *	@details Кеширование со сроком действия
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxExpiredDataCasher.h"

NSString const* FNExpiredDataCasherCashed = @"cashed";
NSString const* FNExpiredDataCasherDate = @"date";

@implementation BxExpiredDataCasher

//! @override
- (id) initWithFileName: (NSString*) cashedFileName expiredInterval: (NSTimeInterval) expiredInterval
{
    self = [super initWithFileName: cashedFileName];
	if ( self ){
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setLocale: [[[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"] autorelease]];
		[_dateFormatter setFormatterBehavior: NSDateFormatterBehavior10_4];
		[_dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
		_expiredInterval = expiredInterval;
	}
	return self;
}

//! @override
- (NSDictionary *) loadData
{
	//return nil;
	NSDictionary * result = [super loadData];
	if (result){
		if (![result objectForKey: FNExpiredDataCasherDate]){
			return nil;
		}
		if (![result objectForKey: FNExpiredDataCasherCashed]){
			return nil;
		}
		NSDate * currentDate = [_dateFormatter dateFromString: [result objectForKey: FNExpiredDataCasherDate]];
		NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate: currentDate];
		NSLog(@"Time interval %f", timeInterval);
		if (timeInterval > _expiredInterval || timeInterval < 0){
			return nil;
		}
		return [result objectForKey: FNExpiredDataCasherCashed];
	}
	return result;
}

- (NSDate*) cashDate
{
	NSDictionary * result = [super loadData];
	if (result){
		if (![result objectForKey: FNExpiredDataCasherDate]){
			return nil;
		}
		return [_dateFormatter dateFromString: [result objectForKey: FNExpiredDataCasherDate]];
	} else {
		return nil;
	}
    
}

- (NSDictionary *) loadDataIfExpired
{
	NSDictionary * result = [super loadData];
	if (result) {
		return [result objectForKey: FNExpiredDataCasherCashed];
	} else {
		return nil;
	}
}

//! @override
- (void) saveData: (NSDictionary *) data
{
	NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity: 2];
    if (data) {
        [result setObject: data forKey: FNExpiredDataCasherCashed];
    }
	NSDate * currentDate = [NSDate date];
	[result setObject: [_dateFormatter stringFromDate: currentDate] forKey: FNExpiredDataCasherDate];
	[super saveData: result];
	NSLog(@"cash info updated on %@", currentDate);
}

- (void)dealloc {
	[_dateFormatter autorelease];
    _dateFormatter = nil;
    [super dealloc];
}

@end

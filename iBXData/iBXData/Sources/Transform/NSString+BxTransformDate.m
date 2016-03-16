/**
 *	@file NSString+BxTransformDate.m
 *	@namespace iBXData
 *
 *	@details NSString категория конвертации данных в дату
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSString+BxTransformDate.h"

@implementation NSString (BxTransformDate)

- (NSDate*)dateFromRfc3999Value {
    
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:en_US_POSIX];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    });
    
    
    // Process date
    NSDate *date = nil;
    NSString *RFC3339String = [self uppercaseString];
    RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
    // Remove colon in timezone as iOS 4+ NSDateFormatter breaks. See https://devforums.apple.com/thread/45837
    if (RFC3339String.length > 20) {
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                 withString:@""
                                                                    options:0
                                                                      range:NSMakeRange(20, RFC3339String.length-20)];
    }
    
    if (!date) { // 1996-12-19T16:39:57-0800
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
        date = [dateFormatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27.87+0020
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
        date = [dateFormatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        date = [dateFormatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27.87+0020
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd''ZZZ"];
        date = [dateFormatter dateFromString:RFC3339String];
    }
    if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possibly invalid format.", self);
    
    //NSLog(@"%s: %@ => %@",__PRETTY_FUNCTION__,RFC3339String,date);
    
    return date;
}

+ (id) stringWithTime: (JPlusDateTime) time
{
	return [self stringWithFormat: @"/Date(%lld)/", time, nil];
}

+ (id) stringWithJTime: (NSDate*) date
{
	JPlusDateTime time = (JPlusDateTime)([date timeIntervalSince1970] * 1000.0);
	return [self stringWithFormat: @"/Date(%lld)/", time, nil];
}

- (JPlusDateTime) getJPlusDateTime
{
	NSRange range = [self rangeOfString: @"+"];
	if (range.length > 0) {
		NSString * timeOnly = [self substringWithRange: NSMakeRange(6, range.location - 6)];
		NSString * local = [self substringWithRange: NSMakeRange(range.location + 1, self.length - range.location - 1)];
		return [timeOnly longLongValue] + ([local longLongValue] * 3600000ll) / 100;
	} else {
		return [[self substringWithRange: NSMakeRange(6, self.length - 8)] longLongValue];
	}
}

@end

/**
 *	@file NSString+BxUtils.m
 *	@namespace iBXCommon
 *
 *	@details Категория для NSString
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "NSString+BxUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+HTML.h"

@implementation NSString (BxUtils)

- (NSComparisonResult) versionCompare:(NSString *) compareString
{
    if ([self isEqualToString: compareString]) {
        return NSOrderedSame;
    }
    NSCharacterSet * charset = [NSCharacterSet characterSetWithCharactersInString: @" .,"];
    NSArray * selfVersions = [self componentsSeparatedByCharactersInSet: charset];
    NSArray * compareVersions = [compareString componentsSeparatedByCharactersInSet: charset];
    int index = 0;
    while (selfVersions.count > index && compareVersions.count > index) {
        @try {
            int selfVersion = [[selfVersions objectAtIndex: index] intValue];
            int compareVersion = [[compareVersions objectAtIndex: index] intValue];
            if (compareVersion > selfVersion) {
                return NSOrderedAscending;
            } else if (compareVersion < selfVersion){
                return NSOrderedDescending;
            }
        }
        @catch (NSException *exception) {
            return NSOrderedDescending;
        }
        index++;
    }
    if (compareVersions.count > index) {
        return NSOrderedAscending;
    } else if (compareVersions.count == selfVersions.count) {
        return NSOrderedSame; // вообще странная ситуация!
    } else {
        return NSOrderedDescending;
    }
}

- (NSString *) md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2] autorelease];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

-(NSString*)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString*) getReplacingPercentEscapes
{
	NSString * result = [(NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"%", kCFStringEncodingUTF8 ) autorelease];
    
    return result;
}

- (NSString*) getAddingPercentEscapes
{
	NSString * result = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"%", (CFStringRef)@"+", kCFStringEncodingUTF8 ) autorelease];
    
    return result;
}

- (NSString*) getAddingPercentEscapesWithDublicate
{
	NSString * result = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"+", kCFStringEncodingUTF8 ) autorelease];
    
    return result;
}

- (NSString *)getAddingPercentEscapesToParams
{
    NSString * result = [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL,
                                                                              (CFStringRef)@";/?:@&=$+{}<>,",
                                                                              kCFStringEncodingUTF8) autorelease];
    
    return result;
}

+ (NSString*) getUUID
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = [(NSString *)newUniqueIDString lowercaseString];
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return guid;
}

- (NSStringEncoding)encodingFromEncodingName
{
    return  CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)self));
}

- (NSString*) htmlToPlainText
{
    return [self stringByConvertingHTMLToPlainText];
}

- (NSDictionary*) componentsFromURLParams
{
    NSArray * components = [self componentsSeparatedByString: @"&"];
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity: components.count];
    for (NSString * item in components) {
        NSRange range = [item rangeOfString: @"="];
        if (range.length > 0) {
            NSString * key = [item substringToIndex: range.location];
            NSString * value = [item substringFromIndex: range.location + range.length];
            [result setObject: value forKey: key];
        }
    }
    return result;
}

- (NSString*) urlFromResourceFileName
{
    NSString * path = [self pathFromResourceFileName];
    NSURL * url = [NSURL fileURLWithPath: path];
    return [url absoluteString];
}

- (NSString*) pathFromResourceFileName
{
    return [[NSBundle mainBundle] pathForResource: [self stringByDeletingPathExtension]
                                           ofType: [self pathExtension]];
}

@end

@implementation NSMutableString (BxUtils)

- (void) addToXFormsPath: (NSString*) path fromObject: (id) object
{
    if ([object isKindOfClass: NSNumber.class] || [object isKindOfClass: NSString.class]) {
        [self appendFormat: @"%@=%@&", path, object];
    } else if ([object isKindOfClass: NSDictionary.class]){
        for (NSString * key in [object allKeys]) {
            NSString * pathKey = key;
            if (path) {
                pathKey = [NSString stringWithFormat: @"%@[%@]", path, key];
            }
            [self addToXFormsPath: pathKey fromObject: [object objectForKey: key]];
        }
    } else if ([object isKindOfClass: NSArray.class]){
        int index = 0;
        for (NSString * value in object) {
            NSString * pathKey = @"";
            if (path) {
                pathKey = path;
            }
            pathKey = [NSString stringWithFormat: @"%@[%d]", pathKey, index];
            [self addToXFormsPath: pathKey fromObject: value];
            index++;
        }
    }
}

@end

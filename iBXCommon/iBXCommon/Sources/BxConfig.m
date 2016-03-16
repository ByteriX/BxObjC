/**
 *	@file BxConfig.m
 *	@namespace iBXCommon
 *
 *	@details Настройка окружения
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxConfig.h"
#import "BxCommon.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

//! Проверка на трассировку программы в момент вызова этой функции
static bool isTraced(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
	
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
	
    info.kp_proc.p_flag = 0;
	
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
	
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
	
    // Call sysctl.
	
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
	
    // We're being debugged if the P_TRACED flag is set.
	
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

@implementation BxConfig

+ (BxConfig*) defaultConfig
{
    static BxConfig * _default = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _default = [[self allocWithZone: NULL] init];
    });
    return _default;
}

+ (NSString*) getApplicationPathFromKey: (int) key
{
    NSString * result = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(key, NSUserDomainMask, YES);
    if ([paths count] > 0){ // Это стандартный каталог документов, доступный только для данного приложения
        result = [paths objectAtIndex:0];
    } else{
        @throw [NSException exceptionWithName:@"PathNotFoundException" reason:@"Config is not initialized. Path not found." userInfo:nil];
    }
    [BxFileSystem initDirectories: result];
    return result;
}

- (id) init{
	self = [super init];
	if (self == nil){
		return self;
    }
    
	// определяем место каталога для документов приложения:
	_documentPath = [[self.class getApplicationPathFromKey: NSDocumentDirectory] retain];
    _cashPath = [[self.class getApplicationPathFromKey: NSCachesDirectory] retain];
    _tempPath = [self.cashPath retain];
    
	NSLog(@"%@", [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]);
    
    NSString * rawLanguage = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    if ([rawLanguage isEqualToString:@"RU"]) {
        _language = BxConfigLocaleRussian;
    } else if ([rawLanguage isEqualToString:@"EN"]) {
        _language = BxConfigLocaleEnglish;
    } else {
        _language = BxConfigLocaleDefault;
	}
    
    NSString * rawLocale = [[[NSLocale currentLocale] objectForKey: NSLocaleCurrencyCode] uppercaseString];
    if ([rawLocale isEqualToString:@"RU"]) {
    } else if ([rawLocale isEqualToString:@"EN"]) {
    } else {
		rawLocale = @"EN";
	}
    
	_commonDateFormatter = [[NSDateFormatter alloc] init];
	if ([rawLocale isEqualToString:@"RU"]) {
		[_commonDateFormatter setDateFormat:@"HH:mm dd.MM.yyyy"];
	} else {
		[_commonDateFormatter setAMSymbol:@"AM"];
		[_commonDateFormatter setPMSymbol:@"PM"];
		[_commonDateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
	}
    
	// инициализация окончена
	return self;
}

+ (BOOL) isDebuging
{
	//return isTraced();
#ifdef DEBUG // определение установлено в настройках проекта
	return true;
#else
	return false;
#endif
}

+ (NSString*) deviceTokenFromData: (NSData*) webDeviceToken
{
    NSString *deviceToken = [[webDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deviceToken;
}

+ (void) performFakeMemoryWarning {
#ifdef DEBUG
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }else {
        NSLog(@"Error: UIApplication no loger responds to -_performMemoryWarning");
    }
#else
    NSLog(@"Warning: performFakeMemoryWarning called on a non debug");
#endif
}

+ (float) scale
{
	CGFloat scale = 1.0f;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		scale = [[UIScreen mainScreen] scale];
	}
	return scale;
}

- (void) dealloc
{
    [_documentPath release];
    [_cashPath release];
    [_tempPath release];
    [_commonDateFormatter release];
    [super dealloc];
}

@end

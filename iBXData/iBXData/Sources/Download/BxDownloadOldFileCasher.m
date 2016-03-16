/**
 *	@file BxDownloadOldFileCasher.m
 *	@namespace iBXData
 *
 *	@details Кешированная закачка ресурсов из Веб-сервиса
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadOldFileCasher.h"
#import "BxCommon.h"
#import "BxData.h"

@interface BxDownloadOldFileCasher ()
{
@protected
    BxAbstractDataParser * _parser;
}

@end

@implementation BxDownloadOldFileCasher

static BxDownloadOldFileCasher * _defaultDownloadCash = nil;
//! Название каталога с рабочим материалом
static NSString * _defaultName = @"cash";
//! При удалении из кеша лимит очистки
static int deletePoolCount = 10;

+ (BxDownloadOldFileCasher *) downloadCashWithName: (NSString*) name
{
	BxDownloadOldFileCasher * result = [[[self alloc] initWithName: name] autorelease];
	return result;
}

+ (BxDownloadOldFileCasher *) defaultCasher
{
    if (!_defaultDownloadCash){
        @synchronized (self){
            if (!_defaultDownloadCash){
                _defaultDownloadCash = [[self allocWithZone: NULL] initWithName: _defaultName];
            }
        }
    }
	return _defaultDownloadCash;
}

- (NSString *) getDefaultCashPath
{
    return [BxConfig defaultConfig].cashPath;
}

- (void) setCurrentDirName:(NSString *) value
{
	[_currentDirPath autorelease];
	_currentDirPath = [[[self getDefaultCashPath] stringByAppendingPathComponent: value] retain];
	[BxFileSystem initDirectories: _currentDirPath];
}

- (void) setCurrentFileName:(NSString *) value
{
	[_currentFilePath autorelease];
	_currentFilePath = [[[self getDefaultCashPath] stringByAppendingPathComponent: value] retain];
	[BxFileSystem initDirectories: [_currentFilePath stringByDeletingLastPathComponent]];
}

- (id) initWithName: (NSString*) name
{
	self = [self init];
	if (self) {
		NSString * fileName = [NSString stringWithFormat: @"%@/download_cash.plist", name, nil];
		[self setCurrentDirName: name];
		[self setCurrentFileName: fileName];
		[self open];
	}
	return self;
}

- (id)init{
    self = [super init];
    if ( self ) {
        self.streamSaver = [BxDownloadStreamSaver new];
        _parser = [[BxPropertyListParser alloc] init];
		_maxCashCount = 1000;
		_cashUpdatingLock = [[NSLock alloc] init];
		_mainLock = [[NSLock alloc] init];
        _cashSearch = [[NSMutableDictionary alloc] init];
		//[cashSearch setObject: [NSNumber numberWithUnsignedLongLong: 0] forKey:@"maxIndex"];
		// Определяем формат времени и даты для сериализации/дисериализации
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setLocale: [[[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"] autorelease]];
		[_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[_dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
		//[_dateFormatter setDateFormat:@"%a, %d %b %Y %H:%M:%S %z"];
		_isCheckUpdate = NO;
		_isContaining = YES;
		
    }
    return self;
}

- (BOOL) isCashed: (NSString*) url
{
	return [_cashSearch objectForKey: url] != nil;
}

- (BOOL) isCashedAndNotUpdate: (NSString*) url
{
	return [_cashSearch objectForKey: url] != nil; // тут надо поумнее придумать
}

//! украл
- (NSString*) localSavedURLFrom: (NSString*) url
                        cashDir: (NSString*)path
					   progress: (id<BxDownloadProgress>) progress
{
	NSString * resultPath = [self.streamSaver saveFrom: url to: path delegate: progress ext: _extention isContaining: _isContaining containingLevel: 0];
    // загрузка содержимого ресурса
	if (resultPath){
		return [resultPath substringFromIndex: _currentDirPath.length + 1];
	} else {
		return nil;
	}
}

//! украл
+ (NSString*) localURLFrom: (NSString*) absolutePath
{
    
	if (absolutePath){
		NSURL * url = [NSURL fileURLWithPath: absolutePath];
		return [url relativeString];
	}else{
		return nil;
	}
}

- (NSString*) localURLFrom: (NSString*) absolutePath
{
	absolutePath = [_currentDirPath stringByAppendingPathComponent: absolutePath];
	if (absolutePath){
		return [self.class localURLFrom: absolutePath];
	}else{
		return nil;
	}
}

/**
 *	@brief Возвращает путь в кеше cashDir к ресурсу url
 *
 *	у которого установлена дата изменения в lastModified
 */
- (NSString*) getUpdatedPath: (NSString*)url cashDir: (NSString*)path
				lastModified: (NSDate*) lastModified
					progress: (id<BxDownloadProgress>) progress
{
	path = [self localSavedURLFrom: url cashDir: path progress: progress];
	if (!path)
		path = @"";
	NSMutableDictionary * object = [[NSMutableDictionary alloc] init];
	[object setObject: path forKey: @"path"];
	if (lastModified){
		[object setObject: [_dateFormatter stringFromDate: lastModified]
                   forKey: @"updateDate"];
	} else {
		[object setObject: [_dateFormatter stringFromDate: [NSDate date]]
                   forKey: @"updateDate"];
	}
	// надо сохранить дату файла, для валидации, ато фигня получается!
    // begin секция блокировки
	[_cashUpdatingLock lock];
	[_cashSearch setObject: object forKey: url];
	[self save];
	[_cashUpdatingLock unlock];
    // end секция блокировки
	[object release];
	return path;
}

- (NSDate *) getLastModifiedFromAllHeader: (NSDictionary*) headers
{
    NSDate * result = nil;
	if (headers){
		NSString *modified = [headers objectForKey:@"Last-Modified"];
		if (modified) {
			result = [_dateFormatter dateFromString: modified];
			if (!result){
				NSLog(@"[DownloadCash] getLastModifiedFrom : result = nil");
				NSString * stFormatNotSupport = [NSString stringWithFormat:
                                                 StandartLocalString(@"Date format of the Last-Modified: '%@' is not corrected from: '%@' "),
                                                 modified, [_dateFormatter dateFormat], nil];
				NSLog(stFormatNotSupport, nil);
				@throw [NSException exceptionWithName: @"LastModifiedDateNotFound"
                                               reason: stFormatNotSupport userInfo:nil];
			}
		} else {
			NSLog(@"[DownloadCash] getLastModifiedFrom : modified = nil");
			NSString * stLastModifiedDateNotFound = StandartLocalString(@"Attribute Last-Modified from a http header is not found, when is required for caching");
			NSLog(stLastModifiedDateNotFound, nil);
			@throw [NSException exceptionWithName: @"LastModifiedDateNotFound" reason: stLastModifiedDateNotFound userInfo:nil];
		}
	} else{
		NSLog(@"Нет доступа к интернет заголовкам для получения даты изменения");
	}
	return result;
}

+ (NSDate *) getLastModifiedFromAllHeader: (NSDictionary*) headers
{
    return [[self defaultCasher] getLastModifiedFromAllHeader: headers];
}

/**
 *	Возвращает дату последнего изменения из запроса к ресурсу url
 */
- (NSDate *) getLastModifiedFrom: (NSString*) url
{
	NSDictionary *headers = [BxDownloadStream getAllHeaderFieldsFrom: url];
	return [self getLastModifiedFromAllHeader: headers];
}

/**
 *	@brief Возвращает неполное имя сохраненного в кеше ресурса url
 *
 *	При необходимости можно получить полный WEB-путь с помощью @ref localURLFrom.
 *	@examples http://www.pravo.ru/store/images/6/9613.jpg
 */
- (NSString *) getDownloadedNameFrom: (NSString*) url
						lastModified: (NSDate *) lastModified
							progress: (id<BxDownloadProgress>) progress
{
	NSDictionary * data = [_cashSearch objectForKey: url];
	if (data) { // Есть возможность достать из кеша, но надо проверить
		NSString * path = [data objectForKey: @"path"];
		if (lastModified || (!_isCheckUpdate))
		{ // удалось получить дату последнего обновления
			[_cashUpdatingLock lock];
			NSLog(@"[DownloadCash] Last update: %@ from %@",
				  [_dateFormatter stringFromDate: lastModified], url);
			NSDate * currentDate = [_dateFormatter dateFromString: [data objectForKey: @"updateDate"]];
			NSLog(@"[DownloadCash] and from cash: %@",
				  [_dateFormatter stringFromDate: currentDate]);
			NSString * newPath = [_currentDirPath stringByAppendingPathComponent: path];
			if (_isCheckUpdate && (![lastModified isEqualToDate: currentDate] ||
                                   ![[NSFileManager defaultManager] fileExistsAtPath: newPath]))
			{ // файл утратил свою силу и его следует обновить
				NSLog(@"[DownloadCash] Updating from %@", url);
				newPath = [newPath stringByDeletingLastPathComponent];
				[BxFileSystem initDirectories: newPath];
				[_cashSearch removeObjectForKey: url];
				[_cashUpdatingLock unlock];
				path = [self getUpdatedPath: url
									cashDir: newPath
							   lastModified: lastModified
								   progress: progress
                        ];
			} else {
				[_cashUpdatingLock unlock];
				[progress startFastFull];
			}
		} else {
			NSLog(@"[DownloadCash] not set lastModified!");
			[progress startFastFull];
		}
		return path;
	} else { // Это новый ресурс его следует поместить в кеш
		if (!url || [url isEqualToString: @""])
			return nil;
		NSLog(@"[DownloadCash] Loading from %@", url);
		NSString * path = [BxFileSystem addNewFolderTo: _currentDirPath];
		path = [self getUpdatedPath: url
							cashDir: path
					   lastModified: lastModified
						   progress: progress
                ];
		return path;
	}
}

- (NSString*) getLocalDownloadedPathFrom: (NSString*) url
{
    NSString * path = [[_cashSearch objectForKey: url] objectForKey: @"path"];
    return [self localURLFrom: path];
}



- (NSString *) getDownloadedPathFrom: (NSString*) url
{
	return [self getDownloadedPathFrom: url errorConnection: NO progress: nil];
}

+ (BOOL) isLocale: (NSString*) url{
	NSURL * currentUrl = [NSURL URLWithString: url];
	return [[currentUrl.host lowercaseString] isEqualToString:@"localhost"];
}

- (NSString *) getDownloadedPathFrom: (NSString*) url errorConnection: (BOOL) errorConnection progress: (id<BxDownloadProgress>) progress
{
	if ([[self class] isLocale: url])
	{
		NSLog(@"[DownloadCash] resend from local url");
		if (progress){
			[progress startFastFull];
		}
		return url;
	} else {
		NSString * result = nil;
		//[mainLock lock];
		@try{
			NSDate * lastModified = nil;
			if (_isCheckUpdate){
				lastModified = [self getLastModifiedFrom: url];
				if ((!lastModified) && errorConnection){
					@throw [BxDownloadStreamException exceptionWithName: @"DownloadCashException"
                                                                 reason:
                            StandartLocalString(@"Unable to get the last modified date of a resource from the Internet")
                                                               userInfo: nil];
				}
			}
			result = [self getDownloadedNameFrom: url lastModified: lastModified progress: progress];
			result = [self localURLFrom: result];
		}@finally {
			//[mainLock unlock];
		}
		return result;
	}
}

+ (void) close{
	@synchronized (self) {
		if (_defaultDownloadCash){
			[_defaultDownloadCash release];
			_defaultDownloadCash = nil;
		}
	}
}

- (void) save
{
    @try {
        [_parser saveFrom: _cashSearch toPath: _currentFilePath];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception);
    }
}

- (void) open
{
    @try {
        NSDictionary * data = [_parser loadFromFile: _currentFilePath];
        [self.cashSearch addEntriesFromDictionary: data];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception);
    }
}

//! украл и переделал для очистки неиспользуемого кешем
- (BOOL) notUsing:(NSString*)dir
{
	NSArray * allValues = [_cashSearch allValues];
	NSString * pathDir = [dir stringByStandardizingPath];
	for (int i = 0; i < allValues.count; i++){
		NSString * path = [[allValues objectAtIndex: i ] objectForKey: @"path"];
		path = [path stringByDeletingLastPathComponent];
		if ([pathDir isEqualToString:[path stringByStandardizingPath]])
			return NO;
	}
	return YES;
}

//! очиста деректорий, которыми не пользуется регистратор кеша
- (void) cleanDir{
	NSError * error = nil;
	NSArray * paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: _currentDirPath error: &error];
	if (error) {
		NSLog(@"ERROR!!! %@", error);
	}
	if (paths.count < _maxCashCount){
		return;
	}
	for (int i = 0; i < paths.count; i++){
		NSString * dir = [paths objectAtIndex: i];
		if ([self notUsing: dir]){
			dir = [_currentDirPath stringByAppendingPathComponent: dir];
			if (![[NSFileManager defaultManager] removeItemAtPath: dir error: nil]){
				NSLog(@"I'm can't delete not using a files from the bookmarks (%@)", dir);
			}
		}
	}
}

//! Возвращает по ресурсу url дату сохраненного в кеше файла
- (NSDate *) getDateBxDownloadOldFileCasher: (NSString *) url
{
	NSString * path1 = [[self.cashSearch objectForKey: url] objectForKey: @"path"];
	NSError * error = nil;
	NSDictionary * attr1 = [[NSFileManager defaultManager]
							attributesOfItemAtPath: [self.currentDirPath stringByAppendingPathComponent: path1]
							error: &error];
	if (error) {
		NSLog(@"ERROR!!! %@", error);
	}
	return [attr1 objectForKey:NSFileModificationDate];
}

// украл
//! Производит очистку из избранное каталогов и файлов, относящихся к удаленным закладкам
- (void) clean {
	if (deletePoolCount > _maxCashCount)
		[NSException raise: @"NotCorrectDefinitionException" format: @"DownloadCash: неверно заданы deletePoolCount и maxCashCount"];
	if (_cashSearch.count < _maxCashCount){
		[self cleanDir];
		return;
	}
	NSArray * paths = [_cashSearch allKeys];
	[_cashUpdatingLock lock];
	NSMutableArray * sortedPaths = [NSMutableArray arrayWithArray: paths];
    //! Сравнение ресурсов по времени сохранения в кеше
    [sortedPaths sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate * date1 = [self getDateBxDownloadOldFileCasher: obj1];
        NSDate * date2 = [self getDateBxDownloadOldFileCasher: obj2];
        return [date1 compare: date2];
    }];
	int deleteCount = (int)_cashSearch.count - _maxCashCount + deletePoolCount;
	for (int i = 0; i < deleteCount; i++){
		[_cashSearch removeObjectForKey: [sortedPaths objectAtIndex: i]];
	}
	[self cleanDir];
	[_cashUpdatingLock unlock];
}

- (BOOL) isEmpty
{
	return _cashSearch.count == 0;
}

+ (BOOL) isErrorConnectionFrom: (NSInteger)errorCode
{
	return (errorCode == NSURLErrorNotConnectedToInternet);
    //[[self defaultCasher] isEmpty]; wath is it?
}

//! украл
- (void) cleanAndSave{
	[_cashUpdatingLock lock];
	[self clean];
	[self save];
	[_cashUpdatingLock unlock];
}

- (void)dealloc {
	[self cleanAndSave];
	[_cashUpdatingLock autorelease];
    _cashUpdatingLock = nil;
	[_mainLock autorelease];
    _mainLock = nil;
	self.cashSearch = nil;
	[_currentFilePath autorelease];
    _currentFilePath = nil;
	[_currentDirPath autorelease];
    _currentDirPath = nil;
	[_dateFormatter autorelease];
    _dateFormatter = nil;
	self.extention = nil;
    [_parser autorelease];
    _parser = nil;
    self.streamSaver = nil;
    [super dealloc];
}

@end

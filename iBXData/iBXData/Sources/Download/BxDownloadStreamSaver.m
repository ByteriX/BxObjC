/**
 *	@file BxDownloadStreamSaver.m
 *	@namespace iBXData
 *
 *	@details Провайдер загрузки из Веб-сервиса в файл определенных данных
 *	@date 23.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadStreamSaver.h"
#import "BxCommon.h"
#import "BxData.h"

@implementation BxDownloadStreamSaver

- (instancetype) init
{
    self = [super init];
    if (self){
        self.request = [[NSMutableURLRequest new] autorelease];
        self.request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.request.timeoutInterval = 60.0;
    }
    return self;
}

/**
 *	@brief кодировка всех страничек, к сожалению она должна настриваться статически
 *
 *	по идеи достаточет NSASCIIStringEncoding для извлечения пути, но надо еще корректно сохранить данные в файл
 *	так что лучше сделать так чтобы кодировка определялась автоматически
 */
static NSStringEncoding _defaultEncoding = NSUTF8StringEncoding;

/**
 *	@brief Массив расширений (в тексте) который требуется извлекать и
 *	сохранять как внутренние ссылки вложенных страниц в основную
 *
 *	@remarks используйте вместо него @ref getExpotingHTMLContent
 */
static NSArray * _selectedExpotingHTMLContentExtentions = nil;

static float htmlProgressMaxValue = 0.3;

/**
 *	@brief инкапсулирует и обеспечивает доступ к списку расширений, сохраняемых ресурсов
 *
 *	@remarks Расширения типов сохраняемых ресурсов должны заканчиваться ковычками
 */
- (NSArray *) getExpotingHTMLContent{
	if (!_selectedExpotingHTMLContentExtentions){
		_selectedExpotingHTMLContentExtentions = [[NSArray alloc] initWithObjects:
												  @".css\"", @".jpg\"", @".jpeg\"", @".png\"", @".gif\"", @"/\""
												  /*, @".htm\"", @"html\""*/, nil];
	}
	return _selectedExpotingHTMLContentExtentions;
}

/**
 *	@brief Метод сохраняет в указанный каталог ресурсы,
 *
 *	содержащиеся в HTML для указанных типов ресурсов в (@ref getExpotingHTMLContent).
 *	При этом сохраняются все относительные пути в соответствующие каталоги для path.
 */
- (void) saveContentFrom: (NSString**)html to: (NSString*)path rootUrl:(NSString*)rootUrl
				delegate: (id<BxDownloadProgress>) delegate containingLevel: (int) containingLevel
{
	NSArray * expotingHTMLContent = [self getExpotingHTMLContent];
	// недостаток: не кешируются уже найденые объекты (на странице их может быть несколько,
	// но каждая будет загружаться отдельно и сохроняться в отдельный файл,
	// хотя представляет собой одно и тоже)
	for (int i = 0; i < expotingHTMLContent.count; i++) // проход по всем типам ресурсов
	{
		NSRange startRange;
		startRange.location = 0;
		NSRange endRange;
		endRange.length = 0;
		do{
			// Ищим ресурсы текущего типа
			NSUInteger symbolCount = [*html length];
			startRange.length = symbolCount - startRange.location;
			endRange = [*html rangeOfString: [expotingHTMLContent objectAtIndex:i]
									options: NSCaseInsensitiveSearch range: startRange];
			NSRange beginRange, range;
			if (endRange.length > 0){ // ресурс обнаружен, далее ищим начало - ковычку
				range.location = startRange.location;
				range.length = endRange.location - startRange.location - 1;
				beginRange = [*html rangeOfString: @"\""
										  options: NSBackwardsSearch range: range];
				if (beginRange.length > 0){ // с ковычки должен начинаться искомая ссылка на ресурс данного типа
					range.location = beginRange.location + 1;
					range.length = endRange.location - beginRange.location + endRange.length - 2;
					// Получаем путь на сервере (относительный) и сохраняем
					NSString* relativePath = [*html substringWithRange: range];
                    
					NSString* newPath = nil;
					NSString* url = relativePath;
					@try {
						newPath = [self saveFrom: url to: path delegate: delegate containingLevel: containingLevel]; // обращаемся сначало через относительный путь
					} @catch (BxDownloadStreamException * e) {
						// игнорируем пока есть способы получить содержание ресурса другим способом (игнор)
					}
					// через относительный путь не удалось получить доступ то делаем абсолютным путь:
					if (!newPath){
						NSURL* currentURL = [NSURL URLWithString: rootUrl];
						NSString * hostURL = [currentURL host];
						if (![currentURL isFileURL]){
							url = @"http://";
							url = [url stringByAppendingString: hostURL]; // использование PathComponent вредит урлам
							url = [url stringByAppendingString: relativePath];
							@try {
								newPath = [self saveFrom: url to: path delegate: delegate containingLevel: containingLevel]; // обращаемся через абсолютный путь
							}
							@catch (BxDownloadStreamException * e) {
								// (игнор)
							}
						}
						if (!newPath){ // Если не удалось обратится через абсолютный путь, остается только через локальный...
							url = @"file://";
							url = [url stringByAppendingString: hostURL]; // использование PathComponent вредит урлам
							url = [url stringByAppendingString: relativePath];
							@try {
								newPath = [self saveFrom: url to: path delegate: delegate containingLevel: containingLevel];
							}
							@catch (BxDownloadStreamException * e) {
								// (игнор)
							}
							if (!newPath){
								url = [rootUrl stringByAppendingPathComponent: relativePath]; // использование PathComponent вредит урлам
                                @try {
                                    newPath = [self saveFrom: url to: path delegate: delegate containingLevel: containingLevel];
                                }
                                @catch (BxDownloadStreamException * e) {
                                    // (игнор)
                                }
								if (!newPath){
                                    url = [rootUrl substringToIndex: rootUrl.length - [rootUrl lastPathComponent].length];
                                    url = [url stringByAppendingString: relativePath]; // использование PathComponent вредит урлам
                                    @try {
                                        newPath = [self saveFrom: url to: path delegate: delegate containingLevel: containingLevel];
                                    }
                                    @catch (BxDownloadStreamException * e) {
                                        // (игнор)
                                    }
                                }
							}
						}
					}
					startRange.location = range.location;
					// Если ресурс был скачен, то в html необходимо подменить путь к нему иначе искать следующее положение ресурса
					if (newPath)
					{
						newPath = [newPath lastPathComponent];
						*html = [*html stringByReplacingCharactersInRange: range withString: newPath];
						startRange.location += [newPath length];
					} else{
						startRange.location += [url length];
					}
				} else{
					startRange.location = endRange.location + endRange.length;
				}
			}
		} while (endRange.length > 0); // пока есть надежда что найдем еще похожий ресурс
		//
	}
}

- (NSString*) saveFrom: (NSString*)url to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
				   ext: (NSString *) ext
{
    return [self saveFrom: url to: path delegate: delegate ext: ext containingLevel: 0];
}

- (NSString*) saveFrom: (NSString*)url to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
				   ext: (NSString *) ext
       containingLevel: (int) containingLevel
{
	return [self saveFrom: url to: path delegate: delegate ext: ext isContaining: YES containingLevel: containingLevel];
}

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
				   ext: (NSString *) ext
          isContaining: (BOOL) isContaining
       containingLevel: (int) containingLevel
{
	if ((!ext) || ext.length < 1) {
		return [self saveFrom: url to: path delegate: delegate];
	}
	if (isContaining) {
		isContaining = [ext isEqualToString: @"html"] || [ext isEqualToString: @"htm"];
	}
	// считываем содержимое головного файла
    NSMutableURLRequest * request = [[self.request copy] autorelease];
    request.URL = [NSURL URLWithString: url];
	NSData * data = [BxDownloadStream loadFromRequest: request maxProgress: isContaining ? htmlProgressMaxValue : 1.0f
                                         delegate: delegate];
	if (!data)
		return nil;
	
	// В случае html подобных данных - сохраняем их с заданной кодировкой
	if (isContaining && containingLevel < 1){
        // определяем содержимую кодировку
        NSString * contentHTML = [[NSString alloc] initWithData: data
                                                       encoding: NSASCIIStringEncoding];
        NSStringEncoding encoding = _defaultEncoding;
        @try {
            NSRange range = [[contentHTML lowercaseString] rangeOfString: @"charset="];
            if (range.length > 0) {
                NSUInteger valueLength = MIN(256, contentHTML.length - range.location - range.length);
                NSString * substring = [contentHTML substringWithRange: NSMakeRange(range.location + range.length, valueLength)];
                range = [substring rangeOfString: @"\""];
                if (range.length > 0) {
                    substring = [substring substringToIndex: range.location];
                    encoding = [substring encodingFromEncodingName];
                }
            }
        }
        @finally {
            [contentHTML release];
        }
        
        
		NSString * html = [[[NSString alloc]
							initWithData:data encoding: encoding] autorelease];
		[self saveContentFrom: &html to: path rootUrl: url delegate: delegate containingLevel:containingLevel + 1]; // сохраняем все содержимое основного ресурса (рекурсивно)
		data = [html dataUsingEncoding: encoding];
	}
	// ищем незанятое подходящее имя
	NSString * filePath = [BxFileSystem getNewFilePathWith:path name:@"bookmark" ext: ext];
	// сохраняем ресурс
	if ([data writeToFile: filePath options: NSAtomicWrite error: nil])
		return filePath;
	else
		return nil;
}

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
{
	return [self saveFrom: url to: path delegate: delegate isContaining: YES containingLevel: 0];
}

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
       containingLevel: (int) containingLevel;
{
	return [self saveFrom: url to: path delegate: delegate isContaining: YES containingLevel: containingLevel];
}

- (NSString*) saveFrom: (NSString*)url
					to: (NSString*)path
			  delegate: (id<BxDownloadProgress>) delegate
          isContaining: (BOOL) isContaining
       containingLevel: (int) containingLevel
{
	// определение формата и загрузки
	NSString * ext = [url pathExtension];
	if (isContaining){
		isContaining = (!ext) || [ext isEqualToString: @""] || [ext isEqualToString: @"html"] || [ext isEqualToString: @"htm"];
		if (isContaining){
			ext = @"html";
		}
		if (ext.length > 16) {
			ext = @"dat";
		}
	}
	return [self saveFrom: url to: path delegate: delegate ext: ext isContaining: isContaining containingLevel: containingLevel];
}

- (void) dealloc
{
    self.request = nil;
    [super dealloc];
}

@end

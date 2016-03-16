/**
 *	@file BxRssDataParser.m
 *	@namespace iBXData
 *
 *	@details RSS сериализатор/дисериализатор
 *	@date 09.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxRssDataParser.h"

@interface BxRssDataParser ()
{
@protected
    dispatch_semaphore_t semaphore;
}

//! объект распарсивания XML данных
@property (nonatomic, retain) NSXMLParser * xmlParser;
@property (nonatomic, retain) NSMutableDictionary * root;
//! текущая строка данных
@property (nonatomic, retain) NSMutableDictionary * item;
//! Текущий при парсинге элемент, чтобы заключить его в название поля
@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic, retain) NSString * tagName;

//! Служебная информация
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * descriptionRSS;

//!
@property (nonatomic, retain) NSException * exception;

@end

@implementation BxRssDataParser

//! @overload
- (NSDictionary*) dataFromData: (NSData*) data
{
    self.exception = nil;
    self.title = nil;
    self.url = nil;
    self.descriptionRSS = nil;
	self.root = nil;
    
    // тут на мой взгляд странное определение кодировки
    NSString * inStr = [[[NSString alloc] initWithData:data encoding:NSWindowsCP1251StringEncoding] autorelease];
    NSString * outStr = [inStr stringByReplacingOccurrencesOfString: @"encoding=\"windows-1251\"" withString:@"" options:NSCaseInsensitiveSearch range: NSMakeRange(0, inStr.length)];
    if (inStr.length > outStr.length) {
        data = [outStr dataUsingEncoding: NSUTF8StringEncoding];
    }
    
	self.xmlParser = [[[NSXMLParser alloc] initWithData: data] autorelease];
	self.xmlParser.delegate = self;
    
    semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.xmlParser parse];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (semaphore) {
        dispatch_release(semaphore);
        semaphore = nil;
    }
    
    if (self.exception) {
        @throw self.exception;
    }
    
	return self.root;
}

//- (void) fixedError

- (void) cleanup
{
	self.item = nil;
	self.currentElement = nil;
	self.root = nil;
}

- (void) stop
{
	dispatch_semaphore_signal(semaphore);
    //[self cleanup];
}

#pragma mark NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"[parser] found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	[self.xmlParser abortParsing];
	NSLog(@"[parser] Error while XML parsing feed!");
	NSLog(@"[parser] Error code: %li", (long)[parseError code]);
	NSLog(@"[parser] Error description: %@", [parseError localizedDescription]);
    self.exception = [BxParserException exceptionWith: parseError];
	[self stop];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	// Определяем новый тег (поле)
	self.currentElement = elementName;
	if ([elementName isEqualToString:@"item"]) // Это условие открытия новой строки данных
	{
		NSLog(@"[parser] start new item parse");
		NSMutableDictionary * newItem = [[NSMutableDictionary alloc] initWithDictionary: attributeDict];
		self.item = newItem;
		[newItem release];
		//[self incProgress: 0.02];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"item"]) {
        if (!self.root) {
            self.root = [NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity: 16] forKey: @"items"];
        }
		[[self.root objectForKey: @"items"] addObject: self.item]; // текущий элемент вставляем в набор данных как новую строку
	} else {
		self.currentElement = @""; // для того чтобы не нацеплять после окончания строки данных символов!
	}
}

-(NSDictionary *) registredTagNames
{
    return @{
             @"title" : @"title",
             @"link" : @"link",
             @"description" : @"description",
             @"category" : @"category",
             @"pubDate" : @"pubDate",
             @"author" : @"author",
             @"thumb" : @"thumb"
             };
}

- (void) addContent: (NSString *)string forTag: (NSString*) localtagName
{
    NSMutableString * currentContent = [self.item objectForKey: localtagName];
    if (currentContent) {// существующее поле дополняем, не найденое добавляем!
        [currentContent appendString:string];
    } else {
        NSMutableString * newString = [[NSMutableString alloc] initWithString: string];
        [self.item setObject: newString forKey: localtagName ];
        [newString release];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!self.item) // это возможно при чтении атрибутов в начале RSS данных
    {
        if (self.currentElement) {
            if ([self.currentElement isEqualToString: @"title"]) {
                self.title = string;
            } else if ([self.currentElement isEqualToString: @"link"]) {
                self.url = string;
            } else if ([self.currentElement isEqualToString: @"description"]) {
                self.descriptionRSS = string;
            }
        }
		return;
    }
    // определяем выходной тег и если он зарегестрирован в потомке то добавляем как поле текущей строки данных:
    NSString * localtagName = [[self registredTagNames] objectForKey: self.currentElement];
	if (localtagName){
        [self addContent: string forTag: localtagName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"[parser] all done!");
	// мы загрузились обязательно даем знать предку и хотим освободить ресурсы:
	[self stop];
}

- (void) dealloc
{
    if (semaphore) {
        dispatch_release(semaphore);
        semaphore = nil;
    }
    self.exception = nil;
    self.title = nil;
    self.url = nil;
    self.descriptionRSS = nil;
	[self cleanup]; // на всякий случай освободим все ресурсы еще раз
    self.xmlParser.delegate = nil;
	self.xmlParser = nil;
	[super dealloc];
}

@end

/**
 *	@file BxFileDataSet.m
 *	@namespace iBXData
 *
 *	@details Хранилище данных, загруженных из локального файла
 *	@date 04.05.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxFileDataSet.h"

@interface BxFileDataSet ()

@property (nonatomic, strong) BxAbstractDataParser * parser;

@end

@implementation BxFileDataSet

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
{
    self = [super initWithTarget: target];
	if ( self ){
		self.parser = parser;
	}
	return self;
}

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
             fileName: (NSString*) fileName
{
    self = [self initWithTarget: target parser: parser];
	if ( self ){
		self.fileName = fileName;
	}
	return self;
}

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
     resourceFileName: (NSString*) resourceFileName
{
    self = [self initWithTarget: target parser: parser];
	if ( self ){
		self.fileName = [[NSBundle mainBundle] pathForResource: [resourceFileName stringByDeletingPathExtension]
                                                        ofType: [resourceFileName pathExtension]];
	}
	return self;
}

//! @override
- (NSDictionary *) loadData
{
    if (!_parser) {
        [BxException raise: @"NotDefinedException" format: @"Не установлен парсер для набора данных"];
    }
    
    NSLog(@"Load from resource file: %@", _fileName);
    
    if (!_fileName || ![[NSFileManager defaultManager] fileExistsAtPath: _fileName]) {
        [BxException raise: @"NotDefinedException" format: @"Не найден файл ресурсов для набора данных"];
    }

	NSDictionary * result = [_parser loadFromFile: _fileName];
	
	//NSLog(@"%@", result);
	return result;
}

@end

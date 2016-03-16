/**
 *	@file BxFileDataSet.h
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

#import "BxAbstractDataSet.h"
#import "BxAbstractDataParser.h"

//! Хранилище данных, загруженных из локального файла
@interface BxFileDataSet : BxAbstractDataSet
{
}

@property (nonatomic, strong) NSString * fileName;

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser;

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
             fileName: (NSString*) fileName;

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
			   parser: (BxAbstractDataParser*) parser
     resourceFileName: (NSString*) resourceFileName;

@end

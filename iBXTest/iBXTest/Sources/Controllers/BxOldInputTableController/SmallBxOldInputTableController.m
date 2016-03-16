//
//  SmallBxOldInputTableController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 12/9/13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "SmallBxOldInputTableController.h"

@interface SmallBxOldInputTableController ()

@end

@implementation SmallBxOldInputTableController

- (NSArray*) emptyTableInfo
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    UIView * fother = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 136)];
    NSMutableDictionary * sec0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            header, FNInputTableHeader,
            [NSArray arrayWithObjects:
                    [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                                                       @"area1", FNInputTableRowFieldName, nil],
                            [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                                                               @"area2", FNInputTableRowFieldName, nil],
                            [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                                                               @"area3", FNInputTableRowFieldName, nil],
                            [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                                                               @"area4", FNInputTableRowFieldName,
                                            @[@{@"name":@"name", @"value":@"value"}], FNInputTableRowVariants, nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                                                       @"area5", FNInputTableRowFieldName,
                                    @[@{@"name":@"name", @"value":@"value"}], FNInputTableRowVariants, nil],
                            nil
            ], FNInputTableRows,
                    nil];
	NSMutableDictionary * sec = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  [NSArray arrayWithObjects:
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Город", FNInputTableRowHint,
                                    @"Самара", FNInputTableRowValue,
                                    @"city",  FNInputTableRowFieldName, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint,
                                    @"area", FNInputTableRowFieldName, @YES, FNInputTableRowIsSecurity, nil],
								   nil
								   ], FNInputTableRows,
                    fother, FNInputTableFooter,
								  nil];
	return [NSArray arrayWithObjects: sec0, sec, nil];
}

@end

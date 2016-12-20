/**
 *	@file BxOldInputTableController.m
 *	@namespace iBXVcl
 *
 *	@details Устаревшый контроллер табличного ввода
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxOldInputTableController.h"
#import "BxCommon.h"
#import "UIViewController+BxVcl.h"
#import "BxAppearance.h"

const NSString * const FNInputTableHeader = @"header";
const NSString * const FNInputTableFooter = @"footer";
const NSString * const FNInputTableRows = @"rows";
const NSString * const FNInputTableRowHint = @"hint";
const NSString * const FNInputTableRowValue = @"value";
const NSString * const FNInputTableRowFieldName = @"fieldName";
const NSString * const FNInputTableRowIsSecurity = @"isSecurity";
const NSString * const FNInputTableRowIsAction = @"isAction";
const NSString * const FNInputTableRowIsEnabled = @"isEnabled";
const NSString * const FNInputTableRowIsSwitch = @"isSwitch";
const NSString * const FNInputTableRowAccessoryView = @"accessoryView";

const NSString * const FNInputTableRowVariants = @"variants";
const NSString * const FNInputTableRowVariantNullTitle = @"variantNullTitle";
const NSString * const FNInputTableRowVariantIsNullSelected = @"variantIsNullSelected";
const NSString * const FNInputTableRowIsDatePicker = @"isDatePicker";
const NSString * const FNInputTableRowSubtitle = @"Subtitle";
const NSString * const FNInputTableRowPlaceholder = @"placeholder";
const NSString * const FNInputTableRowMaxSymbolsCount = @"maxSymbolsCount";
const NSString * const FNInputTableRowMaxChecksCount = @"maxChecksCount";
const NSString * const FNInputTableRowIcon = @"icon";
// число из UIKeyboardType
const NSString * const FNInputTableRowKeyboardType = @"keyboardType";

@interface BxOldInputTableController ()

@property (nonatomic, retain) NSIndexPath * indexPathForSelectedCell;
@property (nonatomic, retain) NSMutableArray* cellData;

+ (void) setValue: (id) value fromFieldName: (NSString*) fieldName toInfo: (NSArray*) result;

+ (BOOL) isBooleanRow: (NSDictionary*) row;

+ (NSMutableDictionary*) getDataFromFieldName: (NSString*) fieldName toInfo: (NSArray*) result;

- (void) scrollDidLoad;
- (void) becomeNext;
- (void) updateTextInputFromName: (NSString*) fieldName;
- (void) checkRowKeyboardType: (NSDictionary*) row;
- (void) checkNext;
- (void) updateTextInputViewWithData:(NSDictionary *) data;
- (void) tableView:(UITableView *)tableView scrollToRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL) getEnabled;
- (BOOL) isYESRow: (NSDictionary*) row fieldName: (const NSString * const) fieldName;
- (BOOL) clickRow: (NSDictionary*) row indexPath:(NSIndexPath *)indexPath;

- (CGFloat) cellHeight;

- (CGRect) headerRectFrom: (CGRect) rect;

@end

@implementation BxOldInputTableController

//@synthesize info, currentElement;
//@synthesize indexPathForSelectedCell;

+ (id) appearance
{
    return [BxAppearance appearanceForClass:[self class]];
}

+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION
{
    return [self appearance];
}

- (void) initObject
{
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setLocale: [[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"] autorelease]];
    [self.dateFormatter setFormatterBehavior: NSDateFormatterBehavior10_4];
    [self.dateFormatter setDateFormat:  @"dd.MM.yyyy"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self initObject];
    }
    return self;
}

#pragma mark - class methods

+ (UIFont *) getTitleFont
{
    return [UIFont boldSystemFontOfSize:15.0f];
}

+ (UIFont *) getSubtitleFont
{
    return [UIFont systemFontOfSize:12.0f];
}

+ (UIFont *) getValueFont
{
    return [UIFont systemFontOfSize:15.0f];
}

- (UIFont*) getValueFont
{
    if (self.valueFont) {
        return self.valueFont;
    }
    return [self.class getValueFont];
}

+ (NSMutableDictionary*) getDataFromFieldName: (NSString*) fieldName toInfo: (NSArray*) result
{
    for (NSDictionary * section in result) {
        NSArray * values = [section objectForKey: FNInputTableRows];
        for (NSMutableDictionary * row in values) {
            NSString * name = [row objectForKey: FNInputTableRowFieldName];
            if (name && [name isEqualToString: fieldName]) {
                return row;
            }
        }
    }
    return nil;
}

+ (BOOL) isBooleanRow: (NSDictionary*) row
{
    if (row) {
        NSObject * value = [row objectForKey: FNInputTableRowValue];
        if (value && [value isKindOfClass: NSNumber.class]) {
            return YES;
        }
    }
    return NO;
}

+ (NSIndexPath*) getEmptyIndexFromTableInfo: (NSArray*) tableInfo
{
	for (int section = 0; section < tableInfo.count; section++) {
		NSDictionary * sectionInfo = [tableInfo objectAtIndex: section];
		NSArray * rows = [sectionInfo objectForKey: FNInputTableRows];
		for (int row = 0; row < rows.count; row++) {
			NSDictionary * data = [rows objectAtIndex: row];
            if (![self isBooleanRow: data]) {
                if (![data objectForKey: FNInputTableRowValue]) {
                    return [NSIndexPath indexPathForRow: row inSection: section];
                }
            }
			
		}
	}
	return nil;
}

+ (NSIndexPath*) getIndexFromFieldName: (NSString*) fieldName tableInfo: (NSArray*) tableInfo
{
	for (int section = 0; section < tableInfo.count; section++) {
		NSDictionary * sectionInfo = [tableInfo objectAtIndex: section];
		NSArray * rows = [sectionInfo objectForKey: FNInputTableRows];
		for (int row = 0; row < rows.count; row++) {
			NSDictionary * data = [rows objectAtIndex: row];
            NSString * name = data[FNInputTableRowFieldName];
            if (name && [name isEqualToString: fieldName]) {
                return [NSIndexPath indexPathForRow: row inSection: section];
            }
		}
	}
	return nil;
}

+ (void) setTableInfo: (NSArray*) tableInfo name: (const NSString* const) name value: (id) value
{
	for (NSDictionary * section in tableInfo) {
		NSArray * rows = [section objectForKey: FNInputTableRows];
		for (NSMutableDictionary * row in rows) {
			if ([name isEqualToString: [row objectForKey: FNInputTableRowFieldName]]) {
				[row setObject: value forKey: FNInputTableRowValue];
				return;
			}
		}
	}
    [BxException raise: @"NotFoundException"
                format: @"The data from TableInfo is not found (fieldName = %@, tableInfo = %@)", name, tableInfo, nil];
}

+ (void) setTableInfo: (NSArray*) tableInfo name: (const NSString* const) name fromData: (NSDictionary*) data
{
	id value = [data objectForKey: name];
	if (value) {
		[self setTableInfo: tableInfo name: name value: value];
	}
}

+ (void) setValue: (id) value fromFieldName: (NSString*) fieldName toInfo: (NSArray*) result
{
    NSMutableDictionary* row = [self getDataFromFieldName: fieldName toInfo: result];
    if (row) {
        if (value) {
            [row setObject: value forKey: FNInputTableRowValue];
        } else {
            [row removeObjectForKey: FNInputTableRowValue];
        }
    }
}

#pragma mark -

- (UIResponder*) keyBoardSource
{
	return _textInput;
}

- (void)scrollDidLoad 
{
    CGFloat nextPosition = _mainTable.frame.origin.y + _mainTable.frame.size.height;
	_mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, nextPosition);
}

- (void) updateKeyboardTypeWithFieldName: (NSString*) fieldName
{
    //
}

- (BOOL) isNeedShowKeyboardInputAccessoryView
{
    return YES;
}

- (BOOL) isNeedShowKeyboardNextButton
{
    return NO;
}

- (UIView *) keyboardInputAccessoryView
{
    if (![self isNeedShowKeyboardInputAccessoryView]) {
        return nil;
    }
    UIToolbar * result = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    result.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem * btDone = [[UIBarButtonItem alloc] initWithTitle: BxCommonLocalString(@"InputTableDone", @"Done")
                                                                style: UIBarButtonItemStyleDone 
                                                               target: self 
                                                               action: @selector(btDoneClick)];
    NSArray * segmentedItems = [NSArray arrayWithObjects: BxCommonLocalString(@"InputTableBack", @"Back"), BxCommonLocalString(@"InputTableNext", @"Next"), nil];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems: segmentedItems];
    segmentedControl.frame = CGRectMake(0.0f, 0.0f, 140.0f, 30.0f);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    [segmentedControl addTarget: self action: @selector(changePosition:) forControlEvents: UIControlEventValueChanged];
    
    UIBarButtonItem * segmentedItem = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
    [segmentedControl release];
    
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace 
                                                                                    target: nil 
                                                                                    action: nil];
    NSArray * toolbarItems = [NSArray arrayWithObjects: segmentedItem, flexibleSpace, btDone, nil];
    [segmentedItem release];
    [flexibleSpace release];
    [btDone release];
    result.items = toolbarItems;
    
    int itemsCount = 0;
    for (int section = 0; section < [self numberOfSectionsInTableView:_mainTable]; section++) {
        itemsCount += [self tableView:_mainTable numberOfRowsInSection:section];
    }
    
    if(itemsCount < 2) {
        segmentedControl.hidden = YES;
    }
    
    return [result autorelease];
}

- (NSIndexPath *) firstIndexPath
{
    for (int section = 0; section < [self numberOfSectionsInTableView: _mainTable]; section++) {
        if ([self tableView: _mainTable numberOfRowsInSection:section] > 0) {
            return [NSIndexPath indexPathForRow: 0 inSection: section];
        }
    }
    return nil;
}

//!  delta = 1/-1, другие значения не допустимы
- (NSIndexPath *) getShiftIndexPath: (NSIndexPath *) indexPath delta: (int) delta
{
    if (indexPath) {
        NSInteger rowIndex = indexPath.row;
        NSInteger section = indexPath.section;
        while (section >= 0 && section <  [self numberOfSectionsInTableView: _mainTable]) {
            rowIndex += delta;
            if (rowIndex >= 0 && rowIndex < [self tableView: _mainTable numberOfRowsInSection:section]){
                NSIndexPath * result = [NSIndexPath indexPathForRow: rowIndex inSection: section];
                NSDictionary * row = [self getRowDataFrom: result];
                if ([self getEnabledFromRow: row] && [self isKeyboardedRow: row]){
                    return result;
                } else {
                    continue;
                }
            }
            // сбрасываем счетчики:
            section+= delta;
            if (section >= 0 && section <  [self numberOfSectionsInTableView: _mainTable]){
                if (delta > 0){
                    rowIndex = -1;
                } else {
                    rowIndex = [self tableView: _mainTable numberOfRowsInSection:section];
                }
            }

        }
        return nil;
    } else {
        return [self firstIndexPath];
    }
    return nil;
}

- (BOOL) isKeyboardedRow: (NSDictionary *) row
{
    if ([self isYESRow: row fieldName: FNInputTableRowIsAction] ||
        [self isYESRow: row fieldName: FNInputTableRowIsSwitch])
    {
        return NO;
    }
    if ([self.class isBooleanRow: row]){
        return NO;
    }
    return YES;
}

- (void) changePosition:(UISegmentedControl *) control
{
    NSIndexPath * indexPath;
    if (control.selectedSegmentIndex == 0) {
        indexPath = [self getShiftIndexPath: _indexPathForSelectedCell delta: -1];
    } else {
        indexPath = [self getShiftIndexPath: _indexPathForSelectedCell delta: 1];
    }
    if (indexPath && [self isKeyboardedRow: [self getRowDataFrom: indexPath]]) {
        [self tableView: _mainTable didSelectRowAtIndexPath: indexPath];
    } else {
        [_textInput resignFirstResponder];
    }
}

- (void) btDoneClick
{
    [_textInput resignFirstResponder];
}

- (void) changeDate
{
    NSString * value = [_dateFormatter stringFromDate: _datePicker.date];
    [self.class setValue: value fromFieldName: _currentFieldName toInfo: _info];
    [self didChangedValue: value fromFieldName: _currentFieldName];
    _textInput.text = value;
    [self updateValues];
}

- (UIColor*) backgroundColor
{
    return [UIColor clearColor];
}

- (NSArray*) emptyTableInfo
{
    UIButton * button = [[[UIButton alloc] initWithFrame: CGRectMake(10, 10, 300, 30)] autorelease];
    button.backgroundColor = [UIColor blueColor];
    button.layer.cornerRadius = 3;
    button.tintColor = [UIColor blueColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitle: @"Кнопка для нажатия" forState: UIControlStateNormal];
    [button addTarget: self action: @selector(btDoneClick) forControlEvents: UIControlEventTouchUpInside];
    UIView * buttonView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 50)] autorelease];
    [buttonView addSubview: button];
    
    NSMutableDictionary * sec0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  [NSArray arrayWithObjects:
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Первое поле ввода", FNInputTableRowHint,
                                    @"Первое значение", FNInputTableRowValue, @"first_field",  FNInputTableRowFieldName, nil], nil], FNInputTableRows, nil];
                                   
	NSMutableDictionary * sec1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  @"Первая секция", FNInputTableHeader,
								  [NSArray arrayWithObjects: 
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Коментарий", FNInputTableRowHint, 
                                    @"comment", FNInputTableRowFieldName,
                                    [NSNumber numberWithBool: NO], FNInputTableRowValue, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Чекинг", FNInputTableRowHint, 
                                    @"check", FNInputTableRowFieldName, [NSNumber numberWithBool: YES], FNInputTableRowValue, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Кликни сюда - в самую длинную строчку, чтобы все м видно было, что мы тут не просто штаны протераем", FNInputTableRowHint, 
                                    @"Значение", FNInputTableRowFieldName, [NSNumber numberWithBool: NO], FNInputTableRowValue, nil],
								   nil
								   ], FNInputTableRows, 
                                  buttonView, FNInputTableFooter,
								  nil];
	NSMutableDictionary * sec2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  @"Адрес дефекта", FNInputTableHeader,
								  [NSArray arrayWithObjects: 
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Город", FNInputTableRowHint,
                                    @"Samara", FNInputTableRowPlaceholder,
                                    @"Самара", FNInputTableRowValue,
                                    @NO, FNInputTableRowIsEnabled,
                                    @"city",  FNInputTableRowFieldName, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Район", FNInputTableRowHint, 
                                    @"area", FNInputTableRowFieldName, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Улица", FNInputTableRowHint, 
                                    @"street", FNInputTableRowFieldName, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Дом", FNInputTableRowHint, 
                                    @"home", FNInputTableRowFieldName, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Пароль", FNInputTableRowHint, 
                                    @"password", FNInputTableRowFieldName, [NSNumber numberWithBool: YES], FNInputTableRowIsSecurity, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Дата рождения", FNInputTableRowHint,
                                    @"birthday", FNInputTableRowFieldName, @YES, FNInputTableRowIsDatePicker, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                    @"Переход", FNInputTableRowHint,
                                    @NO, FNInputTableRowIsEnabled,
                                    @"Переход на страницу", FNInputTableRowValue,
                                    @"transport", FNInputTableRowFieldName, 
                                    [NSNumber numberWithBool: YES], FNInputTableRowIsAction,
                                    nil],
								   nil
								   ], FNInputTableRows,
								  @"Эти данные будут обработанны и представлены в виде нескольких строчек", FNInputTableFooter,
								  nil];
    
    NSMutableDictionary * sec3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  @"Различные комбинации контролов", FNInputTableHeader,
								  [NSArray arrayWithObjects:
								   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"Это одна из иконок", FNInputTableRowHint,
                                    @"Не имеет значения", FNInputTableRowValue,
                                    @"testicon1", FNInputTableRowIcon,
                                    @"testicon1",  FNInputTableRowFieldName, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"С кнопочкой, текст (тоже длинный - так, на всякий случай)", FNInputTableRowHint,
                                    @YES, FNInputTableRowIsSwitch,
                                    @YES, FNInputTableRowValue,
                                    @"testicon2", FNInputTableRowIcon,
                                    @"testicon2",  FNInputTableRowFieldName, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"Имеет очень очень длинное название, хоть плачь и стой и смейся", FNInputTableRowHint,
                                    @"Значение тоже очень длинное, непомерно", FNInputTableRowValue,
                                    [UIImage imageNamed: @"testicon3"], FNInputTableRowIcon,
                                    @"testicon3",  FNInputTableRowFieldName, nil],
								   nil
								   ], FNInputTableRows,
								  nil];
    NSMutableDictionary * sec4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @2, FNInputTableRowMaxChecksCount,
								  @"Можно выбрать 2", FNInputTableHeader,
								  [NSArray arrayWithObjects:
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Первый", FNInputTableRowHint,
                                    @"Первый", FNInputTableRowFieldName,
                                    [NSNumber numberWithBool: NO], FNInputTableRowValue, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Второй", FNInputTableRowHint,
                                    @"Второй", FNInputTableRowFieldName, [NSNumber numberWithBool: YES], FNInputTableRowValue, nil],
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Третий", FNInputTableRowHint,
                                    @"Третий", FNInputTableRowFieldName, [NSNumber numberWithBool: NO], FNInputTableRowValue, nil],
								   nil
								   ], FNInputTableRows,
								  nil];

    NSMutableDictionary * sec5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @2, FNInputTableRowMaxChecksCount,
            @"Кастомный выбор", FNInputTableHeader,
            [NSArray arrayWithObjects:
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Кнопка - текст", FNInputTableRowHint,
                                    @YES, FNInputTableRowIsSwitch,
                                    @YES, FNInputTableRowValue,
                            @"testicon4", FNInputTableRowIcon,
                            @"button1",  FNInputTableRowFieldName, nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Кнопка без иконки", FNInputTableRowHint,
                                    @YES, FNInputTableRowIsSwitch,
                                    @YES, FNInputTableRowValue,
                            @"button2",  FNInputTableRowFieldName, nil],
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"Нет иконки", FNInputTableRowHint,
                                    @YES, FNInputTableRowIsSwitch,
                                    @YES, FNInputTableRowValue,
                            @"button3",  FNInputTableRowFieldName, nil],
                            nil
            ], FNInputTableRows,
                    nil];

    NSMutableDictionary * sec6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @2, FNInputTableRowMaxChecksCount,
								  @"Кастомный выбор", FNInputTableHeader,
								  [NSArray arrayWithObjects:
								   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Пол", FNInputTableRowHint,
                                    @"Пол", FNInputTableRowFieldName,
                                    @[@{@"id":@"0", @"name":@"Мужской"}, @{@"id":@"1", @"name":@"Женский"}], FNInputTableRowVariants,
                                    [NSNull null], FNInputTableRowValue, nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Точный Пол", FNInputTableRowHint,
                                    @"Точный Пол", FNInputTableRowFieldName,
                                    @[@{@"id":@"0", @"name":@"Мужской"}, @{@"id":@"1", @"name":@"Женский"}], FNInputTableRowVariants,
                                    [NSNull null], FNInputTableRowValue,
                                    @"Пол не выбран", FNInputTableRowVariantNullTitle,
                                    @YES, FNInputTableRowVariantIsNullSelected,
                                    nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Женский Пол", FNInputTableRowHint,
                                    @"Женский Пол", FNInputTableRowFieldName,
                                    @[@{@"id":@"0", @"name":@"Мужской"}, @{@"id":@"1", @"name":@"Женский"}], FNInputTableRowVariants,
                                    @{@"id":@"1", @"name":@"Женский"}, FNInputTableRowValue,
                                    @YES, FNInputTableRowVariantIsNullSelected,
                                    nil],
								   nil
								   ], FNInputTableRows,
								  nil];
    
	return [NSArray arrayWithObjects: sec0, sec1, sec2, sec3, sec4, sec5, sec6, nil];
}

- (id) getDataFromFieldName: (NSString*) fieldName
{
    return [self.class getDataFromFieldName: fieldName toInfo: _info];
}

- (id) getValueFromFieldName: (NSString*) fieldName
{
    NSMutableDictionary* row = [self getDataFromFieldName: fieldName];
    if (row) {
        return [row objectForKey: FNInputTableRowValue];
    }
    return nil;
}

- (BOOL) getEnabledFromRow: (NSDictionary*) row
{
    NSNumber * enabled = row[FNInputTableRowIsEnabled];
    return (enabled == nil) || ([enabled isKindOfClass: NSNumber.class] && [enabled boolValue]);
}

- (BOOL) getEnabledFromFieldName: (NSString*) fieldName
{
    NSMutableDictionary* row = [self getDataFromFieldName: fieldName];
    return [self getEnabledFromRow: row];
}

- (void) setEnabled: (BOOL) value fromFieldName: (NSString*) fieldName
{
    NSMutableDictionary* row = [self getDataFromFieldName: fieldName];
    [row setObject: [NSNumber numberWithBool: value] forKey: FNInputTableRowIsEnabled];
    //NSIndexPath * indexPath = [self.class getIndexFromFieldName: fieldName tableInfo: info];
    [self updateValues];
}

- (void) selectWithFieldName: (NSString*) fieldName
{
    NSIndexPath * indexPath = [self.class getIndexFromFieldName: fieldName tableInfo: _info];
    if (indexPath) {
        [self tableView: _mainTable didSelectRowAtIndexPath: indexPath];
    }
}

- (void) setValue: (id) value fromFieldName: (NSString*) fieldName
{
    [self.class setValue: value fromFieldName: fieldName toInfo: _info];
}

- (NSArray*) startTableInfoFromData: (NSDictionary*) data
{
    return [self emptyTableInfo];
}

- (NSArray*) tableInfoFromData: (NSDictionary*) data
{
    return [self emptyTableInfo];
}

- (NSInteger) indexForValue:(NSString *) value
{
    for (int i = 0; i < _variants.count; i++) {
        id item = [_variants objectAtIndex:i];
        NSString * currentValue = nil;
        if ([item isKindOfClass: NSString.class]) {
            currentValue = item;
        } else if ([item isKindOfClass: NSDictionary.class]) {
            currentValue = [item objectForKey:@"name"];
        }
        if ([currentValue isEqualToString:value]) {
            return i;
        }
    }
    return 0;
}

- (void) updateVariantPickerWithValue: (id) value
{
    [_variantPicker reloadAllComponents];
    NSInteger index = 0;
    if (value && ![value isKindOfClass: NSNull.class]) {
        NSString * currentValue = nil;
        if ([value isKindOfClass: NSString.class]) {
            currentValue = value;
        } else if ([value isKindOfClass: NSDictionary.class]) {
            currentValue = [value objectForKey:@"name"];
        }
        index = [self indexForValue: currentValue];
        index++; // так как первый элемент пустой
    }
    [_variantPicker selectRow: index inComponent: 0 animated: NO];
    [self pickerView: _variantPicker didSelectRow: index inComponent: 0];
}

- (void) updateDatePickerWithValue: (id) value
{
    if (value && [value isKindOfClass:NSString.class]) {
        NSDate * date = [_dateFormatter dateFromString: value];
        if (date) {
            _datePicker.date = date;
        } else {
            _datePicker.date = [NSDate date];
        }
    } else {
        _datePicker.date = [NSDate date];
    }
    [self changeDate];
}

- (void) updateTextInputViewWithData:(NSDictionary *) data
{
    [_variants autorelease];
    _variants = [[data objectForKey:FNInputTableRowVariants] retain];
    NSNumber * isDatePicker = [data objectForKey:FNInputTableRowIsDatePicker];
    id value = [data objectForKey:FNInputTableRowValue];
    if (_variants && _variants.count > 0) {
        _textInput.inputView = _variantPicker;
        [self updateVariantPickerWithValue: value];
    } else if (isDatePicker && [isDatePicker boolValue]) {
        _textInput.inputView = _datePicker;
        [self updateDatePickerWithValue: value];
    } else {
        _textInput.inputView = nil;
    }
    /*textInput.placeholder = @"";
    NSString * placeholder = [data objectForKey: FNInputTableRowPlaceholder];
    if (placeholder) {
        textInput.placeholder = placeholder;
    }*/
}

- (UIColor *) inputTextColor
{
    return [UIColor blackColor];
}

- (UITableViewStyle) tableViewStyle
{
    return UITableViewStyleGrouped;
}

- (UIColor *) textInputBackgroundColor
{
    return [UIColor whiteColor];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [(BxAppearance *)[BxAppearance appearanceForClass:[self class]] startForwarding:self];
    
    [super viewDidLoad];
    
    if (IS_OS_7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
	_mainScroll = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f,
                                                                 self.contentView.frame.size.width, 
                                                                 self.contentView.frame.size.height)];
	_mainScroll.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
	[self.contentView addSubview: _mainScroll];
	[_mainScroll release];
    
    if (_backgroundImage) {
        self.view.backgroundColor = [UIColor colorWithPatternImage: _backgroundImage];
    } else {
        self.view.backgroundColor = [self backgroundColor];
    }
	
	/*float imageSize = 140.0f;
	float width = self.contentView.frame.size.width;
	
	UIImageView * imagePatternView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Image-background.png"]];
	imagePatternView.center = CGPointMake(160.0f, 120.0f);
	[mainScroll addSubview: imagePatternView];
	[imagePatternView release];
	
	
	imageView = [[UIImageView alloc] initWithFrame: CGRectMake((width - imageSize) / 2.0f, 20.0f, imageSize, imageSize)];
	imageView.center = imagePatternView.center;
	[mainScroll addSubview: imageView];
	[imageView release];*/
	
	self.info = [self emptyTableInfo];
	_mainTable = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f,
															   self.contentView.frame.size.width, 
															   100.0f) style:[self tableViewStyle]];
	//mainTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_mainTable.delegate = self;
	_mainTable.dataSource = self;
	_mainTable.scrollEnabled = NO;
    _mainTable.backgroundView = nil;
	_mainTable.backgroundColor = [UIColor clearColor];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[_mainScroll addSubview: _mainTable];
	[_mainTable release];
	[self update];
    if ([_mainTable respondsToSelector: @selector(setTintColor:)]) {
        _mainTable.tintColor = [UIColor blackColor];
    }
	
	_mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainTable.frame.origin.y + _mainTable.frame.size.height);
    
	
	_textInputView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 20, 20)];
    _textInputView.autoresizingMask = UIViewAutoresizingNone;
	_textInputView.alpha = 0.0f;
	[_mainTable addSubview: _textInputView];
	[_textInputView release];
	_textInput = [[UITextField alloc] initWithFrame: _textInputView.bounds];
	_textInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_textInput.font = [self getValueFont];
	_textInput.textAlignment = NSTextAlignmentRight;
    _textInput.textColor = [self inputTextColor];
	_textInput.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _textInput.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_textInput.autocorrectionType = UITextAutocorrectionTypeNo;
	_textInput.keyboardType = UIKeyboardTypeDefault;
	_textInput.backgroundColor = [self textInputBackgroundColor];
	_textInput.delegate = self;
	_textInput.clearButtonMode = UITextFieldViewModeNever;
	_textInput.placeholder = nil;
    _textInput.inputAccessoryView = [self keyboardInputAccessoryView];
    [_textInput addTarget: self action: @selector(textFieldValueChanged:) forControlEvents: UIControlEventEditingChanged];
	[_textInputView addSubview: _textInput];
	[_textInput release];
    
    _variantPicker = [[UIPickerView alloc] init];
    _variantPicker.dataSource = self;
    _variantPicker.delegate = self;
    _variantPicker.showsSelectionIndicator = YES;
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = [NSDate date];
    [_datePicker addTarget: self action: @selector(changeDate) forControlEvents: UIControlEventValueChanged | UIControlEventTouchUpInside];
    
    self.indexPathForSelectedCell = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self scrollDidLoad];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = _mainTable.frame;
    rect.size.width = _mainScroll.frame.size.width;
    _mainTable.frame = rect;
    CGSize size = _mainScroll.contentSize;
    size.width = _mainScroll.frame.size.width;
    _mainScroll.contentSize = size;
    
    if (!_isContentChanged) {
        _contentRect = self.contentView.frame;
    }
    [self updateContentInset];
    
    [self setContentOffsetY: 0.0f];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([self isAlwaysShowKeyboard]) {
        [self becomeNext];
    }
	[super viewWillAppear: animated];
}

- (void) becomeNext
{
    NSIndexPath * nextIndex = [self.class getEmptyIndexFromTableInfo: _info];
    [self tableView: _mainTable didSelectRowAtIndexPath: nextIndex];
}

//! @override
- (BOOL) isAlwaysShowKeyboard
{
    return NO;
}

- (void) updateValues
{
    for (NSArray * sec in _cellData) {
        for (BxOldInputTableCell * cell in sec) {
             [cell update];
        }
    }
}

- (void) updateOnThread
{
    self.cellData = nil;
    NSMutableArray * cellData = [NSMutableArray arrayWithCapacity: _info.count];
    for (NSDictionary * sec in _info) {
        NSArray * rows = sec[FNInputTableRows];
        NSMutableArray * rowsResult = [NSMutableArray arrayWithCapacity: rows.count];
        for (NSDictionary * row in rows) {
            [rowsResult addObject: [self cellFromData: row]];
        }
        [cellData addObject: rowsResult];
    }
    self.cellData = cellData;
    [_mainTable reloadData];
    [_mainTable sizeToFit];
	_mainTable.frame = CGRectMake(_mainTable.frame.origin.x, _mainTable.frame.origin.y,
								  _mainTable.frame.size.width, _mainTable.contentSize.height);
    [self scrollDidLoad];
}

- (void) refresh
{
    if (self.info != nil) {
        self.info = [self emptyTableInfo];
        [self updateOnThread];
    }
}

- (void) update
{
	[self performSelectorOnMainThread: @selector(updateOnThread) withObject: nil waitUntilDone: YES];
}

- (BOOL) getEnabled
{
    return YES;
}

- (void) startWithData: (NSDictionary*) data editing: (BOOL) editing
{
	if (editing) {
		self.info = [self tableInfoFromData: data];
	} else {
		self.info = [self startTableInfoFromData: data];
	}
	_mainTable.allowsSelection = [self getEnabled];
	[self update];
}


- (CGFloat) tableHeightShift
{
    return 24.0f;
}

- (CGFloat) heightShift
{
    return 16.0f;
}

- (CGFloat) textShift
{
    return 2.0f;
}

- (BOOL) isYESRow: (NSDictionary*) row fieldName: (const NSString * const) fieldName
{
    NSNumber * value = [row objectForKey: fieldName];
    if (value && [value isKindOfClass: NSNumber.class]) {
        if ([value boolValue]) {
            return YES;
        }
    }
    return NO;
}

- (void) updateForEmpty 
{
    if (![self isNeedShowKeyboardInputAccessoryView] && [self isNeedShowKeyboardNextButton]) {
        NSIndexPath * nextIndex = [self.class getEmptyIndexFromTableInfo: _info];
        if (nextIndex) {
            _textInput.returnKeyType = UIReturnKeyNext;
        } else {
            _textInput.returnKeyType = UIReturnKeyDone;
        }
    }
}

- (void) didChangedValue: (id) value fromFieldName: (NSString*) fieldName
{
    //
}

- (void) checkNext
{
    [self updateForEmpty];
    //[textInput resignFirstResponder];
    if ([_textInput respondsToSelector: @selector(reloadInputViews)]) {
        [_textInput reloadInputViews];
    }
    //[textInput becomeFirstResponder];
}

- (void) updateTextInputFromName: (NSString*) fieldName
{
}
- (BOOL) clickRow: (NSDictionary*) row indexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) checkRowKeyboardType: (NSDictionary*) row
{
    NSNumber * isSecurity = [row objectForKey: FNInputTableRowIsSecurity];
    if (isSecurity && [isSecurity boolValue]) {
        _textInput.secureTextEntry = YES;
    } else {
        _textInput.secureTextEntry = NO;
    }
    NSNumber * keyboardType = row[FNInputTableRowKeyboardType];
    if (keyboardType) {
        _textInput.keyboardType = [keyboardType intValue];
    } else {
        _textInput.keyboardType = UIKeyboardTypeDefault;
    }
    NSString * fieldName = [row objectForKey: FNInputTableRowFieldName];
    [self updateKeyboardTypeWithFieldName: fieldName];
    
    NSString * text = _textInput.text;
    _textInput.text = @"update@all!textfield";
    _textInput.text = text;
}

/*
- (void) onDidChangeContentSizeWithShow
{
	[super onDidChangeContentSizeWithShow];
    if (keyboardShown) {
        NSIndexPath * indexPath = [mainTable indexPathForRowAtPoint: textInputView.center];
        [self tableView: mainTable scrollToRowAtIndexPath: indexPath];
    }
}
*/

#pragma mark - 

- (Class) cellClass
{
    return BxOldInputTableCell.class;
}

- (CGFloat) cellHeight
{
    return 40.0f;
}

- (BxOldInputTableCell *) cellFromData: (NSDictionary*) data
{
    Class cellClass = [self cellClass];
    BxOldInputTableCell * cell = (BxOldInputTableCell*)[cellClass cellFrom: data parent: self];
    return cell;
}

- (CGRect) headerRectFrom: (CGRect) rect
{
    return CGRectMake(20.0f, 10.0f, rect.size.width - 30.0f, 24.0f);
}

- (UIFont*) headerFont
{
    return [UIFont boldSystemFontOfSize: 15.0f];
}

- (UIFont*) footerFont
{
    return [UIFont boldSystemFontOfSize: 15.0f];
}

- (void) updateLabelForSectionHeader: (UILabel *) label
{
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [label setFont: [self headerFont]];
}

- (void) updateLabelForSectionFooter: (UILabel *) label
{
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithWhite: 0.8f alpha:1.0f];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [label setFont: [self footerFont]];
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - PickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int numberOfRows = 1; // так как первый вариант не выбран
    if (_variants) {
        numberOfRows += _variants.count;
    }
    return numberOfRows;
}

#pragma mark - PickerViewDelegate methods

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) { // для пустого элемента
        NSString * title = [self getRowDataFieldName: _currentFieldName][FNInputTableRowVariantNullTitle];
        if (title && [title isKindOfClass: NSString.class]) {
            return title;
        }
        return @"";
    }
    if (_variants) {
        id item = [_variants objectAtIndex: row - 1];
        if ([item isKindOfClass: NSString.class]) {
            return item;
        } else if ([item isKindOfClass: NSDictionary.class]){
            return [(NSDictionary *)item objectForKey:@"name"];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_currentFieldName == nil) {
        // Этот косяк воспроизводится, когда крутнул барабан, нажал Done, и выбор произошел уже после того как поле стало неактивным
        return;
    }
    if (row == 0) {
        NSNumber * isNullSelected = [self getRowDataFieldName: _currentFieldName][FNInputTableRowVariantIsNullSelected];
        if (isNullSelected && [isNullSelected boolValue]) {
            [self.class setValue: nil fromFieldName: _currentFieldName toInfo: _info];
            [self didChangedValue: nil fromFieldName: _currentFieldName];
            _textInput.text = @"";
            [self updateValues];
            return;
        } else {
            if (row < _variants.count) {
                row++;
                [pickerView selectRow: row inComponent:component animated: YES];
            } else {
                return;
            }
        }
    }
    id value = [_variants objectAtIndex:row - 1];
    [self.class setValue: value fromFieldName: _currentFieldName toInfo: _info];
    [self didChangedValue: value fromFieldName: _currentFieldName];
    _textInput.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self updateValues];
}

#pragma mark - UITextFieldDelegate methods

//! @todo вместо этого метода надо использовать valueChanged, так как он не отражает действительной информации
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //! todo это хак, для того чтобы правосторонний ввод с пробелом отрабатывался нормально: http://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7
    if (range.location == textField.text.length && [string isEqualToString:@" "]) {
        textField.text = [textField.text stringByAppendingString:@"\u00a0"];
        return NO; //! todo это тимит тот самый пробел, можно этого не делать, но Label все равно затримит при отображении
    }
    
    // перечисление всех возможных запретов редактирования
    
    NSNumber *isDatePicker = _currentElement[FNInputTableRowIsDatePicker];
    NSDictionary *variants = _currentElement[FNInputTableRowVariants];
    if ((isDatePicker && [isDatePicker boolValue]) ||
        (variants)
        ){
        return NO;
    }

	NSString * text = [NSString stringWithString: textField.text];
    text = [text stringByReplacingCharactersInRange: range withString: string];
    NSNumber *maxSymbolsCount = _currentElement[FNInputTableRowMaxSymbolsCount];
    
    // удаление лишних символов
	if (text && text.length > 0) {
        if (maxSymbolsCount && (text.length > [maxSymbolsCount intValue])) {
            text = [text substringToIndex:[maxSymbolsCount intValue]];
            textField.text = text;
            return NO;
        }
	}

	return YES;
}

- (void) textFieldValueChanged: (UITextField *)textField
{
    NSString * text = textField.text;
    if (text && text.length > 0) {
        [_currentElement setObject: text forKey: FNInputTableRowValue];
        [self didChangedValue: text fromFieldName: _currentElement[FNInputTableRowFieldName]];
    } else {
        [_currentElement removeObjectForKey: FNInputTableRowValue];
        [self didChangedValue: nil fromFieldName: _currentElement[FNInputTableRowFieldName]];
    }
    [self updateForEmpty];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	_textInputView.alpha = 1.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self updateValues];
	_textInputView.alpha = 0.0f;
    [_currentFieldName autorelease];
    _currentFieldName = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self textFieldDidEndEditing: textField];
    if (![self isNeedShowKeyboardInputAccessoryView] && [self isNeedShowKeyboardNextButton]) {
        NSIndexPath * nextIndex = [self.class getEmptyIndexFromTableInfo: _info];
        if (nextIndex) {
            [self tableView: _mainTable didSelectRowAtIndexPath: nextIndex];
        } else {
            [textField resignFirstResponder];
        }
    } else {
        [textField resignFirstResponder];
    }
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	_textInput.text = @"";
	[_currentElement removeObjectForKey: FNInputTableRowValue];
    [self didChangedValue: nil fromFieldName: _currentElement[FNInputTableRowFieldName]];
	[self updateForEmpty];
	return YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray * rows = _cellData[section];
	return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BxOldInputTableCell * cell = self.cellData[indexPath.section][indexPath.row];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary * rowData = [_info objectAtIndex: section];
	if ([rowData objectForKey: FNInputTableHeader]) {
		UIView * header = [self tableView: tableView viewForHeaderInSection: section];
		return header.frame.size.height;
	} else {
        if (section == 0) {
            return [self tableHeightShift];
        } else {
            return truncf([self heightShift] / 2.0f);
        }
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	NSDictionary * rowData = _info[section];
	if ([rowData objectForKey: FNInputTableFooter]) {
		UIView * footer = [self tableView: tableView viewForFooterInSection: section];
		return footer.frame.size.height;
	} else {
		if (section == _cellData.count - 1) {
            return [self tableHeightShift];
        } else {
            return truncf([self heightShift] / 2.0f);
        }
	}
}

- (BOOL) isBooleanGroupedRow: (NSDictionary*) row
{
    NSNumber * isSwitch = [row objectForKey: FNInputTableRowIsSwitch];
    return isSwitch == nil || (![isSwitch boolValue]);
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getEnabledFromRow: [self getRowDataFrom: indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BxOldInputTableCell * cell = self.cellData[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSDictionary * rowData = _info[section];
	id object = [rowData objectForKey: FNInputTableHeader];
	if ( object ){
        if ( [object isKindOfClass: NSString.class] ) {
            NSString * text = object;
            CGRect headerRect = [self headerRectFrom: CGRectMake(10.0f, 0.0f, 320.0f, 10.0f)];
            UILabel * titleName = [[UILabel alloc] initWithFrame: headerRect];
            titleName.tag = section;
            [self updateLabelForSectionHeader: titleName];
            headerRect = titleName.frame;
            titleName.text = text;
            [titleName sizeToFit];
            headerRect.origin.y = truncf([self heightShift] / 2.0f);
            headerRect.size.height = truncf(titleName.frame.size.height + [self textShift] + 0.99f);
            titleName.frame = headerRect;
            titleName.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            UIView * result = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, headerRect.origin.y + headerRect.size.height)];
            [result addSubview: titleName];
            [titleName release];
            return [result autorelease];
        } else if ([object isKindOfClass: UIView.class]) {
            return object;
        }
    }
	return [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	NSDictionary * rowData = _info[section];
	id object = [rowData objectForKey: FNInputTableFooter];
	if ( object ){
        if ( [object isKindOfClass: NSString.class] ) {
            NSString * text = object;
            UILabel * titleName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 10.0f)];
            titleName.tag = section;
            [self updateLabelForSectionFooter: titleName];
            titleName.text = text;
            [titleName sizeToFit];
            titleName.frame = CGRectMake(10.0f, [self textShift], 300.0f, truncf(titleName.frame.size.height + 0.99f));
            titleName.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            UIView * result = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, truncf(titleName.frame.size.height + titleName.frame.origin.y + [self heightShift] / 2.0f))];
            [result addSubview: titleName];
            [titleName release];
            return [result autorelease];
        } else if ([object isKindOfClass: UIView.class]) {
            return object;
        }
	}
	return [[[UIView alloc] initWithFrame: CGRectZero] autorelease];
}

- (void) tableView:(UITableView *)tableView scrollToRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self numberOfSectionsInTableView: _mainTable] <= indexPath.section ||
        [self tableView: _mainTable numberOfRowsInSection:indexPath.section] <= indexPath.row)
    {
        return;
    }
    
    CGRect inputRect = [_mainTable rectForRowAtIndexPath: indexPath];
    
    CGRect contentRect = CGRectMake(_mainScroll.contentOffset.x, [self getContentOffsetY],
                                    _mainScroll.contentSize.width, [self getContentHeight]);
    CGFloat shiftHeight = truncf(1.7f * inputRect.size.height);
    contentRect.origin.y += 0.5f * shiftHeight;
    contentRect.size.height -= shiftHeight;
    CGRect inputInScroll = [_mainTable convertRect: inputRect toView: _mainScroll];
    if (CGRectContainsRect(contentRect, inputInScroll) == false) {
        CGFloat position = inputRect.origin.y - inputRect.size.height / 2.0f - contentRect.size.height / 2.0f;
        if (inputInScroll.origin.y < contentRect.origin.y) {
            position = inputRect.origin.y - 0.5 * shiftHeight;
        } else {
            position = inputRect.origin.y + inputRect.size.height - contentRect.size.height - 0.5 * shiftHeight;
        }
        [self setContentOffsetY: truncf(position) animated: YES];
    }
}

- (NSDictionary*) getRowDataFrom: (NSIndexPath*) indexPath
{
    NSDictionary * rowData = [_info objectAtIndex: indexPath.section];
	NSArray * rows = [rowData objectForKey: FNInputTableRows];
	return [rows objectAtIndex: indexPath.row];
}

- (NSMutableDictionary*) getRowDataFieldName: (NSString*) fieldName
{
    return [self.class getDataFromFieldName: fieldName toInfo: _info];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathForSelectedCell = indexPath;
	NSDictionary * rowData = [_info objectAtIndex: indexPath.section];
	NSArray * rows = [rowData objectForKey: FNInputTableRows];
	_textInputView.alpha = 0.0f;
	[_mainTable deselectRowAtIndexPath: indexPath animated: YES];
	self.currentElement = nil;
    
    NSMutableDictionary * row = [rows objectAtIndex: indexPath.row];
    [_currentFieldName autorelease];
    _currentFieldName = [[row objectForKey:FNInputTableRowFieldName] retain];
    if (![self getEnabledFromRow: row]) {
        return;
    }
    if ([self isYESRow: row fieldName: FNInputTableRowIsAction]) {
        BOOL result = [self clickRow: row indexPath: indexPath];
        if (result) {
            [_textInput resignFirstResponder];
            [self updateValues];
            return;
        }
    }
    BOOL isBooleanData = NO;
    if ([self.class isBooleanRow: row]) {
        isBooleanData = YES;
    }
	
	if (isBooleanData) {
        if ([self isBooleanGroupedRow: row]) {
            NSInteger maxChecksCount = [rowData[FNInputTableRowMaxChecksCount] integerValue];
            if (maxChecksCount > 0) {
                NSNumber * value = [row objectForKey: FNInputTableRowValue];
                if ([value boolValue]) {
                    [row setObject: @NO forKey: FNInputTableRowValue];
                    [self didChangedValue: @NO fromFieldName: row[FNInputTableRowFieldName]];
                } else {
                    int checkedCount = 0;
                    for (NSMutableDictionary * item in rows) {
                        if ([self.class isBooleanRow: item] && [item[FNInputTableRowValue] boolValue]) {
                            checkedCount++;
                        }
                    }
                    if (checkedCount < maxChecksCount) {
                        [row setObject: @YES forKey: FNInputTableRowValue];
                        [self didChangedValue: @YES fromFieldName: row[FNInputTableRowFieldName]];
                    } else {
                        [BxAlertView showAlertWithTitle: @"Внимание"
                                                message: @"Достигнуто максимальное количество выбранных элементов."
                                      cancelButtonTitle: @"OK"
                                          okButtonTitle: nil
                                                handler: nil];
                    }
                }
            } else {
                int index = 0;
                NSString * fn = @"";
                for (NSMutableDictionary * item in rows) {
                    if ([self.class isBooleanRow: item]) {
                        if (index == indexPath.row) {
                            fn = item[FNInputTableRowFieldName];
                            [item setObject: [NSNumber numberWithBool: YES] forKey: FNInputTableRowValue];
                        } else {
                            [item setObject: [NSNumber numberWithBool: NO] forKey: FNInputTableRowValue];
                        }
                    }
                    index++;
                }
                [self didChangedValue: @YES fromFieldName: fn];
            }
            [_textInput resignFirstResponder];
            [self updateValues];
		}
	} else {
        _textInputView.alpha = 0.0f;
        [self updateTextInputViewWithData:row];
        self.currentElement = [rows objectAtIndex: indexPath.row];

        BxOldInputTableCell * cell = (BxOldInputTableCell*)[_mainTable cellForRowAtIndexPath: indexPath];
        CGRect rect = [_mainTable convertRect: cell.valueLabel.frame fromView: cell.contentView];
        
        rect.origin.y += 1.0f;
        rect.size.height -= 1.0f;
		rect.origin.x -= 1.0f;
        rect.size.width += 1.0f;

		_textInput.text = @"";
        rect = CGRectStandardize(rect);
		_textInputView.frame = rect;
		
        
        [self checkRowKeyboardType: self.currentElement];
        
		id value = [self.currentElement objectForKey: FNInputTableRowValue];
		if (value) {
            if ([value isKindOfClass:NSString.class]) {
                _textInput.text = value;
            } else if ([value isKindOfClass:NSDictionary.class]){
                _textInput.text = [value objectForKey:@"name"];
            }
		} else {
			_textInput.text = nil;
		}
        _textInputView.alpha = 1.0f;
        
        [self updateTextInputFromName: [row objectForKey: FNInputTableRowFieldName]];
		
		[self checkNext];
        
		[self updateValues];
        
        [_textInput becomeFirstResponder];
        [self tableView: tableView scrollToRowAtIndexPath: indexPath];
	}
}

- (void) updateContentInset
{
    /*CGFloat topY = (IS_OS_7_OR_LATER && self.navigationController && !self.navigationController.navigationBarHidden) ? 64 : 0;
    CGFloat bottomY = (IS_OS_7_OR_LATER && !keyboardShown && self.tabBarController) ? self.tabBarController.tabBar.frame.size.height - 1: 0;*/
    CGRect extendedEdgesBounds = self.extendedEdgesBounds;
    CGFloat topY = extendedEdgesBounds.origin.y - self.contentView.frame.origin.y;
    CGFloat bottomY = (_keyboardShown) ? 0 : extendedEdgesBounds.size.height - self.contentView.frame.size.height + topY;
    
    CGFloat h = _mainScroll.frame.size.height - _contentRect.size.height - bottomY;
    
    _mainScroll.contentInset = UIEdgeInsetsMake(topY, 0, h, 0);
    _mainScroll.scrollIndicatorInsets = UIEdgeInsetsMake(topY, 0, h, 0);
}



- (CGFloat) getContentOffsetY
{
    return _mainScroll.contentOffset.y + _mainScroll.contentInset.top;
}

- (CGFloat) getContentHeight
{
    return _contentRect.size.height - _mainScroll.contentInset.top;
}

- (void) setContentOffsetY:(CGFloat) y animated: (BOOL) animated
{
    CGFloat topShift = - _mainScroll.contentInset.top;
    y += topShift;
    CGFloat maxY = _mainScroll.contentSize.height - _contentRect.size.height;
    if (y < topShift || maxY < topShift) {
        y = topShift;
    } else if (y > maxY){
        y = maxY;
    }
    [_mainScroll setContentOffset: CGPointMake(0.0f, y) animated: animated];
}

- (void) setContentOffsetY:(CGFloat) y
{
    [self setContentOffsetY: y animated: NO];
}

- (CGFloat) contentHeightForKeyboardFrame:(CGRect) keyboardFrame
{
    return  keyboardFrame.origin.y;
}

- (void) onWillChangeContentSizeWithShow:(NSDictionary*) data isKeyBoardWillShow: (BOOL) isKeyBoardWillShow
{
	if (![self isContentResize]) {
		return;
	}
    CGRect keyboardFrame = [BxUIUtils getKeyboardFrameIn: self.view userInfo: data];
	CGFloat contentHeight = self.view.frame.size.height;
    if (isKeyBoardWillShow) {
        contentHeight = [self contentHeightForKeyboardFrame: keyboardFrame];
    }
    _isContentChanged = YES;
	_contentRect = CGRectMake(_contentRect.origin.x, _contentRect.origin.y,
								   self.view.frame.size.width,
								   contentHeight);
    [self updateContentInset];
	[self onWillChangeContentSizeWithShow: isKeyBoardWillShow];
    
    NSIndexPath * indexPath = [_mainTable indexPathForRowAtPoint: _textInputView.center];
    [self tableView: _mainTable scrollToRowAtIndexPath: indexPath];
}

- (void)dealloc {
    [_currentFieldName autorelease];
    _currentFieldName = nil;
    [_variantPicker autorelease];
    _variantPicker = nil;
    [_datePicker autorelease];
    _datePicker = nil;
    [_variants autorelease];
    _variants = nil;
    self.indexPathForSelectedCell = nil;
	self.currentElement = nil;
	self.info = nil;
    self.dateFormatter = nil;
    
    self.titleTextColor = nil;
    self.subtitleTextColor = nil;
    self.valueTextColor = nil;
    self.placeholderColor = nil;
    self.titleFont = nil;
    self.subtitleFont = nil;
    self.valueFont = nil;
    self.backgroundImage = nil;
    self.cellData = nil;
    
    [super dealloc];
}

@end

/**
 *	@file BxOldInputTableController.h
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

#import <Foundation/Foundation.h>
#import "BxKeyboardController.h"
#import "BxOldInputTableCell.h"

extern const NSString * const FNInputTableHeader; // может быть строкой и UIView
extern const NSString * const FNInputTableFooter; // может быть строкой и UIView
extern const NSString * const FNInputTableRows;
extern const NSString * const FNInputTableRowHint;
extern const NSString * const FNInputTableRowValue; // для случая FNInputTableRowVariants значение должно быть в виде [id,name]
extern const NSString * const FNInputTableRowFieldName;
extern const NSString * const FNInputTableRowIsSecurity;
extern const NSString * const FNInputTableRowIsAction;
extern const NSString * const FNInputTableRowIsEnabled;
extern const NSString * const FNInputTableRowIsSwitch;

extern const NSString * const FNInputTableRowVariants; // [id,name] массив
extern const NSString * const FNInputTableRowVariantNullTitle; // название не выбранного элемента, по умолчанию ''
extern const NSString * const FNInputTableRowVariantIsNullSelected; // позволять выбрать пустое значение, по умолчанию отключено
extern const NSString * const FNInputTableRowIsDatePicker; // выбор даты
extern const NSString * const FNInputTableRowSubtitle;
extern const NSString * const FNInputTableRowPlaceholder;
extern const NSString * const FNInputTableRowMaxSymbolsCount;
extern const NSString * const FNInputTableRowMaxChecksCount; // по умолчанию 0
extern const NSString * const FNInputTableRowIcon;
extern const NSString * const FNInputTableRowKeyboardType;

@interface BxOldInputTableController : BxKeyboardController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,  UIAppearance> {
@protected
	UIImageView * _imageView;
	UIScrollView * _mainScroll;
	UITableView * _mainTable;
	UIView * _textInputView;
	UITextField * _textInput;
	CGRect _textInputFrame;
	UIButton * _btSend;
    UIPickerView * _variantPicker;
    NSArray * _variants;
    NSString * _currentFieldName;
    UIDatePicker * _datePicker;
    
    NSIndexPath * _indexPathForSelectedCell;
    NSMutableDictionary * _currentElement;
    CGRect _contentRect;
    BOOL _isContentChanged; // если этот параметр YES, то вероятно сработала клавиатура и contentRect отщепился от contentView, так как в этом котролере размер его не меняется в отличае от предка
}
@property (nonatomic, retain) NSArray * info;
@property (nonatomic, retain) NSMutableDictionary * currentElement;
@property (nonatomic, retain) NSDateFormatter * dateFormatter;

@property (nonatomic, retain) UIColor * titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor * subtitleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor * valueTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor * placeholderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIFont * titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIFont * subtitleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIFont * valueFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIImage * backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL isFloatCellSize UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat lineShift UI_APPEARANCE_SELECTOR;
//! по умолчанию NO. Если зададите YES то заблокированные ячейки будут показываться как нормальные
@property (nonatomic) BOOL isNormalShowingDisadledCell UI_APPEARANCE_SELECTOR;

@property (nonatomic, readonly, getter=_contentRect) CGRect contentRect;
@property (nonatomic, readonly, getter=_isContentChanged) BOOL isContentChanged;
@property (nonatomic, readonly, getter=_textInput) UITextField * textInput;
@property (nonatomic, readonly, getter=_datePicker) UIDatePicker * datePicker;
@property (nonatomic, readonly, getter=_variantPicker) UIPickerView * variantPicker;
@property (nonatomic, readonly, getter=_mainScroll) UIScrollView * mainScroll;


- (void) startWithData: (NSDictionary*) data editing: (BOOL) editing;
- (id) getDataFromFieldName: (NSString*) fieldName;
- (id) getValueFromFieldName: (NSString*) fieldName;
- (void) setValue: (id) value fromFieldName: (NSString*) fieldName;
- (BOOL) getEnabledFromFieldName: (NSString*) fieldName;
- (void) setEnabled: (BOOL) value fromFieldName: (NSString*) fieldName;

+ (UIFont *) getTitleFont;
+ (UIFont *) getSubtitleFont;
+ (UIFont *) getValueFont;

//! возвращает данные для ячейки по индексу
- (NSDictionary*) getRowDataFrom: (NSIndexPath*) indexPath;
- (NSMutableDictionary*) getRowDataFieldName: (NSString*) fieldName;

- (void) scrollDidLoad;

// обновление всей структуры таблицы (только для главного потока)
- (void) refresh;
// обновление вида таблицы без изменений структуры таблицы
- (void) update;
// обновление только значений таблицы без изменений вида
- (void) updateValues;

// в этих методах можно определить стиль меток на текстовых полях таблицы
- (void) updateLabelForSectionHeader: (UILabel *) label;
- (void) updateLabelForSectionFooter: (UILabel *) label;

//! при смене поля можно изменить поведение клавиатуры
- (void) updateKeyboardTypeWithFieldName: (NSString*) fieldName;
//! после смены клавиатуры можно еще сто то сделать с полем ввода
- (void) updateTextInputFromName: (NSString*) fieldName;


// отступы задают
- (CGFloat) heightShift;
- (CGFloat) textShift;

// в процессе редактирования пользователь изменил значение поля
- (void) didChangedValue : (id) value fromFieldName: (NSString*) fieldName;

//! Выбор элемента для редактирования по названию поля
- (void) selectWithFieldName: (NSString*) fieldName;

//! Элемент является булевым
+ (BOOL) isBooleanRow: (NSDictionary*) row;

//! Для изменения отображаемой ячейки
- (BxOldInputTableCell *) cellFromData: (NSDictionary*) data;
- (Class) cellClass;
- (CGFloat) cellHeight;

@end

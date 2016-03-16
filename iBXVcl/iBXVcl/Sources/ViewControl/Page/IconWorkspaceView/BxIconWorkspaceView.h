/**
 *	@file BxIconWorkspaceView.h
 *	@namespace iBXVcl
 *
 *	@details Рабочий стол с иконками
 *	@date 29.09.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import <UIKit/UIKit.h>
#import "BxIconWorkspacePageView.h"
#import "BxIconWorkspaceItemControl.h"

@class BxPageControl;
@class BxIconWorkspaceView;

@protocol BxIconWorkspaceDelegate <NSObject>

- (void) iconWorkspaceView: (BxIconWorkspaceView*) view onEdition: (BOOL) onEdition;


@end


@interface BxIconWorkspaceView : UIView <UIScrollViewDelegate>{
@protected
    NSTimer *_updateMovedTimer;
    NSString *_currentFileName;
    int _maxRowCount;
    int _maxColCount;
    BOOL _isChangePage;
    BOOL _pageControlUsed;
}

@property (nonatomic, readonly) BxPageControl *pageControl;
@property (nonatomic, readonly) NSArray *pages;
@property (nonatomic, readonly) BxIconWorkspacePageView *currentPage;
@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic) BOOL editable;

@property  (nonatomic, weak) id<BxIconWorkspaceDelegate> delegate;

//! завершение редактирования с сохранением
- (void) done;

/**
 *    заготовленные странички BxIconWorkspacePageView with BxIconWorkspaceItemControl
 *    idName необходим для сохранения состояния иконок
  */
- (void) updateWithPages: (NSArray *) pages idName: (NSString*) idName;

//! размер иконки
@property (nonatomic) CGSize iconSize UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat indentIconHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, readonly) BOOL pageControlUsed;

- (void) updateIcons;

- (NSUInteger) currentPageIndex;

@end
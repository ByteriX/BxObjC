/**
 *	@file BxLoadedImageListViewController.m
 *	@namespace iBXVcl
 *
 *	@details Котролер списка кешируемых из сети изображений
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxLoadedImageListViewController.h"
#import "BxVcl.h"

@implementation BxLoadedImageListItem

- (id) initWithUrl: (NSString*) url title: (NSString*) title
{
    self = [self init];
    if (self) {
        self.url = url;
        self.title = title;
    }
    return self;
}

+ (id) itemWithUrl: (NSString*) url title: (NSString*) title
{
    return [[[self.class alloc] initWithUrl: url title: title] autorelease];
}

- (void) dealloc
{
    self.url = nil;
    self.title = nil;
    [super dealloc];
}

@end

@interface BxLoadedImageListViewController ()
{

}

@end

@implementation BxLoadedImageListViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	//self.title = @"Просмотр фото";
	
	_pageScroll = [[BxPageScrollView alloc] initWithFrame: CGRectMake(0.0f,
																   0.0f,
																   self.view.frame.size.width,
																   self.view.frame.size.height)
											  target: self];
	_pageScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view addSubview: _pageScroll];
	[_pageScroll release];
}

- (void) updatePageScroll
{
    [_pageScroll startWithPageCount: [_itemsData count] currentIndex: _currentIndex classPage: BxLoadedImagePageView.class];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self updatePageScroll];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updatePageScroll];
}

- (void) startWithData:(NSArray*) itemsData currentIndex:(int) index
{
	self.itemsData = itemsData;
    _currentIndex = index;
}

- (void) pageScrollView: (BxPageScrollView*) pageScrollView updatePage: (BxPageView*) page fromIndex: (NSInteger) index
{
    BxLoadedImageListItem * item = _itemsData[index];
	[((BxLoadedImagePageView *)page).imageView  setImageURL: item.url];
}

- (void) pageScrollView: (BxPageScrollView*) pageScrollView showPage:(BxPageView*) page fromIndex: (NSInteger) index
{
	_currentIndex = index;
    BxLoadedImageListItem * item = _itemsData[index];
    [self updatePageWithItem: item];
}

- (void) updatePageWithItem: (BxLoadedImageListItem*) item
{
    if (item.title) {
        self.title = item.title;
    } else {
        self.title = @"";
    }
}

- (void) dealloc
{
    [_itemsData release];
    [super dealloc];
}

@end

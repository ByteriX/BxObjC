/**
 *	@file BxPageScrollView.m
 *	@namespace iBXVcl
 *
 *	@details Листалка страниц
 *	@date 09.10.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxPageScrollView.h"

@implementation BxPageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initObject];
    }
    return self;
}

- (id) initWithFrame:(CGRect) rect target:(id<BxPageScrollTarget>) target
{
	if (self = [self initWithFrame: rect]) {
		self.target = target;
	}
	return self;
}

- (void) initObject
{
    self.bufferPageCount = 5;
    self.pageIndent = 10.0f;
    
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    super.delegate = self;
    self.multipleTouchEnabled = YES;
    
    self.backgroundColor = [UIColor blackColor];
    _pages = [[NSMutableArray alloc] init];
}

- (NSInteger) currentIndexInCash
{
	if (_currentPageIndex < _cashPageCount / 2){
		return _currentPageIndex;
	} else if (_currentPageIndex > _currentPageCount - 1 - _cashPageCount / 2){
		return  _currentPageIndex - _currentPageCount + _cashPageCount;
	} else {
		return _cashPageCount / 2;
	}
}

- (BxPageView*) currentPage
{
	return [_pages objectAtIndex: self.currentIndexInCash];
}

- (void) setCurrentPageCount: (NSInteger) value
{
	_currentPageCount = value;
	if (_currentPageCount > 0) {
		self.contentSize = CGSizeMake(self.frame.size.width * _currentPageCount,
									  0.0f);
	} else {
		self.contentSize = CGSizeMake(self.frame.size.width,
									  self.frame.size.height);
	}
}

- (void) setContentOffsetForIndex:(NSInteger) index
{
	self.contentOffset = CGPointMake(self.frame.size.width * index, 0.0f);
}

- (void) updatePage: (BxPageView *) page fromIndex: (NSInteger) index
{
	[_target pageScrollView: self updatePage: page fromIndex: index];
}

- (void) showCurrentPage
{
	[_target pageScrollView: self showPage: [self currentPage] fromIndex: _currentPageIndex];
}

- (void) setPageDefaultState
{
	BxPageView * currentPage = [self currentPage];
	[currentPage setDefaultState];
}

- (void) setPageWithIndex: (NSInteger) index
{
	if (_currentPageIndex != index)
	{
		[self performSelectorOnMainThread: @selector(setPageDefaultState) withObject: nil waitUntilDone: YES];
		_currentPageIndex = index;
		[self performSelectorOnMainThread: @selector(update) withObject: nil waitUntilDone: YES];
	}
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)sender {
	CGFloat pageWidth = self.frame.size.width;
	int page = (int)(self.contentOffset.x + pageWidth / 2.0f) / (int)(pageWidth);
	[self setPageWithIndex: page];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)sender {
	[self scrollViewWillBeginDecelerating: sender];
	[self showCurrentPage];
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)sender
{
	[self scrollViewWillBeginDecelerating: sender];
}

- (void) update
{
	// Алгоритм обновления - поворот кольца pages
	// определяем новый центр кольца
	NSInteger tempCenterPageIndex = _currentPageIndex;
	if (tempCenterPageIndex < _cashPageCount / 2){
		tempCenterPageIndex = _cashPageCount / 2;
	} else if (tempCenterPageIndex > _currentPageCount - 1 - _cashPageCount / 2){
		tempCenterPageIndex = _currentPageCount - 1 - _cashPageCount / 2;
	}
	
	if (_centerPageIndex == tempCenterPageIndex ||
		_cashPageCount == _currentPageCount)
	{
		// если новый центр совпадает со старым или страницы все в кеше, то останавливаем обновление
		return;
	}
	
	// Оптимизируем: делая максимум один оборот по кольцу кеша
	NSInteger allCount = labs(_centerPageIndex - tempCenterPageIndex);
	NSInteger pagesUpdateCount = allCount;
	if (allCount > _cashPageCount)
		pagesUpdateCount = _cashPageCount;
	NSInteger shift = allCount - pagesUpdateCount;
	
	if (_centerPageIndex > tempCenterPageIndex){
		for (int i = 0; i < pagesUpdateCount; i++)
		{
			BxPageView * page = [_pages lastObject];
			[_pages removeLastObject];
			[_pages insertObject: page atIndex: 0];
			page.center = CGPointMake(page.center.x - (_cashPageCount + shift) * self.frame.size.width,
									  page.center.y);
			[self updatePage: page
				   fromIndex: _centerPageIndex - shift - i - _cashPageCount / 2 - _cashPageCount % 2];
		}
	} else {
		for (int i = 0; i < pagesUpdateCount; i++)
		{
			BxPageView * page = [_pages objectAtIndex:0];
			[_pages removeObject: page];
			[_pages addObject: page];
			page.center = CGPointMake(page.center.x + (_cashPageCount + shift) * self.frame.size.width,
									  page.center.y);
			[self updatePage: page
				   fromIndex: _centerPageIndex + shift + i + _cashPageCount / 2 + _cashPageCount % 2];
		}
	}
	_centerPageIndex = tempCenterPageIndex;
}

- (void) updateCashedPages
{
	for (int index = 0; index < _cashPageCount; index++)
	{
		BxPageView * page = [_pages objectAtIndex: index];
		[self updatePage: page fromIndex: _centerPageIndex + index - _cashPageCount / 2];
	}
}

- (void) clearPages
{
	[_pages removeAllObjects];
	for (UIView * page in self.subviews) {
		if ([page isKindOfClass: BxPageView.class]) {
			[page removeFromSuperview];
		}
	}
}

- (void) startWithPageCount:(NSInteger) pageCount currentIndex:(NSInteger) index classPage: (Class) classPage
{
	[self clearPages];
	
	_cashPageCount = _bufferPageCount;
	if (pageCount < _cashPageCount)
		_cashPageCount = pageCount;
	self.currentPageCount = pageCount;
	_centerPageIndex = _cashPageCount / 2;
	for (int i = 0; i < _cashPageCount; i++)
	{
		BxPageView * page = [[classPage alloc] initWithFrame: CGRectMake(_pageIndent,
                                                                       _pageIndent,
                                                                       self.frame.size.width  - 2 * _pageIndent,
                                                                       self.frame.size.height - 2 * _pageIndent)];
        //page.parentController = self.parentController;
		[self updatePage: page fromIndex: i];
		page.center = CGPointMake(i * self.frame.size.width + truncf(self.frame.size.width / 2.0f),
								  truncf(self.frame.size.height / 2.0f));
		page.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview: page];
		[_pages addObject: page];
		[page release];
	}
	_currentPageIndex = 0;
	if (_cashPageCount == 0){
		BxPageView * page = [[classPage alloc] initWithFrame: CGRectMake(_pageIndent,
                                                                       _pageIndent,
                                                                       self.frame.size.width - 2 * _pageIndent,
                                                                       self.frame.size.height - 2 * _pageIndent)];
		page.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		page.center = CGPointMake(truncf(self.frame.size.width / 2.0f),
								  truncf(self.frame.size.height / 2.0f));
		[self addSubview: page];
		[page release];
	} else {
		[self setContentOffsetForIndex: index];
		[self setPageWithIndex: index];
		[self showCurrentPage];
	}
}

- (void) dealloc
{
    self.target = nil;
	[_pages autorelease];
	_pages = nil;
	[super dealloc];
}

@end

/**
 *	@file BxIconWorkspaceView.m
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

#import "BxIconWorkspaceView.h"
#import "BxPageControl.h"
#import "BxConfig.h"
#import "BxPropertyListParser.h"
#import "BxFileSystem.h"


@interface BxIconWorkspaceView ()

@property (nonatomic) BOOL isMoved;
@property BOOL isClick;

- (void) open;
- (void) save;

@end

@interface BxIconWorkspaceItemControl (BxIconWorkspaceView)

@property (nonatomic) double angle;
@property (nonatomic) BOOL isMoved;

- (void) stepAngle;
- (void) randomAngle;
- (void) setOwner: (BxIconWorkspaceView*) owner;

@end


@implementation BxIconWorkspaceView

static float refreshRate = 25.0f;
static float pageControlHeight = 20.0f;

- (void) initObject {
    _isClick = NO;
    _pageControlUsed = NO;
    _isChangePage = NO;
    _editable = YES;

    _iconSize = CGSizeMake(106.0f, 120.0f);
    _indentIconHeight = 4.0f;
    _maxColCount = (int)self.frame.size.width / (int)_iconSize.width;
    _maxRowCount = _maxColCount * ((int)self.frame.size.height / (int)_iconSize.height);

    _scrollView = [[UIScrollView alloc]  initWithFrame: CGRectMake(0.0f, 0.0f, self.frame.size.width,
            self.frame.size.height - pageControlHeight)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //_scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    _pageControl = [[BxPageControl alloc]  initWithFrame: CGRectMake(0.0f, 0.0f, self.frame.size.width, 40.0f)];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    _pageControl.backgroundColor = [UIColor clearColor];
}

- (NSString *) workDirPath
{
    return [[BxConfig defaultConfig].documentPath stringByAppendingPathComponent: @"BxIconWorkspaceView"];
}

- (void) updateWithPages: (NSArray *) pages idName: (NSString*) idName
{
    for (BxIconWorkspacePageView * page in _pages)
    {
        [page removeFromSuperview];
    }
    _pages = [pages copy];
    if (idName) {
        _currentFileName = [[self workDirPath] stringByAppendingPathComponent: idName];
    } else {
        _currentFileName = nil;
    }
    [self initPages];
    [self open];
    [self updateIcons];
    //_currentPage = _pages[0];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self){
        [self initObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self){
        [self initObject];
    }
    return self;
}

- (void) done
{
    [self setIsMoved: NO];
    [self save];
    [self.delegate iconWorkspaceView: self onEdition: NO];
}

- (void) setDone: (BOOL) isShow
{
    [self.delegate iconWorkspaceView: self onEdition: isShow];
}

//! override
- (void) setIsMoved: (BOOL) value
{
    _isMoved = value;
    [_updateMovedTimer invalidate];
    if (_isMoved){
        for (BxIconWorkspacePageView * page in _pages)
            for (BxIconWorkspaceItemControl * obj in page.icons)
            {
                [obj randomAngle];
            }

        _updateMovedTimer = [NSTimer scheduledTimerWithTimeInterval: 1.00 / refreshRate target: self
                                                           selector: @selector(moveLoop) userInfo: nil repeats: YES];
    } else {
        _updateMovedTimer = nil;
        for (BxIconWorkspacePageView * page in _pages)
            for (BxIconWorkspaceItemControl * obj in page.icons)
            {
                obj.angle = 0.0f;
            }
    }
    [self setDone: _isMoved];
}

- (void) moveLoop
{
    for (BxIconWorkspaceItemControl * obj in _currentPage.icons)
    {
        [obj stepAngle];
    }
}

- (void) updateIcons
{
    //! размещаем иконки
    int lineIconIndex = 0;
    int pageIconIndex = 0;
    int lineIconsCount = (int)(self.frame.size.width) / (int)(_iconSize.width);
    for (BxIconWorkspacePageView * page in _pages)
    {
        lineIconIndex = 0;
        for (BxIconWorkspaceItemControl * obj in page.icons)
        {
            if (!obj.isMoved)
            {
                obj.center = CGPointMake(_iconSize.width / 2.0f + _iconSize.width * (lineIconIndex % lineIconsCount),// + pageIconIndex * self.view.frame.size.width,
                        _indentIconHeight + _iconSize.height / 2.0f + _iconSize.height * (lineIconIndex / lineIconsCount));

                //[self.view addSubview: obj];
            }
            lineIconIndex++;
        }
        pageIconIndex++;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)sender {
    /*if (pageControlUsed) {
        return;
    }*/
    _pageControlUsed = YES;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    _pageControlUsed = NO;
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSUInteger page = (NSUInteger)truncf(_scrollView.contentOffset.x / pageWidth);
    _pageControl.currentPage = page;
    _currentPage = _pages[page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sender
{
    _pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    _pageControlUsed = YES;
    NSUInteger page = (NSUInteger)_pageControl.currentPage;
    _currentPage = _pages[page];
    CGRect frame = _scrollView.frame;
    frame.origin.x = self.frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];

}

- (void) waitChangePage
{
    [NSThread sleepForTimeInterval: 1.0f];
    _isChangePage = NO;
}

- (void) changePageWithShift: (int) shift
{
    if (!_isChangePage){
        _isChangePage = YES;
        _pageControl.currentPage = _pageControl.currentPage + shift;
        [self changePage:_pageControl];
        [NSThread detachNewThreadSelector: @selector(waitChangePage) toTarget:self withObject:nil];
    }
}

- (void) updatePages
{
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _pages.count, _scrollView.frame.size.height);
    _pageControl.center = CGPointMake(
            self.frame.size.width / 2.0f,
            self.frame.size.height - _pageControl.frame.size.height / 2.0f
    );
    //

    for (NSUInteger i = 0; i < _pages.count; i++)
    {
        BxIconWorkspacePageView * page = _pages[i];
        page.frame = CGRectMake(i * _scrollView.frame.size.width, 0.0f,
                _scrollView.frame.size.width,
                _scrollView.frame.size.height);
    }
}

- (void) initPages
{
    _pageControl.numberOfPages = _pages.count;
    //
    for (NSUInteger i = 0; i < _pages.count; i++)
    {
        BxIconWorkspacePageView * page = _pages[i];
        for (BxIconWorkspaceItemControl * icon in page.icons){
            [icon setOwner: self];
        }
        [_scrollView addSubview:page];
    }
    if (_pages.count > 0){
        _currentPage = _pages[0];
    }
    [self updatePages];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updatePages];
    [self updateIcons];
}

//! возвращает позицию иконки по расположению в пространстве, если она нечеткая то -1
- (long) getIconPositionFrom: (CGPoint) position {

    int index = (((int) position.y) / (int) _iconSize.height) * _maxColCount +
            ((int) position.x / (int) _iconSize.width);

    if (index < 0)
        return -1;

    if (index >= _currentPage.icons.count) {
        if (_currentPage.icons.count > 0) {
            return _currentPage.icons.count - 1;
        } else {
            return 0;
        }
    }

    if (fabs( (int)position.y % (int)_iconSize.height - _iconSize.height / 2 ) > _iconSize.height  / 3 ||
            fabs( (int)position.x % (int)_iconSize.width - _iconSize.width / 2 ) > _iconSize.width  / 3)
    {
        return -1;
    }

    return index;
}

//! todo на будущее, для расширения страниц
/*- (int) maxIconCountFromPage
{
    return ( (int) _scrollView.frame.size.width / (int)_iconSize.width ) *
            ( (int) _scrollView.frame.size.height / (int)_iconSize.height);
} */

- (void) addIcon: (BxIconWorkspaceItemControl*) icon fromPageIndex: (NSUInteger) pageIndex iconIndex: (NSUInteger) iconIndex
{
    BxIconWorkspacePageView * page = _pages[pageIndex];
    if (page.icons.count >= _maxRowCount)
    {
        if (pageIndex == _pages.count - 1)
            pageIndex = 0;
        else
            pageIndex++;
        BxIconWorkspaceItemControl* lastObject = [page.icons lastObject];
        [page.icons removeLastObject];
        [self addIcon: lastObject fromPageIndex: pageIndex iconIndex: 0];
    }
    [page insertIcon: icon atIndex: iconIndex];
}

- (void) addIcon: (BxIconWorkspaceItemControl*) icon
{
    NSUInteger index = [self currentPageIndex];
    int maxIconIndex = _maxRowCount - 1; // [self maxIconCountFromPage] - 1; - может это фича!!!
    while (_currentPage.icons.count > maxIconIndex)
    {
        index++;
        if (index >= _pages.count){
            int allCount = 0;
            for (BxIconWorkspacePageView * page in _pages)
            {
                allCount += page.icons.count;
            }
            [NSException raise: @"AddIconException" format: @"Ошибка добавления! Максимально возможное количество иконок: %lu У вас уже добавлено: %d", (long)(_maxRowCount * _pages.count), allCount];
        }
        _currentPage = _pages[index];
    }
    [self addIcon: icon fromPageIndex: index iconIndex: _currentPage.icons.count];
}

- (void) addIcon: (BxIconWorkspaceItemControl*) icon iconIndex: (NSUInteger) iconIndex
{
    [self addIcon: icon fromPageIndex: [self currentPageIndex] iconIndex: iconIndex];
}

- (BxIconWorkspacePageView*) pageFromIcon: (BxIconWorkspaceItemControl*) icon
{
    for (BxIconWorkspacePageView * page in _pages)
    {
        if ([page.icons containsObject: icon])
            return page;
    }
    return nil;
}

- (NSUInteger) currentPageIndex
{
    return [_pages indexOfObject:_currentPage];
}

- (void) checkPageForMovingPosition: (CGPoint) position
{
    if (position.x < 40.0f && [self currentPageIndex] > 0){
        [self changePageWithShift: -1];
    } else if (position.x > self.frame.size.width - 40.0f && [self currentPageIndex] < _pages.count - 1){
        [self changePageWithShift: 1];
    }
}

- (void) sortWithMoving: (BxIconWorkspaceItemControl*) icon
{
    BxIconWorkspacePageView * oldPage = [self pageFromIcon: icon];

    long index = [self getIconPositionFrom: icon.center];

    if (index > -1)
    {
        if (oldPage != _currentPage){
            [oldPage.icons removeObject: icon];
            [self addIcon: icon iconIndex: (NSUInteger)index];
            [self updateIcons];
        } else if ((_currentPage.icons)[(NSUInteger)index] != icon){
            [_currentPage.icons removeObject: icon];
            [_currentPage.icons insertObject: icon atIndex: (NSUInteger)index];
            [self updateIcons];
        }
    }
}

- (void) open
{
    if (!_currentFileName){
        return;
    }
    NSArray * temp = nil;
    @try {
        temp = (id) [[[BxPropertyListParser alloc] init] loadFromFile:_currentFileName];
    }
    @catch (NSException * e) {
        //
    }
    if (temp && temp.count > 0 && [temp[0] isKindOfClass:[NSArray class]]){
        if (temp.count > _pages.count){
            NSLog(@"BxIconWorkspaceView is not opened, page count is not corrected");
            return;
        }
        NSMutableArray * oldIcons = [NSMutableArray array];
        for (BxIconWorkspacePageView * page in _pages){
            for (BxIconWorkspaceItemControl * obj in page.icons)
            {
                [oldIcons addObject: obj];
            }
            [page.icons removeAllObjects];
        }

        for (NSUInteger pageIndex = 0; pageIndex < temp.count; pageIndex++){
            NSUInteger index = 0;
            for (NSString * idName in temp[pageIndex])
            {
                for (BxIconWorkspaceItemControl * obj in oldIcons)
                {
                    if ([obj.idName isEqualToString: idName]){
                        [self addIcon: obj fromPageIndex: pageIndex iconIndex: index];
                        [oldIcons removeObject: obj];
                        index++;
                        break;
                    }
                }
            }
        }
        for (BxIconWorkspaceItemControl * obj in oldIcons)
        {
            [self addIcon: obj];
        }
        NSLog(@"BxIconWorkspaceView is opened");
    } else{
        NSLog(@"BxIconWorkspaceView is not loaded!!!");
    }
}

- (void) save
{
    if (!_currentFileName){
        return;
    }
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity: _pages.count];
    for (BxIconWorkspacePageView * page in _pages){
        NSMutableArray * outPage = [NSMutableArray arrayWithCapacity: page.icons.count];
        for (BxIconWorkspaceItemControl * obj in page.icons)
        {
            [outPage addObject: obj.idName];
        }
        [temp addObject: outPage];
    }
    [BxFileSystem initDirectories: [self workDirPath]];
    [[[BxPropertyListParser alloc] init] saveFrom:(id) temp toPath:_currentFileName];
    NSLog(@"BxIconWorkspaceView is saved");
}

- (void)dealloc {
    //
}

@end
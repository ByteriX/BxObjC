//
//  BxItemsListViewController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 2/13/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "BxItemsListViewController.h"
#import "BxCommon.h"
#import "ItemsListPagingTabController.h"
#import "BxViewItemsList.h"

@interface BxItemsListViewController () <BxViewItemsListSource, BxViewItemsListDelegate>

@property (nonatomic, retain) NSArray * imageContentData;
@property (nonatomic) NSInteger contentMediaIndex;
@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) float itemSize;

@end

static const CGFloat MediaImageViewMargin = 0.0f;

@implementation BxItemsListViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.contentMediaIndex = 0;
    self.title = @"Список";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.imageContentData = @[//@"http://micahcochran.net/wp-content/uploads/2009/03/resume_rev20_large.png",
                              @"http://mporosneft.ru/assets/files/EGRUL.jpg",
                              //@"http://www.skincap.ru/uploads/docs/pismo.jpg",
                              @"http://s.4pda.to/wp-content/uploads/2013/05/photo-may-11-4-37-21-pm.png",
                              @"http://1.bp.blogspot.com/_SSG7FsV_wbc/S9BdQINy2lI/AAAAAAAAAcQ/fmIpFDKWk_E/s1600/%D0%A7%D0%B5%D1%85%D0%B8%D1%8F%2B%D0%BA%D0%BE%D0%BD%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D1%8F%2B-%2B%D0%B8%D1%81%D1%85%D0%BE%D0%B4%D0%BD%D1%8B%D0%B9%2B%D0%B4%D0%BE%D0%BA%D1%83%D0%BC%D0%B5%D0%BD%D1%82%2Bsm.jpg",
                              @"http://www.edou.ru/upload/learning/3/res29/U5MF9.Foq4n.Image21.jpg",
                              @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTMs4X41NAKYT5vBulH7xV65y51S0pvtO38CxaO3gUtjP5kWUhP"];
    
    self.itemsList = [[[BxViewItemsList alloc] initWithFrame: self.view.bounds] autorelease];
    self.itemsList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.itemsList.dataSource = self;
    self.itemsList.delegate = self;
    self.itemsList.bufferMinCount = 5;
    self.itemsList.isCentred = NO;
    self.itemsList.isScale = NO;
    self.itemsList.isVisualBordered = YES;
    self.itemsList.isCentredOfFull = YES;
    self.itemsList.inertial = 0.0;
    self.itemsList.backgroundColor = [UIColor grayColor];

    self.itemsCount = self.imageContentData.count;
    self.itemSize = 1.0f;

    [self.view addSubview: self.itemsList];
}

- (IBAction) updateClick:(id)sender
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary * data = [userDef objectForKey: fn_itemsList_DATA];
    if (data[fn_itemsList_inertial]){
        self.itemsList.inertial = [data[fn_itemsList_inertial] notNullFloat];
    }
    if (data[fn_itemsList_bufferMinCount]){
        self.itemsList.bufferMinCount = [data[fn_itemsList_bufferMinCount] notNullInt];
    }
    if (data[fn_itemsList_isCentred]){
        self.itemsList.isCentred = [data[fn_itemsList_isCentred] notNullBool];
    }
    if (data[fn_itemsList_isSticked]){
        self.itemsList.isSticked = [data[fn_itemsList_isSticked] notNullBool];
    }
    if (data[fn_itemsList_isScale]){
        self.itemsList.isScale = [data[fn_itemsList_isScale] notNullBool];
    }
    if (data[fn_itemsList_isVisualBordered]){
        self.itemsList.isVisualBordered = [data[fn_itemsList_isVisualBordered] notNullBool];
    }
    if (data[fn_itemsList_isCentredOfFull]){
        self.itemsList.isCentredOfFull = [data[fn_itemsList_isCentredOfFull] notNullBool];
    }
    if (data[fn_itemsList_orientatin]){
        self.itemsList.orientation = [data[fn_itemsList_orientatin] notNullInt];
    }
    if (data[fn_itemsList_itemsCount]){
        self.itemsCount = [data[fn_itemsList_itemsCount] notNullInt];
    }
    if (data[fn_itemsList_itemSize]){
        self.itemSize = [data[fn_itemsList_itemSize] notNullFloat];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self updateClick: nil];
    [self.itemsList updateWithIndex: self.contentMediaIndex];
}

- (NSUInteger) numberOfLayersInContentItemScroll: (BxViewItemsList*) viewItemsList
{
    return 1;
}

- (NSUInteger) viewItemsList: (BxViewItemsList*) viewItemsList numberOfItemsInLayer: (NSInteger) layer
{
    return self.itemsCount;
}

- (CGSize) viewItemsList: (BxViewItemsList*) viewItemsList sizeOfItemsInLayer: (NSUInteger) layer index: (NSUInteger) index
{
    index = index % self.imageContentData.count;
    NSString * url = self.imageContentData[index];
    if ([[BxLoadedImageViewItem casher] isCashed: url]) {
        
        CGFloat candidateHeight = viewItemsList.frame.size.height * self.itemSize - 2.0f * MediaImageViewMargin;
        
        CGFloat candidateWidth = viewItemsList.frame.size.width * self.itemSize - 2.0f * MediaImageViewMargin;
        
        NSString * chashedURL = [[BxLoadedImageViewItem casher] getLocalDownloadedPathFrom: url];
        UIImage * image = [UIImage imageWithContentsOfStringURL: chashedURL];
        if (image) {
            CGFloat width = image.size.width * candidateHeight / image.size.height;
            if (width < candidateWidth) {
                return CGSizeMake(truncf(width + 2.0f * MediaImageViewMargin), truncf(candidateHeight + 2.0f * MediaImageViewMargin));
            } else {
                return CGSizeMake(truncf(candidateWidth + 2.0f * MediaImageViewMargin), truncf(image.size.height * candidateWidth / image.size.width + 2.0f * MediaImageViewMargin));
            }
        }
    }
    return CGSizeMake(viewItemsList.frame.size.width / 2.0f * self.itemSize, viewItemsList.frame.size.height / 2.0f * self.itemSize);
}

- (UIView<BxViewItem>*) viewForViewItemsList: (BxViewItemsList*) viewItemsList layer: (NSUInteger) layer index: (NSUInteger) index
{
    index = index % self.imageContentData.count;
    NSString * url = self.imageContentData[index];
    UIView<BxViewItem>* view = [viewItemsList createBufferedViewWithIdentifier:@"Item"
                                                                      forLayer:layer
                                                                         index:index
                                                                       creator:
                                                                               ^UIView <BxViewItem> *() {
                                                                                   BxLoadedImagePageView<BxViewItem> *result = [[[BxLoadedImagePageView<BxViewItem> alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetHeight(viewItemsList.frame), CGRectGetHeight(viewItemsList.frame))] autorelease];
                                                                                   result.backgroundColor = [UIColor clearColor];
                                                                                   result.canCancelContentTouches = NO;
                                                                                   result.scrollEnabled = NO;
                                                                                   result.imageView.actionHandler = ^(BxLoadedImageViewItem *view) {
                                                                                       //
                                                                                   };
                                                                                   result.imageView.loadedHandler = ^(BxLoadedImageViewItem *view) {
                                                                                       [viewItemsList refreshAnimated: YES];
                                                                                   };
                                                                                   return result;
                                                                               }];
    BxLoadedImagePageView *mediaView = (BxLoadedImagePageView*)view;
    //mediaView.data = @(index);
    [mediaView.imageView setImageURL: url];
    [mediaView setDefaultState];
    
    mediaView.bouncesZoom = YES;
    mediaView.canCancelContentTouches = NO;

    
    return view;
}

- (void) viewItemsList: (BxViewItemsList*) viewItemsList changeLayer: (NSInteger) layer index: (NSInteger) index
{
    self.contentMediaIndex = index;
}

- (void) touthViewItemsList: (BxViewItemsList*) viewItemsList layer: (NSUInteger) layer index: (NSUInteger) index
{
    [BxAlertView showAlertWithTitle: nil message:[NSString stringWithFormat: @"Click with index: %@", @(index)]
                  cancelButtonTitle: @"OK" okButtonTitle:nil handler:nil];
}

@end

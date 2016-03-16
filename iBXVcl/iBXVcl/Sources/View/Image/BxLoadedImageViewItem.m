/**
 *	@file BxLoadedImageViewItem.m
 *	@namespace iBXVcl
 *
 *	@details Кешируемое изображение из сети
 *	@date 10.09.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxLoadedImageViewItem.h"
#import "BxCommon.h"

@interface BxLoadedImageViewItem ()

@end

@interface BxLoadedImageOperation : NSOperation

@property (nonatomic, assign) BxLoadedImageViewItem * target;
@property (nonatomic, retain) NSString * url;

@end

@implementation BxLoadedImageOperation

+ (id) operationWithUrl: (NSString*) url target: (BxLoadedImageViewItem*) target
{
    BxLoadedImageOperation * operation = [[[self.class alloc] init] autorelease];
    operation.url = url;
    operation.target = target;
    return operation;
}

- (void) main
{
    if (self.isCancelled) {
        return;
    }
    @autoreleasepool {
        @try {
            
            NSString * chashedURL = nil;
            chashedURL = [[[_target class] casher] getDownloadedPathFrom: self.url errorConnection:NO progress:nil];
            [self compliteWithImage: [UIImage imageWithContentsOfStringURL: chashedURL]];
        }
        @catch (NSException *exception) {
            NSLog(@"Error image downloading: %@", exception);
            [self compliteWithImage: [[_target class] notLoadedImage]];
        }
        @finally {
            //
        }
    }
}

- (void) cancel
{
    self.target = nil;
    [super cancel];
}

- (BOOL) isCancelled
{
    return [super isCancelled] || !self.target;
}

- (void) compliteWithImage: (UIImage*) image
{
    if (!self.isCancelled){
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.target.contentImage.image = image;
            [self.target.activityView stopAnimating];
            if (self.target.loadedHandler) {
                self.target.loadedHandler(self.target);
            }
        });
    }
}

- (void) dealloc
{
    self.target = nil;
    self.url = nil;
    [super dealloc];
}

@end

@implementation BxLoadedImageViewItem

@synthesize activityView = _activityView, contentImage = _contentImage;


+ (BxDownloadOldFileCasher*) casher
{
    static BxDownloadOldFileCasher * _casher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _casher = [[BxDownloadOldFileCasher allocWithZone: NULL] initWithName: @"LoadedImageViewItems"];
        _casher.isCheckUpdate = NO;
        _casher.isContaining = NO;
        _casher.extention = @"img";
    });
    return _casher;
}

+ (NSOperationQueue*) queue
{
    static dispatch_once_t onceToken;
    static NSOperationQueue* queue = nil;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount: 3];
    });
    return queue;
}

+ (UIImage*) notLoadedImage
{
    return nil;
}

- (BxLoadedImageOperation*) currentOperation
{
    NSArray * allOperation = [[self.class queue] operations];
    for (BxLoadedImageOperation* operation in allOperation) {
        if (operation.target && operation.target == self) {
            return operation;
        }
    }
    return nil;
}

+ (BxLoadedImageOperation*) operationWithUrl: url
{
    NSArray * allOperation = [[self queue] operations];
    for (BxLoadedImageOperation* operation in allOperation) {
        if (operation.url && [operation.url isEqualToString: url]) {
            return operation;
        }
    }
    return nil;
}

- (void) initObject
{
    _contentImage = [[UIImageView alloc] initWithFrame: self.bounds];
    _contentImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentImage.contentMode = UIViewContentModeScaleAspectFill;
    _contentImage.backgroundColor = [UIColor grayColor];
    _contentImage.clipsToBounds = YES;
    [self addSubview: _contentImage];
    [_contentImage release];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.hidesWhenStopped = YES;
    _activityView.center = CGPointMake(self.frame.size.width / 2.0f , self.frame.size.height / 2.0f);
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview: _activityView];
    [_activityView release];
    
    _btAction = [[UIButton alloc] initWithFrame: self.bounds];
    [_btAction addTarget: self action: @selector(btActionClick) forControlEvents: UIControlEventTouchUpInside];
    _btAction.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview: _btAction];
    [_btAction release];
    _btAction.hidden = YES;
}

- (void) setActionHandler:(BxLoadedImageViewItemHandler)actionHandler
{
    [_actionHandler autorelease];
    _actionHandler = [actionHandler copy];
    _btAction.hidden = _actionHandler == nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (void) btActionClick
{
    if (self.actionHandler) {
        self.actionHandler(self);
    }
}

+ (UIImage*) cashedImageFromURL: (NSString*) url
{
    if ([[self casher] isCashed: url]) {
        return [UIImage imageWithContentsOfStringURL: [[self.class casher] getLocalDownloadedPathFrom: url]];
    } else {
        return nil;
    }
}

- (void) setImageURL: (NSString*) url
{
    BxLoadedImageOperation * currentOperation = self.currentOperation;
    if (currentOperation) {
        if ([currentOperation.url isEqualToString: url] && _activityView.isAnimating) {
            return;
        }
    }
    [currentOperation cancel];
    BOOL isCashed = [[self.class casher] isCashed: url];
    if (isCashed) {
        NSString * chashedURL = [[self.class casher] getLocalDownloadedPathFrom: url];
        _contentImage.image = [UIImage imageWithContentsOfStringURL: chashedURL];
        [_activityView stopAnimating];
    } else {
        _contentImage.image = nil;
        [_activityView startAnimating];
        BxLoadedImageOperation * operation = [self.class operationWithUrl: url];
        //[operation cancel];
        BxLoadedImageOperation * newOperation = [BxLoadedImageOperation operationWithUrl: url target: self];
        if (operation) {
            [newOperation addDependency: operation];
        }
        [[self.class queue] addOperation: newOperation];
    }
}

- (void) dealloc
{
    [[self currentOperation] cancel];
    self.actionHandler = nil;
    self.loadedHandler = nil;
    [super dealloc];
}

@end

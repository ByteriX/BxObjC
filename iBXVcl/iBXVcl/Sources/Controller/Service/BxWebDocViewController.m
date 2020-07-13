/**
 *	@file BxWebDocViewController.m
 *	@namespace iBXVcl
 *
 *	@details Контроллер отображения HTML содержимого
 *	@date 17.08.2012
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxWebDocViewController.h"
#import "BxCommon.h"

#if IS_OS_SDK_8_ALLOWED

@interface BxWebDocViewController (WKNavigationDelegate) <WKNavigationDelegate>
{}
@end

#else

@interface BxWebDocViewController (UIWebViewDelegate) <UIWebViewDelegate>
{}
@end

#endif

@implementation BxWebDocViewController

+ (NSString*) extention
{
    return @"html";
}

+ (BxDownloadOldFileCasher*) defaultFileCash
{
    static BxDownloadOldFileCasher * defaultFileCash = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultFileCash = [[BxDownloadOldFileCasher allocWithZone: NULL] initWithName: @"WebDoc"];
        defaultFileCash.isCheckUpdate = NO;
        defaultFileCash.isContaining = YES;
        defaultFileCash.maxCashCount = 200;
        defaultFileCash.extention = [self extention];
    });
    return defaultFileCash;
}

/*- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}*/

#if IS_OS_SDK_8_ALLOWED

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self didLayoutContent];
}

#else

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
									 duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
    [self didLayoutContent];
}

#endif

- (void) didLayoutContent {
    if (_isReload) {
        [_content reload];
    } else {
        //
    }
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	[self.class defaultFileCash];
	
	_isLoad = NO;
    
    
    
#if IS_OS_SDK_8_ALLOWED
    
    // it is need to scale to Fit
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;

    _content = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    _content.navigationDelegate = self;
#else
    _content = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _content.delegate = self;
    _content.scalesPageToFit = isFit;
    //! Почему-то опцию определения телефона можно отключить только здесь:
    _content.dataDetectorTypes = UIDataDetectorTypeLink;
#endif
	
	_content.clipsToBounds = YES;
	_content.autoresizesSubviews= YES;
    
#if IS_OS_SDK_11_ALLOWED
    if IS_OS_11_OR_LATER {
        _content.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
	
	_content.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin | 
	UIViewAutoresizingFlexibleWidth |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleHeight |
	UIViewAutoresizingFlexibleBottomMargin;
	[self.view addSubview: _content];
	[_content release];
	_HUD = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: _HUD];
    [_HUD release];
}

- (void) setPath: (NSString*) path
{
	NSURL * url1 = [NSURL URLWithString: path];
	[_content loadRequest: [NSURLRequest requestWithURL: url1]];
}

- (void) setHTML: (NSString*) html baseUrl: (NSString*) rawBaseUrl
{
	_isReload = NO;
	//! Формирование представления
    [self showProgress];
    NSURL * baseURL = nil;
    if (rawBaseUrl && rawBaseUrl.length > 0) {
        baseURL = [NSURL URLWithString: rawBaseUrl];
    }
	[_content loadHTMLString: html baseURL: baseURL];
}

- (void) setHTML: (NSString*) html
{
	[self setHTML: html baseUrl: nil];
}

- (void) setUrl: (NSString*) url isFit: (BOOL) isFit
{
	_isReload = YES;
#if IS_OS_SDK_8_ALLOWED
#else
	_content.scalesPageToFit = isFit;
#endif
	[_url release];
	_url = [url retain];
    [self showProgress];
	[self setPath: url];
}

- (void) setUrl: (NSString*) url
{
	[self setUrl: url isFit: YES];
}

- (void) clear
{
    [_content stopLoading];
    [_content loadHTMLString: @"" baseURL: nil];
}

- (void) downloadWith: (NSString*) url1
{
    [self showProgress];
	[NSThread detachNewThreadSelector: @selector(downloadWithOnThread:) toTarget: self withObject: url1];
}

- (void) showProgressOnMain
{
    [self view];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([_HUD respondsToSelector: @selector(showAnimated:)]) {
        [_HUD showAnimated: YES];
#pragma clang diagnostic pop
#pragma clang diagnostic push
    } else {
#pragma clang diagnostic ignored "-Wdeprecated"
        [_HUD show: YES];
    }
#pragma clang diagnostic pop
}

- (void) showProgress
{
    [self performSelectorOnMainThread: @selector(showProgressOnMain)
                           withObject: nil
                        waitUntilDone: YES];
}

- (void) hideProgressOnMain
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wobjc-method-access"
    if ([_HUD respondsToSelector: @selector(hideAnimated:)]) {
        [_HUD hideAnimated: YES];
#pragma clang diagnostic pop
#pragma clang diagnostic push
    } else {
#pragma clang diagnostic ignored "-Wdeprecated"
        [_HUD hide: YES];
    }
#pragma clang diagnostic pop
}

- (void) hideProgress
{
    [self performSelectorOnMainThread: @selector(hideProgressOnMain)
                           withObject: nil
                        waitUntilDone: YES];
}

- (void) handleDownloadException: (NSException *) ex
{
    [BxAlertView showError: ex.reason];
}

- (void) downloadWithOnThread: (NSString*) url1
{
	_isReload = YES;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		NSLog(@"Load file with %@", url1);
		//Загрузка представления
		
		NSString * path = [[self.class defaultFileCash] getDownloadedPathFrom: url1
                                                              errorConnection: YES
                                                                     progress: nil];
		[self performSelectorOnMainThread: @selector(setPath:) 
							   withObject: path 
							waitUntilDone: YES];
	}
	@catch (NSException * e) {
		[self hideProgress];
		[self handleDownloadException: e];
	}
	@finally {
		[pool release];
	}
}

- (void) didStartLoad
{
    //
}

- (void) didFinishLoad
{
    _isLoad = YES;
    [self hideProgress];
}

- (void) failLoadWithError: (NSError*) error
{
    if (error.code != -999){
        [BxAlertView showError: [error localizedDescription]];
    }
    [self hideProgress];
}

- (void) waitForLoading
{
	[NSException raise: @"NotImplementException" format:@"...!!!Q"];
}

- (void) dealloc
{
    [_url autorelease];
    _url = nil;
    _HUD = nil;
    _content = nil;
    [super dealloc];
}

@end

#if IS_OS_SDK_8_ALLOWED

@implementation BxWebDocViewController (WKNavigationDelegate)

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self didStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self didFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self failLoadWithError: error];
}

@end

#else

@implementation BxWebDocViewController (UIWebViewDelegate)

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self didStartLoad];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self didFinishLoad];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self failLoadWithError: error];
}

@end

#endif

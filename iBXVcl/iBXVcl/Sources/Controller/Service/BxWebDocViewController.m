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

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
									 duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation: toInterfaceOrientation duration: duration];
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
	self.wantsFullScreenLayout = YES;
	
	_isLoad = NO;
	CGRect rect = self.view.frame;
	rect.origin.x = rect.origin.y = 0.0f;
	_content = [[UIWebView alloc] initWithFrame: rect];
	_content.delegate = self;
	
	_content.scalesPageToFit = NO;
	_content.clipsToBounds = YES;
	_content.autoresizesSubviews= YES;
	//! Почему-то опцию определения телефона можно отключить только здесь:
	_content.dataDetectorTypes = UIDataDetectorTypeLink;
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
	_content.scalesPageToFit = isFit;
	[_url release];
	_url = [url retain];
	//NSURL * urlLoc = [NSURL URLWithString: url];
	//if (![urlLoc isFileURL]) {
		[self showProgress];
	//}
	[self setPath: url];
	/*[NSThread detachNewThreadSelector: @selector(downloadWith:) 
							 toTarget: self 
						   withObject: url];*/
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
    [_HUD show: YES];
}

- (void) showProgress
{
    [self performSelectorOnMainThread: @selector(showProgressOnMain)
                           withObject: nil
                        waitUntilDone: YES];
}

- (void) hideProgressOnMain
{
    [_HUD hide: YES];
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

- (void) webViewDidStartLoad:(UIWebView *)webView
{
	//
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
	_isLoad = YES;
	[self hideProgress];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
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

- (void) viewDidUnload
{
	[_url autorelease];
	_url = nil;
    _HUD = nil;
    _content = nil;
	[super viewDidUnload];
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

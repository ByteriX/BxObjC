/**
 *	@file BxWebDocViewController.h
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

#import <Foundation/Foundation.h>
#import "BxBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BxData.h"
#if IS_OS_SDK_8_ALLOWED
    #import <WebKit/WebKit.h>
#endif

@interface BxWebDocViewController : BxBaseViewController {
    
@protected
#if IS_OS_SDK_8_ALLOWED
	WKWebView * _content;
#else
    UIWebView * _content;
#endif
	MBProgressHUD * _HUD;
	BOOL _isLoad;
	NSString * _url;
	BOOL _isReload;
}

+ (BxDownloadOldFileCasher*) defaultFileCash;

//! Следующие методы открывают изображения сразу на webKit
- (void) setUrl: (NSString*) url isFit: (BOOL) isFit;
- (void) setHTML: (NSString*) html baseUrl: (NSString*) rawBaseUrl;
- (void) setUrl: (NSString*) url;
- (void) setPath: (NSString*) path;
- (void) setHTML: (NSString*) html;

//! Загрузка осуществляется через кешер
- (void) downloadWith: (NSString*) url;

//! Метод обеспечивает синхранизацию загрузки контента
- (void) waitForLoading;



@end

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
#import "MBProgressHUD.h"
#import "BxData.h"

@interface BxWebDocViewController : BxBaseViewController <UIWebViewDelegate> {
    
@protected
	UIWebView * _content;
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

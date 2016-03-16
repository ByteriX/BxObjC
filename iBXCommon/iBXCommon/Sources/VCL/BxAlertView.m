/**
 *	@file BxAlertView.m
 *	@namespace iBXCommon
 *
 *	@details Диалоговое окно
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAlertView.h"
#import "BxCommon.h"

@interface BxAlertView ()

@property (nonatomic, copy) BxAlertHandler handler;

@end

@implementation BxAlertView

+ (void) showAlertWithTitle: (NSString *) title
                    message: (NSString *) message
          cancelButtonTitle: (NSString *) cancelButtonTitle
              okButtonTitle: (NSString *) okButtonTitle
                    handler: (BxAlertHandler) handler
{
    BxAlertView * alert = [[[self alloc] initWithTitle: title message: message delegate: nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: okButtonTitle, nil] autorelease];
    alert.delegate = alert;
    alert.handler = handler;
    if ([NSThread isMainThread]) {
        [alert show];
    } else {
        [alert performSelectorOnMainThread: @selector(show) withObject: nil waitUntilDone: YES];
    }
    
}

+ (void) showError: (NSString *) message
{
    [self showAlertWithTitle: StandartLocalString(@"Error") message: message cancelButtonTitle: @"OK" okButtonTitle: nil handler: nil];
}

+ (void) showErrorAndExit: (NSString *) message
{
    NSString * errorString = [message stringByAppendingString: StandartLocalString(@"\nThe application will be stopped!")];
    [self showAlertWithTitle: StandartLocalString(@"Critical error") message: errorString cancelButtonTitle: @"OK" okButtonTitle: nil handler: ^ (BOOL isOK)
    {
        exit(3); // завершаем приложение
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.handler) {
        self.handler(buttonIndex != 0);
    }
}

- (void) dealloc
{
    self.handler = nil;
    [super dealloc];
}

@end

/**
 *	@file BxPushNotificationMessageQueue.m
 *	@namespace iBXCommon
 *
 *	@details Очередь удаленных нотификаций
 *	@date 29.11.2015
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxPushNotificationMessageQueue.h"
#import "BxCommon.h"

@interface BxPushNotificationAlert : UIAlertView

@property (nonatomic, strong) NSDictionary * data;

@end

@interface BxPushNotificationMessageQueue (){
@protected
	NSMutableArray * _queue;
	BOOL _isActive;
	BxPushNotificationAlert * _alert;
	UIAlertView * _errorAlert;
}

@property (nonatomic, strong) UIApplication * application;
@property (nonatomic, strong) NSDictionary * actions;

@end

@implementation BxPushNotificationMessageQueue

- (id) init
{
	if (self = [super init]) {
		_isActive = NO;
		_queue = [[NSMutableArray alloc] initWithCapacity: 8];
		_alert = [[BxPushNotificationAlert alloc] initWithTitle: @""
										message: @""
									   delegate: self
							  cancelButtonTitle: @"Закрыть"
							  otherButtonTitles: @"Просмотр", nil];
		_errorAlert = [[UIAlertView alloc] initWithTitle: @"" message: @""
											   delegate: nil cancelButtonTitle: @"OK"
									  otherButtonTitles: nil];
    }
	return self;
}

- (id) initWithApplication: (UIApplication*) application actionHandler: (BxPushNotificationHandler) actionHandler
{
    if (self = [self init]) {
		self.application = application;
        self.actionHandler = actionHandler;
	}
	return self;
}

- (void) registerTypes: (UIUserNotificationType) types categories:(NSSet *)categories
{
    if (IS_OS_8_OR_LATER){
        UIUserNotificationSettings *noteSettings = [UIUserNotificationSettings settingsForTypes: types categories: categories];
        [_application registerUserNotificationSettings: noteSettings];
        [_application registerForRemoteNotifications];
    } else {
        [_application registerForRemoteNotificationTypes: (UIRemoteNotificationType)types];
    }
}

static NSString * FNBxDeviceToken = @"DiviceTokenForPushNotificationService";

+ (NSString*) deviceToken
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * deviceToken = [userDefault stringForKey: FNBxDeviceToken];
    if (deviceToken)
        return deviceToken;
    else
        return @"";
}

+ (NSString*) deviceTokenFromData: (NSData*) webDeviceToken
{
    NSString *deviceToken = [[webDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deviceToken;
}

- (BOOL) pushAndCheckFromDouble: (NSDictionary*) data
{
	@synchronized(self){
		//
	}
	return NO;
}

- (void) showNotificationWithData: (NSDictionary*) data
{
	if (self.actionHandler) {
        self.actionHandler(data);
    }
}

- (void) notShowNotificationWithData: (NSDictionary*) data
{
    if (self.skippedActionHandler) {
        self.skippedActionHandler(data);
    }
}

- (void) showMessage: (NSString*) message
{
	if (_errorAlert.visible){
		[_errorAlert dismissWithClickedButtonIndex: 0 animated: NO];
	}
	_errorAlert.title = @"Внимание";
	_errorAlert.message = message;
	[_errorAlert show];
}

- (BOOL) checkNotificationFromLaunchOptions: (NSDictionary*) launchOptions
{
    if (launchOptions){
		NSDictionary * notificationInfo =  [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
		if (notificationInfo) {
			[self catchNotificationApplication: self.application withData: notificationInfo withAlert: NO];
            return YES;
		}
	}
    return NO;
}

- (void) catchNotification:(NSDictionary *) userInfo
{
    [self catchNotificationApplication: self.application withData: userInfo withAlert: YES];
}

- (void) catchNotificationApplication: (UIApplication *)application
							 withData: (NSDictionary *) userInfo
							withAlert: (BOOL) withAlert
{
	if ([application respondsToSelector: @selector(applicationState)]) {
		withAlert = withAlert && application.applicationState ==  UIApplicationStateActive;
	}
	for (id key in userInfo) {
		NSLog(@"key: %@, value: %@", key, [userInfo objectForKey: key]);
    }
	
	NSDictionary * aps = [userInfo objectForKey: @"aps"];
	NSString * message = [aps objectForKey: @"alert"];
    if ([message isKindOfClass: NSDictionary.class]) {
        message = [(NSDictionary*)message objectForKey: @"body"];
    }
	int badge = [[aps objectForKey: @"badge"] intValue];
    
    
	
    NSLog(@"badge = %d", badge);

    NSDictionary * data = userInfo;
	
	//NSString * currentGuid = [self.class deviceGUID];
    //NSString * guid = data[@"guid"];
    BOOL isCheckGUID = YES;//(guid == nil || [guid isEqualToString: currentGuid]);
    
	if (isCheckGUID ) {
		if ( withAlert ) {
            if (self.inAppShowHandler && !self.inAppShowHandler(data)) {
                [self notShowNotificationWithData: data];
            } else {
                NSString * titleAlert = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (_alert.visible) {
                    [_alert dismissWithClickedButtonIndex: 0 animated: NO];
                    titleAlert = [titleAlert stringByAppendingString: @" (последнее)"];
                }
                _alert.title = titleAlert;
                _alert.message = message;
                _alert.data = data;
                _alert.delegate = self;
                [_alert show];
            }
		} else {
			[self showNotificationWithData: data];
		}
	} else {
        [self notShowNotificationWithData: data];
    }
}

- (void)alertView:(UIAlertView *)currentAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary * data = ((BxPushNotificationAlert*)currentAlert).data;
	if (buttonIndex == 1){
		[self showNotificationWithData: data];
	} else {
        [self notShowNotificationWithData: data];
    }
}

- (void) checkUpdatePushNotificationsInfo
{
    //
}

- (void) updateDeviceToken: (NSString*) deviceTokenString
{
    if (deviceTokenString) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue: deviceTokenString forKey: FNBxDeviceToken];
        [userDefault synchronize];
        __weak BxPushNotificationMessageQueue * this = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @try {
                [this checkUpdatePushNotificationsInfo];
            }
            @catch (NSException *exception) {
                NSLog(@"Error in registration token: %@", exception);
            }
        });
    } else {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey: FNBxDeviceToken];
        [userDefault synchronize];
    }
}

- (void) testWithText: (NSString*) text params: (NSDictionary*) params delay: (NSTimeInterval) delay
{
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity: 16];
    [result addEntriesFromDictionary: @{@"aps": @{
                                                @"alert" : @{
                                                        @"body" : text
                                                        }
                                                },
                                        }];
    [result addEntriesFromDictionary: params];
    [self performSelector: @selector(catchNotification:) withObject: result afterDelay: delay];
}

- (void) dealloc
{
    self.skippedActionHandler = nil;
    self.actionHandler = nil;
    self.application = nil;
}

@end

@implementation BxPushNotificationAlert

- (void) dealloc
{
	self.data = nil;
}

@end

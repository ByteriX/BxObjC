//
// Created by Balalaev Sergey on 3/11/15.
// Copyright (c) 2015 ByteriX. All rights reserved.
//

#import "TestFunctionController.h"
#import "BxData.h"
#import "BxAlertView.h"


@implementation TestFunctionController


- (IBAction) btParseAction: (id) sender
{
    BxJsonKitDataParser * parser = [BxJsonKitDataParser new];
    NSDictionary * data = @{
            @"number_int" : @50,
            @"number_float" : @1.8,
            @"string" : @"string text"
    };
    NSString * st = [parser getStringFrom: data];
    NSDictionary * newData = [parser dataFromString: st];
    [BxAlertView showAlertWithTitle: @"ooo!"
                            message: [NSString stringWithFormat: @"%@", newData]
                  cancelButtonTitle: @"OK"
                      okButtonTitle: nil
                            handler: nil];
}

- (IBAction) btServiceAction: (id) sender
{
    /*dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            BxServiceDataCommand * command = [[BxServiceDataCommand alloc] initWithUrl: @"http://api.openweathermap.org/data/2.5/forecast?id=524901&appid=2de143494c0b295cca9337e1e96b00e0" data: nil caption: @""];
            command.parser = [BxJsonKitDataParser new];
            [command execute];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [BxAlertView showAlertWithTitle: @"Message" message: [NSString stringWithFormat:@"%@", command.rawResult] cancelButtonTitle: @"OK" okButtonTitle: nil handler:nil];
            });
        }
        @catch (NSException *exception) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [BxAlertView showAlertWithTitle: @"Error" message: exception.reason cancelButtonTitle: @"OK" okButtonTitle: nil handler:nil];
            });
            
        }
    });*/
    
    BxServiceDataCommand * command = [[BxServiceDataCommand alloc] initWithUrl: @"http://api.openweathermap.org/data/2.5/forecast?id=524901&appid=2de143494c0b295cca9337e1e96b00e0" data: nil caption: @""];
    command.parser = [BxJsonKitDataParser new];
    [command executeWithSuccess:
     ^(id command) {
         [BxAlertView showAlertWithTitle: @"Message" message: [NSString stringWithFormat:@"%@", ((BxServiceDataCommand*)command).rawResult] cancelButtonTitle: @"OK" okButtonTitle: nil handler:nil];
     }
                   errorHandler: ^(NSError * error){
                       [BxAlertView showAlertWithTitle: @"Error" message: error.localizedDescription cancelButtonTitle: @"OK" okButtonTitle: nil handler:nil];
                   }
                  cancelHandler: nil];
}

@end
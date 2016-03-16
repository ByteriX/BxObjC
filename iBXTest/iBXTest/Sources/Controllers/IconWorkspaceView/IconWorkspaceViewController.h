//
// Created by Balalaev Sergey on 9/29/14.
// Copyright (c) 2014 ByteriX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BxVcl.h"


@interface IconWorkspaceViewController : UIViewController <BxIconWorkspaceDelegate>

@property(nonatomic, weak) IBOutlet BxIconWorkspaceView *iconWorkspaceView;

@end
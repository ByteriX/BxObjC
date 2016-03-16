//
//  BxItemsListViewController.h
//  iBXTest
//
//  Created by Balalaev Sergey on 2/13/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsListSettingsController.h"
#import "BxVcl.h"

@interface BxItemsListViewController : UIViewController <ItemsListOwner>

@property (nonatomic, retain) IBOutlet BxViewItemsList * itemsList;

@end

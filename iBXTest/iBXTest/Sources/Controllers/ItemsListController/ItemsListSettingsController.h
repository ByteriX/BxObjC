//
//  ItemsListSettingsController.h
//  iBXTest
//
//  Created by Balalaev Sergey on 2/13/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BxVcl.h"

@protocol ItemsListOwner <NSObject>

@property (nonatomic, readonly) BxViewItemsList * itemsList;;

@end

@interface ItemsListSettingsController : UIViewController

@property (nonatomic, weak) id<ItemsListOwner> owner;

@property(nonatomic, weak) IBOutlet UIStepper *bufferMinCountStepper;
@property(nonatomic, weak) IBOutlet UILabel *bufferMinCountLabel;
@property(nonatomic, weak) IBOutlet UISwitch *isCentredSwitch;
@property(nonatomic, weak) IBOutlet UISwitch *isScaleSwitch;
@property(nonatomic, weak) IBOutlet UISwitch *isVisualBorderedSwitch;
@property(nonatomic, weak) IBOutlet UISwitch *isCentredOfFullSwitch;
@property(nonatomic, weak) IBOutlet UISegmentedControl *orientationControl;

- (IBAction)updateBufferMinCount:(UIStepper *)sender;

- (IBAction)updateInertial:(UISlider *)sender;

@property(nonatomic, weak) IBOutlet UISwitch *isStickedSwitch;
@property(nonatomic, weak) IBOutlet UILabel *inertialLabel;
@property(nonatomic, weak) IBOutlet UISlider *inertialSlider;

@property(nonatomic, weak) IBOutlet UIStepper *itemsCountStepper;
@property(nonatomic, weak) IBOutlet UILabel *itemsCountLabel;
@property(nonatomic, weak) IBOutlet UILabel *itemSizeLabel;
@property(nonatomic, weak) IBOutlet UISlider *itemSizeSlider;
- (IBAction)updateItemsCount:(UIStepper *)sender;
- (IBAction)updateItemSize:(UISlider *)sender;


@end

//
//  ItemsListSettingsController.m
//  iBXTest
//
//  Created by Balalaev Sergey on 2/13/14.
//  Copyright (c) 2014 ByteriX. All rights reserved.
//

#import "ItemsListSettingsController.h"
#import "ItemsListPagingTabController.h"

@interface ItemsListSettingsController ()

@end

@implementation ItemsListSettingsController

- (void) awakeFromNib
{
    self.title = @"Настройки";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) updateClick:(id)sender
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary * data = [userDef objectForKey: fn_itemsList_DATA];
    if (data[fn_itemsList_inertial]){
        self.inertialSlider.value = [data[fn_itemsList_inertial] notNullFloat];
        self.inertialLabel.text =  [NSString stringWithFormat: @"%2.2f", [data[fn_itemsList_inertial] doubleValue]];
    }
    if (data[fn_itemsList_bufferMinCount]){
        self.bufferMinCountStepper.value = [data[fn_itemsList_bufferMinCount] notNullInt];
        self.bufferMinCountLabel.text =  [NSString stringWithFormat: @"%@", data[fn_itemsList_bufferMinCount]];
    }
    if (data[fn_itemsList_isCentred]){
        self.isCentredSwitch.on = [data[fn_itemsList_isCentred] notNullBool];
    }
    if (data[fn_itemsList_isScale]){
        self.isScaleSwitch.on = [data[fn_itemsList_isScale] notNullBool];
    }
    if (data[fn_itemsList_isVisualBordered]){
        self.isVisualBorderedSwitch.on = [data[fn_itemsList_isVisualBordered] notNullBool];
    }
    if (data[fn_itemsList_isCentredOfFull]){
        self.isCentredOfFullSwitch.on = [data[fn_itemsList_isCentredOfFull] notNullBool];
    }
    if (data[fn_itemsList_orientatin]){
        self.orientationControl.selectedSegmentIndex = [data[fn_itemsList_orientatin] notNullInt];
    }
    if (data[fn_itemsList_isSticked]){
        self.isStickedSwitch.on = [data[fn_itemsList_isSticked] notNullBool];
    }

    if (data[fn_itemsList_itemsCount]){
        self.itemsCountStepper.value = [data[fn_itemsList_itemsCount] notNullInt];
        self.itemsCountLabel.text =  [NSString stringWithFormat: @"%d", [data[fn_itemsList_itemsCount] notNullInt]];
    }
    if (data[fn_itemsList_itemSize]){
        self.itemSizeSlider.value = [data[fn_itemsList_itemSize] notNullFloat];
        self.itemSizeLabel.text =  [NSString stringWithFormat: @"%2.2f", [data[fn_itemsList_itemSize] doubleValue]];
    }
}

- (IBAction) saveClick:(id)sender
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithCapacity: 32];
    data[fn_itemsList_inertial] = @(self.inertialSlider.value);
    data[fn_itemsList_bufferMinCount] = @(self.bufferMinCountStepper.value);
    data[fn_itemsList_isCentred] = @(self.isCentredSwitch.on);
    data[fn_itemsList_isSticked] = @(self.isStickedSwitch.on);
    data[fn_itemsList_isScale] = @(self.isScaleSwitch.on);
    data[fn_itemsList_isVisualBordered] = @(self.isVisualBorderedSwitch.on);
    data[fn_itemsList_isCentredOfFull] = @(self.isCentredOfFullSwitch.on);
    data[fn_itemsList_orientatin] = @(self.orientationControl.selectedSegmentIndex);
    data[fn_itemsList_itemsCount] = @(self.itemsCountStepper.value);
    data[fn_itemsList_itemSize] = @(self.itemSizeSlider.value);
    [userDef setObject: data forKey: fn_itemsList_DATA];
    [userDef synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self updateClick: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self saveClick: nil];
}

- (IBAction)updateBufferMinCount:(UIStepper *)sender {
    self.bufferMinCountLabel.text = [NSString stringWithFormat: @"%d", (int)self.bufferMinCountStepper.value];
}

- (IBAction)updateInertial:(UISlider *)sender {
    self.inertialLabel.text =  [NSString stringWithFormat: @"%2.2f", (double)self.inertialSlider.value];
}

- (IBAction)updateItemsCount:(UIStepper *)sender
{
    self.itemsCountLabel.text = [NSString stringWithFormat: @"%d", (int)self.itemsCountStepper.value];
}
- (IBAction)updateItemSize:(UISlider *)sender
{
    self.itemSizeLabel.text = [NSString stringWithFormat: @"%2.2f", (double)self.itemSizeSlider.value];
}

@end

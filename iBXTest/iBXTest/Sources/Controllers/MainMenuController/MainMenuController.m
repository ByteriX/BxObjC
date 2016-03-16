//
//  SettingsViewController.m
//  MoscowWC
//
//  Created by Balalaev Sergey on 10/3/13.
//  Copyright (c) 2013 Altarix. All rights reserved.
//

#import "MainMenuController.h"
#import "InitialSlidingViewController.h"
#import "CommonMenuItemCell.h"
#import "BxServiceController.h"
#import "SmallBxOldInputTableController.h"

@interface MainMenuController ()

@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) NSIndexPath * selectedIndexPath;
@property (nonatomic, retain) NSMutableDictionary * loadedControllers;

@end

@implementation MainMenuController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        self.menuItems = [self.class getMenuItems];
        self.loadedControllers = [NSMutableDictionary dictionary];
        self.selectedIndexPath = [NSIndexPath indexPathForRow: 1 inSection: 0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.layer.cornerRadius = MainViewCornerRadius;
    
    self.view.clipsToBounds = YES;
    self.view.superview.backgroundColor = [UIColor blackColor];
    self.slidingViewController.topViewController = [self selectedController];
    
    //[self.slidingViewController setAnchorRightRevealAmount: 280];
    //self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

+ (NSArray*) getMenuItems
{
    //BxServiceTestController
    return @[
             @{@"title" : @"Тестовые контроллеры",
               @"items": @[
                       @{
                               @"title" : @"Функции",
                               @"identifier" : @"TestFunctionController"
                       },
                       @{
                               @"title" : @"JCMSegmentPageController",
                               @"identifier" : @"JCMSegmentPageController"
                       },
                       @{
                           @"title" : @"BxOldInputTableController",
                           @"identifier" : @"BxOldInputTableController"
                           },
                       @{
                           @"title" : @"SmallBxOldInputTableController",
                           @"selector" : @"showSmallInput"
                           },
                       @{
                           @"title" : @"BxKeyboardController",
                           @"identifier" : @"BxKeyboardController"
                           },
                       @{
                             @"title" : @"BxServiceTestController",
                             @"selector" : @"showBxServiceTestController"
                       }
                       ]
               },
             @{@"title" : @"Загрузки картинок",
               @"items": @[
                       
                       @{
                           @"identifier" : @"BxLoadedImageViewItemTableController",
                           @"title" : @"BxLoadedImageViewItem",
                           }
                       ]
               },
             @{@"title" : @"Базовые контролеры",
               @"items": @[
                       
                       @{
                           @"identifier" : @"NavigationTestController",
                           @"title" : @"NavigationTestController",
                           }
                       ]
               },
             @{@"title" : @"Визуальные компоненты",
               @"items": @[
                       
                       @{
                           @"identifier" : @"BxViewItemsList+BxPageController",
                           @"title" : @"BxViewItemsList+BxPageController",
                           },
                       @{
                             @"identifier" : @"BxIconWorkspaceView",
                             @"title" : @"BxIconWorkspaceView",
                       },
                       @{
                           @"title" : @"TestWebDocViewController",
                           @"identifier" : @"TestWebDocViewController"
                           }
                       ]
               }
             ];
}

- (void) showBxServiceTestController
{
    BxServiceController * controller = [self.storyboard instantiateViewControllerWithIdentifier: @"BxServiceTestController"];
    [controller presentFromParent: self animated: YES];
}

- (void) showSmallInput
{
    SmallBxOldInputTableController * controller = [self.storyboard instantiateViewControllerWithIdentifier: @"SmallBxOldInputTableController"];
    [self presentViewController: controller animated: YES completion: nil];
}

- (void) setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    [_selectedIndexPath autorelease];
    _selectedIndexPath = [selectedIndexPath retain];
    [self.tableView selectRowAtIndexPath: selectedIndexPath animated: NO scrollPosition: UITableViewScrollPositionMiddle];
}

- (UIViewController *) controllerFrom: (NSIndexPath*) indexPath
{
    NSMutableDictionary * item = self.menuItems[indexPath.section][@"items"][indexPath.row];
    NSString * id = item[@"identifier"];
    if (id) {
        UIViewController * result = [self.loadedControllers objectForKey: id];
        if (!result) {
            result = [self.storyboard instantiateViewControllerWithIdentifier: id];
            if (result) {
                [self.loadedControllers setObject: result forKey: id];
            }
        }
        return result;
    } else {
        return nil;
    }
}

- (UIViewController *) selectedController
{
    return [self controllerFrom: _selectedIndexPath];
}

- (void) updateSelectedNow
{
    [self.tableView selectRowAtIndexPath: _selectedIndexPath animated: YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void) updateSelected
{
    [self performSelector: @selector(updateSelectedNow) withObject: nil afterDelay: 0.5];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self updateSelected];
    self.tableView.allowsSelection = YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonMenuItemCell * cell = [tableView dequeueReusableCellWithIdentifier: @"CommonMenuItemCell"];
    NSDictionary * item = self.menuItems[indexPath.section][@"items"][indexPath.row];
    cell.captionLabel.text = item[@"title"];
    //cell.iconView.image = [UIImage imageNamed: item[@"imageNamed"]];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary * item = self.menuItems[section];
    if ([item[@"title"] length] > 0) {
        return 21.0f;
    }
	return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.menuItems[sectionIndex][@"items"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * item = self.menuItems[section];
    return item[@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.allowsSelection = NO;
    
    UIViewController *newTopViewController = [self controllerFrom: indexPath];
    NSDictionary * item = self.menuItems[indexPath.section][@"items"][indexPath.row];
    NSString * selectorName = item[@"selector"];
    if (selectorName) {
        SEL sel = NSSelectorFromString(selectorName);
        [self performSelector: sel withObject: newTopViewController];
    }
    if (newTopViewController) {
        self.selectedIndexPath = indexPath;        
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
        
    } else {
        [tableView selectRowAtIndexPath: self.selectedIndexPath animated: YES scrollPosition: UITableViewScrollPositionNone];
    }
}

- (void) searchClick
{
    //[Error notCorrect: @"Search not implemented"];
    [self updateSelectedNow];
}

- (void) dealloc
{
    self.loadedControllers = nil;
    self.menuItems = nil;
    self.selectedIndexPath = nil;
    [super dealloc];
}

@end

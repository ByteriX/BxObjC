/**
 *	@file BxActionSheet.m
 *	@namespace iBXCommon
 *
 *	@details Suggest for action
 *	@date 04.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxActionSheet.h"

@interface BxActionSheet ()

@property (nonatomic, copy) BxActionSheetHandler handler;

@end

@implementation BxActionSheet

+ (void) showActionSheetWithTitle: (NSString *) title
                cancelButtonTitle: (NSString *) cancelButtonTitle
                otherButtonTitles: (NSArray *) otherButtonTitles
                             view: (UIView*) view
                          handler: (BxActionSheetHandler) handler

{
    BxActionSheet * result = [[[self alloc] initWithTitle: title
                                                 delegate: nil
                                        cancelButtonTitle: nil
                                   destructiveButtonTitle: nil
                                        otherButtonTitles: nil] autorelease];
    result.handler = handler;
    for (NSString * bt in otherButtonTitles) {
        [result addButtonWithTitle: bt];
    }
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        [result addButtonWithTitle: cancelButtonTitle];
        result.cancelButtonIndex = otherButtonTitles.count;
    }
    result.delegate = result;
    result.actionSheetStyle = UIActionSheetStyleDefault;
    result.tag = 0;
    [result showInView: view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.handler) {
        self.handler(buttonIndex);
    }
}

- (void) dealloc
{
    self.handler = nil;
    [super dealloc];
}

@end

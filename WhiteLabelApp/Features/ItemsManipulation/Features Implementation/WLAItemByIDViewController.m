//
//  WLAItemByIDViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemByIDViewController.h"

@interface WLAItemByIDViewController ()

@end

@implementation WLAItemByIDViewController
{
    UIButton *_readByIdItemButton;
    UITextField *_idField;
}

-(void)buildUI
{
    NSString *homeItemId = [WLAGlobalSettings sharedInstance].WLAHomeItemId;
    self->_idField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 10, 270, 50)
                                                   placeholder:NSLocalizedString(@"type item id here", nil)
                                                          text:homeItemId];
    [self addSubview: self->_idField];
    
    self->_readByIdItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 270, 50)
                                                                 title:NSLocalizedString(@"Item by id", nil)
                                                                target:self
                                                              selector:@selector(readItemById)];
    [self addSubview: self->_readByIdItemButton];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)readItemById
{
    if ( [self->_idField.text length] > 0 )
    {
        [self.context readItemOperationForItemId:self->_idField.text](^(id result, NSError *error)//read item to cache
                                                               {
                                                                   [self proceedItemReadResult:result error:error];
                                                               });
    }
    else
    {
        [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Please fill id field first", nil)];
    }
}

@end

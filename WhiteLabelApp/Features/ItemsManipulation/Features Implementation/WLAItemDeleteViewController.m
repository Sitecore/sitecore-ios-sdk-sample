//
//  WLAItemDeleteViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemDeleteViewController.h"

@interface WLAItemDeleteViewController ()

@end

@implementation WLAItemDeleteViewController
{
    UIButton *_deleteItem;
    UITextField *_idField;
}

-(void)buildUI
{
    NSString *homeId = [WLAGlobalSettings sharedInstance].WLAHomeItemId;
    
    self->_idField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 10, 270, 50)
                                                 placeholder:NSLocalizedString(@"type item id here", nil)
                                                        text:homeId];
    [self addSubview: self->_idField];
    
    self->_deleteItem = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 270, 50)
                                                              title:NSLocalizedString(@"Remove item", nil)
                                                             target:self
                                                           selector:@selector(readItemById)];
    [self addSubview: self->_deleteItem];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)readItemById
{
    __block WLAItemDeleteViewController *weakSelf = self;
    
    if ( [self->_idField.text length] > 0 )
    {
        [self.context readItemOperationForItemId:self->_idField.text](^(SCItem *result, NSError *error)//read item to cache
                                                               {
                                                                   if (error)
                                                                   {
                                                                       [WLAAlertsHelper showErrorAlertWithError:error];
                                                                   }
                                                                   else
                                                                   {
                                                                       [weakSelf deleteItem:result];
                                                                   }
                                                               });
    }
    else
    {
        [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Please fill path field first", nil)];
    }
}

-(void)deleteItem:(SCItem *)item
{
    if (!item)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Item not exists", nil)];
        return;
    }
    
    [item removeItem](^(SCItem *removedItem, NSError *error)
                                    {
                                        if (!error)
                                        {
                                            NSMutableString *message = [NSMutableString stringWithString:NSLocalizedString(@"Item was successfully removed", nil)];
                                            [message appendFormat:@"\nitem path: %@", item.path];
                                            [message appendFormat:@"\nitem name: %@", item.displayName];
                                            
                                            [WLAAlertsHelper showMessageAlertWithText:message];
                                        }
                                        else
                                        {
                                            [WLAAlertsHelper showErrorAlertWithError:error];
                                        }
                                    });
}

@end

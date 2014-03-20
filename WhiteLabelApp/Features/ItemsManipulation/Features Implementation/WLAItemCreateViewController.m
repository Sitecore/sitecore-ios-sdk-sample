//
//  WLAItemCreateViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemCreateViewController.h"

@interface WLAItemCreateViewController ()

@end

@implementation WLAItemCreateViewController
{
    UIButton *_createItemButton;
    UIButton *_editItemButton;
    UITextField *_titleField;
    UITextField *_textField;
    UITextField *_itemPathField;
    
    SCItem *_createdItem;
}

-(void)buildUI
{
    self->_titleField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 10, 270, 50)
                                                    placeholder:NSLocalizedString(@"type item title here", nil)
                                                           text:@"test item title"];
    [self addSubview: self->_titleField];
    self->_titleField.delegate = self;
    
    self->_textField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 70, 270, 50)
                                                   placeholder:NSLocalizedString(@"type item text here", nil)
                                                          text:@"test item text"];
    [self addSubview: self->_textField];
    self->_textField.delegate = self;
    
     NSString *dataSourceRoot = [WLAGlobalSettings sharedInstance].WLAWhiteLabelDataSourceRoot;
    
    self->_itemPathField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 130, 270, 50)
                                                       placeholder:NSLocalizedString(@"type path to create item", nil)
                                                              text:dataSourceRoot];
    [self addSubview: self->_itemPathField];
    self->_itemPathField.delegate = self;
    
    self->_createItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 190, 270, 50)
                                                                 title:NSLocalizedString(@"Create item", nil)
                                                                target:self
                                                              selector:@selector(createItem)];
    [self addSubview: self->_createItemButton];
    self->_editItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 250, 270, 50)
                                                             title:NSLocalizedString(@"Edit item", nil)
                                                            target:self
                                                          selector:@selector(editItem)];
    [self addSubview: self->_editItemButton];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)createItem
{
    NSString* itemPath  = [WLAGlobalSettings sharedInstance].WLAWhiteLabelDataSourceRoot;;
    SCCreateItemRequest *request = [SCCreateItemRequest requestWithItemPath:itemPath];
    
    request.itemName = @"api Item test";
    request.itemTemplate = @"Sample/Sample Item";
    
    request.fieldsRawValuesByName = @{@"Title": self->_titleField.text,
                                      @"Text": self->_textField.text };
    
    request.fieldNames = [NSSet setWithObjects:@"Title", @"Text", nil];
    
    [self.context createItemsOperationWithRequest:request](^(SCItem *item, NSError *error)
                                                {
                                                    if (item)
                                                    {
                                                        NSMutableString *message = [NSMutableString stringWithString:NSLocalizedString(@"Item was successfully created", nil)];
                                                        [message appendFormat:@"\nitem path: %@", item.path];
                                                        [message appendFormat:@"\nitem name: %@", item.displayName];
                                                        [WLAAlertsHelper showMessageAlertWithText:message];
                                                        self->_createdItem = item;
                                                    }
                                                    else
                                                    {
                                                        [WLAAlertsHelper showErrorAlertWithError:error];
                                                    }
                                                    
                                                });
}

-(void)editItem
{
    if (!_createdItem)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Create item first", nil)];
        return;
    }
    
    if (self->_titleField.text.length < 1)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Type new title, please", nil)];
        return;
    }
    
    SCField *titleField = [self->_createdItem fieldWithName:@"Title"];
    
    titleField.rawValue = self->_titleField.text;
    
    SCField *textField = [self->_createdItem fieldWithName:@"Text"];
    
    textField.rawValue = self->_textField.text;
    
    [self->_createdItem saveItemOperation](^(SCItem *editedItem, NSError *error)
                                  {
                                      if (!error)
                                      {
                                          self->_createdItem = editedItem;
                                          [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Item was successfully changed", nil)];
                                      }
                                      else
                                      {
                                          [WLAAlertsHelper showErrorAlertWithError:error];
                                      }
                                  });
}


@end

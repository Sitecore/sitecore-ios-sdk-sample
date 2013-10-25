//
//  WLAItemsViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/17/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAItemsViewController.h"

@interface WLAItemsViewController ()

@end

@implementation WLAItemsViewController
{
    UIButton *_addItemButton;
    UIButton *_readByPathItemButton;
    UIButton *_readByIdItemButton;
    UIButton *_readChildsButton;
    UIButton *_removeItemButton;
    UIButton *_editItemButton;
    
    UITextField *_titleField;
    
    SCItem *_createdItem;
    SCApiContext *_context;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self->_context = [SCApiContext contextWithHost:WLAWebApiHostName
                                            login:WLAUserName
                                         password:WLAUserPassword];

    self->_context.defaultDatabase = @"web";
    self->_context.defaultSite = WLASitecoreShellSite;
}

-(void)buildUI
{
    self->_readByPathItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 10, 130, 50)
                                                                 title:NSLocalizedString(@"Item by path", nil)
                                                                target:self
                                                              selector:@selector(readItemByPath)];
    [self.view addSubview: self->_readByPathItemButton];
    
    self->_readByIdItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(160, 10, 130, 50)
                                                               title:NSLocalizedString(@"Item by id", nil)
                                                              target:self
                                                            selector:@selector(readItemById)];
    [self.view addSubview: self->_readByIdItemButton];
    
    self->_readChildsButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 270, 50)
                                                             title:NSLocalizedString(@"Read home item childrens", nil)
                                                            target:self
                                                          selector:@selector(readChildrens)];
    [self.view addSubview: self->_readChildsButton];
    
    self->_addItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 130, 270, 50)
                                                          title:NSLocalizedString(@"Add item", nil)
                                                         target:self
                                                       selector:@selector(createItem)];
    [self.view addSubview: self->_addItemButton];
    
    self->_removeItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 190, 270, 50)
                                                             title:NSLocalizedString(@"Remove item", nil)
                                                            target:self
                                                          selector:@selector(deleteItem)];
    [self.view addSubview: self->_removeItemButton];
    
    {
        self->_editItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 250, 150, 50)
                                                               title:NSLocalizedString(@"Change item's title", nil)
                                                              target:self
                                                            selector:@selector(editItem)];
        [self.view addSubview: self->_editItemButton];
        
        self->_titleField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(180, 250, 110, 50)
                                                        placeholder:NSLocalizedString(@"type title here", nil)
                                                               text:@"New Title"];
        self->_titleField.delegate = self;
        [self.view addSubview: self->_titleField];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)readItemByPath
{
    SCItemsReaderRequest *request = [SCItemsReaderRequest new];
    request.scope = SCItemReaderSelfScope;
    request.request = @"/sitecore/content/Home";

    request.requestType = SCItemReaderRequestItemPath;
    request.fieldNames = [NSSet set];//do not read item's fields
    
    [self->_context itemsReaderWithRequest:request](^(id result, NSError *error)//read item to cache
    {
       [self proceedHomeItemReadResult:result[0] error:error];
    });
}

-(void)readItemById
{
    [self->_context itemReaderForItemId:WLAHomeItemId](^(id result, NSError *error)//read item to cache
    {
        [self proceedHomeItemReadResult:result error:error];
    });
}

-(void)proceedHomeItemReadResult:(id)result error:(NSError *)error
{
    SCItem* item = result;
    
    if (error)
    {
        [WLAAlertsHelper showErrorAlertWithError:error];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Item %@ was successfully read", nil), item.displayName];
        [WLAAlertsHelper showMessageAlertWithText:message];
    }
}

-(void)readChildrens
{
    SCItem *item = [_context itemWithPath:@"/sitecore/content/Home"]; //read home item from cache
    
    if (item)
    {
        [item childrenReader](^(id result, NSError *error)
        {
            NSArray *children = result;
            NSLog(@"children count:%d", [children count]);
            
            if (error)
            {
                [WLAAlertsHelper showErrorAlertWithError:error];
            }
            else
            {
                NSMutableString *names = [NSMutableString stringWithString:@""];
                
                for (SCItem *item in children)
                {
                    [names appendFormat:@"%@, ", item.displayName];
                }
                
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"The Home item Childrens: %@", nil), names];
                [WLAAlertsHelper showMessageAlertWithText:message];
            }
        });
    }
    else
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"The Home item is not in cache yet", nil)];
    }
}

-(void)createItem
{
    NSString* itemPath  = WLAWhiteLabelDataSourceRoot;
    SCCreateItemRequest *request = [SCCreateItemRequest requestWithItemPath:itemPath];
    
    request.itemName = @"apiItem test";
    request.itemTemplate = @"Sample/Sample Item";
    
    request.fieldsRawValuesByName = @{@"Title": @"Demo Title",
                                      @"Text": @"Demo Text" };
    
    request.fieldNames = [NSSet setWithObjects:@"Title", @"Text", nil];
    
    [self->_context itemCreatorWithRequest:request](^(SCItem *item, NSError *error)
     {
         if (item)
         {
             self->_createdItem = item;
             [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Item was successfully created", nil)];
         }
         else
         {
             [WLAAlertsHelper showErrorAlertWithError:error];
         }
         
     });
}

-(void)deleteItem
{
    if (!_createdItem)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Create item first", nil)];
        return;
    }
    
    [self->_createdItem removeItem](^(SCItem *removedItem, NSError *error)
    {
       if (!error)
       {
           self->_createdItem = nil;
           [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Item was successfully removed", nil)];
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
    
    SCField *field = [self->_createdItem.readFieldsByName objectForKey:@"Title"];
    
    field.rawValue = self->_titleField.text;
  
    [self->_createdItem saveItem](^(SCItem *editedItem, NSError *error)
    {
        if (!error)
        {
            self->_createdItem = editedItem;
            [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Title was successfully changed", nil)];
        }
        else
        {
            [WLAAlertsHelper showErrorAlertWithError:error];
        }
    });
}

@end

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
    _readByPathItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 10, 130, 50)
                                                   title:@"Item by path"
                                                  target:self
                                                selector:@selector(readItemByPath)];
    [self.view addSubview:_readByPathItemButton];
    
    _readByIdItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(160, 10, 130, 50)
                                                      title:@"Item by id"
                                                     target:self
                                                   selector:@selector(readItemById)];
    [self.view addSubview:_readByIdItemButton];
    
    _readChildsButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 200, 50)
                                                      title:@"Read home item childrens"
                                                     target:self
                                                   selector:@selector(readChildrens)];
    [self.view addSubview:_readChildsButton];
    
    _addItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 130, 200, 50)
                                                   title:@"Add item"
                                                  target:self
                                                selector:@selector(createItem)];
    [self.view addSubview:_addItemButton];
    
    _removeItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 190, 200, 50)
                                                   title:@"Remove item"
                                                  target:self
                                                selector:@selector(deleteItem)];
    [self.view addSubview:_removeItemButton];
    
    {
        _editItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 250, 150, 50)
                                                          title:@"Change item's title"
                                                         target:self
                                                       selector:@selector(editItem)];
        [self.view addSubview:_editItemButton];
        
        _titleField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(180, 250, 100, 50)
                                                 placeholder:@"type title here"
                                                        text:@"New Title"];
        _titleField.delegate = self;
        [self.view addSubview:_titleField];
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
        NSString *message = [NSString stringWithFormat:@"Item %@ was successfully read", item.displayName];
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
                
                NSString *message = [NSString stringWithFormat:@"The Home item Childrens: %@", names];
                [WLAAlertsHelper showMessageAlertWithText:message];
            }
        });
    }
    else
    {
        [WLAAlertsHelper showMessageAlertWithText:@"The Home item is not in cache yet"];
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
             [WLAAlertsHelper showMessageAlertWithText:@"Item was successfully created"];
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
        [WLAAlertsHelper showMessageAlertWithText:@"Create item first"];
        return;
    }
    
    [self->_createdItem removeItem](^(SCItem *removedItem, NSError *error)
    {
       if (!error)
       {
           self->_createdItem = nil;
           [WLAAlertsHelper showMessageAlertWithText:@"Item was successfully removed"];
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
        [WLAAlertsHelper showMessageAlertWithText:@"Create item first"];
        return;
    }
    
    if (self->_titleField.text.length < 1)
    {
        [WLAAlertsHelper showMessageAlertWithText:@"Type new title, please"];
        return;
    }
    
    SCField *field = [self->_createdItem.readFieldsByName objectForKey:@"Title"];
    
    field.rawValue = self->_titleField.text;
  
    [self->_createdItem saveItem](^(SCItem *editedItem, NSError *error)
    {
        if (!error)
        {
            self->_createdItem = editedItem;
            [WLAAlertsHelper showMessageAlertWithText:@"Title was successfully changed"];
        }
        else
        {
            [WLAAlertsHelper showErrorAlertWithError:error];
        }
    });
}

@end

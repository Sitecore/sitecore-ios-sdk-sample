//
//  WLAItemChildrensViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemChildrenViewController.h"

@implementation WLAItemChildrenViewController
{
    UIButton *_readItemChildrens;
    UITextField *_idField;
}

-(void)buildUI
{
    NSString *homeId = [WLAGlobalSettings sharedInstance].WLAHomeItemId;
    
    self->_idField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 10, 270, 50)
                                                 placeholder:NSLocalizedString(@"type item id here", nil)
                                                        text:homeId];
    [self addSubview: self->_idField];
    
    self->_readItemChildrens = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 270, 50)
                                                              title:NSLocalizedString(@"Read item children", nil)
                                                             target:self
                                                           selector:@selector(readItemById)];
    [self addSubview: self->_readItemChildrens];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)readItemById
{
    __block WLAItemChildrenViewController *weakSelf = self;
    
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
                                                                       [weakSelf readChildrensForItem:result];
                                                                   }
                                                               });
    }
    else
    {
        [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Please fill id field first", nil)];
    }
}

-(void)readChildrensForItem:(SCItem *)item
{
    if (item)
    {
        [item readChildrenOperation](^(NSArray *result, NSError *error)
                              {
                                  NSArray *children = result;
                                  NSLog(@"children count:%d", [children count]);
                                  
                                  if (error)
                                  {
                                      [WLAAlertsHelper showErrorAlertWithError:error];
                                  }
                                  else
                                  {
                                      NSString *message;
                                      
                                      if ([result count]>0)
                                      {
                                          NSMutableString *names = [NSMutableString stringWithString:@""];
                                          
                                          for (SCItem *item in children)
                                          {
                                              [names appendFormat:@"%@\n", item.displayName];
                                          }
                                          
                                          message = [NSString stringWithFormat:NSLocalizedString(@"The item children:\n%@", nil), names];
                                      }
                                      else
                                      {
                                          message = NSLocalizedString(@"Item has no children", nil);
                                      }
                                      
                                      [WLAAlertsHelper showMessageAlertWithText:message];
                                  }
                              });
    }
    else
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Item not exists", nil)];
    }
}


@end

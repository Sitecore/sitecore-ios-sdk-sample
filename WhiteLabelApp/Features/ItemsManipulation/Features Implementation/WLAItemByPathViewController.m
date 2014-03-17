//
//  WLAItemByPathViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemByPathViewController.h"

@interface WLAItemByPathViewController ()

@end

@implementation WLAItemByPathViewController
{
    UIButton *_readByPathItemButton;
    UITextField *_pathField;
}

-(void)buildUI
{
    self->_pathField = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 10, 270, 50)
                                                   placeholder:NSLocalizedString(@"type item path here", nil)
                                                          text:@"/sitecore/content/Home"];
    [self addSubview: self->_pathField];
    
    self->_readByPathItemButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 70, 270, 50)
                                                                 title:NSLocalizedString(@"Item by path", nil)
                                                                target:self
                                                              selector:@selector(readItemByPath)];
    [self addSubview: self->_readByPathItemButton];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(void)readItemByPath
{
    if ( [self->_pathField.text length] > 0 )
    {
        SCReadItemsRequest *request = [SCReadItemsRequest new];
        request.scope = SCReadItemSelfScope;
        request.request = self->_pathField.text;
        
        request.requestType = SCReadItemRequestItemPath;
        request.fieldNames = [NSSet set];//do not read item's fields
        
        [self.context readItemsOperationWithRequest:request](^(NSArray *result, NSError *error)//read item to cache
                                                        {
                                                            if ([result count]>0)
                                                            {
                                                                [self proceedItemReadResult:result[0] error:error];
                                                            }
                                                            else
                                                            {
                                                                [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Item not found", nil)];
                                                            }
                                                        });
    }
    else
    {
        [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Please fill path field first", nil)];
    }
}

@end

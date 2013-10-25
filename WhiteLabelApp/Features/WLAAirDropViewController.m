//
//  WLAAirDropViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAAirDropViewController.h"

@interface WLAAirDropViewController ()

@end

@implementation WLAAirDropViewController
{
    UIDocumentInteractionController *interaction;
}

-(void)buildUI
{
    UIButton *dropButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 50, 200, 50)
                                                          title:NSLocalizedString(@"Drop", nil)
                                                         target:self
                                                       selector:@selector(readImageAndShare:)];
    [self.view addSubview:dropButton];
}

-(void)readImageAndShare:(id)sender
{
    SCApiContext* context = [SCApiContext contextWithHost:WLAWebApiHostName
                                                    login:WLAUserName
                                                 password:WLAUserPassword];
    context.defaultDatabase = @"web";
    context.defaultSite = WLASitecoreShellSite;
    
    SCItemsReaderRequest* request = [SCItemsReaderRequest new];
    request.request = @"/sitecore/content/WhiteLabelApplication/DataSource/Image/ItemWithImage";
    request.requestType = SCItemReaderRequestItemPath;
    request.fieldNames = [NSSet setWithObject: @"Image"];
    request.flags = SCItemReaderRequestReadFieldsValues;
    
    [context itemsReaderWithRequest: request ](^(id result, NSError* error)
    {
        SCItem* item = [result lastObject];
        UIImage* image = [item fieldValueWithName: @"Image"];
        [self shareImage:image];
    });

}

-(void)shareImage:(UIImage *)image
{
    if (!image)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Image wasn't received from the server", nil)];
        return;
    }
    
    UIActivityViewController* vc = [[UIActivityViewController alloc]
                                    initWithActivityItems:@[image] applicationActivities:nil];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end

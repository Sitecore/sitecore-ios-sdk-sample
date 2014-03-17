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
    NSString *hostPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    NSString *userName = [WLAGlobalSettings sharedInstance].WLAUserName;
    NSString *password = [WLAGlobalSettings sharedInstance].WLAUserPassword;
    NSString *sitePath = [WLAGlobalSettings sharedInstance].WLASitecoreShellSite;
    NSString *database = [WLAGlobalSettings sharedInstance].WLADatabase;
    
    SCApiSession* context = [SCApiSession sessionWithHost:hostPath
                                                    login:userName
                                                 password:password];
    context.defaultDatabase = database;
    context.defaultSite = sitePath;
    
    SCReadItemsRequest* request = [SCReadItemsRequest new];
    request.request = @"/sitecore/content/WhiteLabelApplication/DataSource/Image/ItemWithImage";
    request.requestType = SCReadItemRequestItemPath;
    request.fieldNames = [NSSet setWithObject: @"Image"];
    request.flags = SCReadItemRequestReadFieldsValues;
    
    [context readItemsOperationWithRequest: request ](^(id result, NSError* error)
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

//
//  WLAAuthViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/14/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAAuthViewController.h"

@interface WLAAuthViewController ()

@end

@implementation WLAAuthViewController
{
    UITextField *_userName;
    UITextField *_password;
    UITextField *_site;
}

-(void)buildUI
{
    NSString *userName = [WLAGlobalSettings sharedInstance].WLAUserName;
    NSString *password = [WLAGlobalSettings sharedInstance].WLAUserPassword;
    NSString *sitePath = [WLAGlobalSettings sharedInstance].WLASitecoreShellSite;
    
    self->_userName = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 20, 200, 50)
                                                  placeholder:NSLocalizedString(@"domain\\login", nil)
                                                         text:userName];
    [self.view addSubview:self->_userName];
    
    self->_password = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 80, 200, 50)
                                                  placeholder:NSLocalizedString(@"password", nil)
                                                         text:password];
    [self.view addSubview:self->_password];
    
    self->_site = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 140, 200, 50)
                                              placeholder:NSLocalizedString(@"site", nil)
                                                     text:sitePath];
    [self.view addSubview:self->_site];
    
    UIButton *correctAuthButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 220, 200, 50)
                                                                 title:NSLocalizedString(@"Try authentication", nil)
                                                                target:self
                                                              selector:@selector(tryAuthRequest)];
    [self.view addSubview:correctAuthButton];
}



-(void)tryAuthRequest
{
    NSString *hostPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    
    SCApiSession* context = [SCApiSession sessionWithHost:hostPath
                                                    login:self->_userName.text
                                                 password:self->_password.text];
    
    SCAsyncOp authOp = [context checkCredentialsOperationForSite:self->_site.text];
    

    SCAsyncOpResult onAuthCompleted = ^void(NSNull* blockResult, NSError* blockError)
    {
        NSString *message;
        
        if (blockResult)
        {
            message = NSLocalizedString(@"This user is exists", nil);
        }
        else
        {
            message = NSLocalizedString(@"This user does not exists", nil);
        }
        
        [WLAAlertsHelper showMessageAlertWithText:message];
    };
        
    authOp(onAuthCompleted);

}

@end

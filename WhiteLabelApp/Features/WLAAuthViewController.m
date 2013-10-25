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
    self->_userName = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 20, 200, 50)
                                           placeholder:@"domain\\login"
                                                  text:WLACreatorUser];
    [self.view addSubview:self->_userName];
    
    self->_password = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 80, 200, 50)
                                           placeholder:@"password"
                                                  text:WLACreatorPassword];
    [self.view addSubview:self->_password];
    
    self->_site = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 140, 200, 50)
                                                  placeholder:@"site"
                                                         text:WLASitecoreShellSite];
    [self.view addSubview:self->_site];
    
    UIButton *correctAuthButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 220, 200, 50)
                                                                 title:@"Try authentication"
                                                                target:self
                                                              selector:@selector(tryAuthRequest)];
    [self.view addSubview:correctAuthButton];
}



-(void)tryAuthRequest
{
    SCApiContext* context = [SCApiContext contextWithHost:WLAWebApiHostNameWithAuth
                                                    login:self->_userName.text
                                                 password:self->_password.text];
    
    SCAsyncOp authOp = [context credentialsCheckerForSite:self->_site.text];
    

    SCAsyncOpResult onAuthCompleted = ^void(NSNull* blockResult, NSError* blockError)
    {
        NSString *message;
        
        if (blockResult)
        {
            message = @"This user is exists";
        }
        else
        {
            message = @"This user does not exists";
        }
        
        [WLAAlertsHelper showMessageAlertWithText:message];
    };
        
    authOp(onAuthCompleted);

}

@end

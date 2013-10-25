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
}

-(void)buildUI
{
    _userName = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 100, 200, 50)
                                           placeholder:WLACreatorUser
                                                  text:WLACreatorUser];
    [self.view addSubview:_userName];
    
    _password = [WLAMainUIFactory wlaTextFieldWithFrame:CGRectMake(20, 170, 200, 50)
                                           placeholder:WLACreatorPassword
                                                  text:WLACreatorPassword];
    [self.view addSubview:_password];
    
    UIButton *correctAuthButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 240, 200, 50)
                                                                 title:@"Try authentication"
                                                                target:self
                                                              selector:@selector(tryAuthRequest)];
    [self.view addSubview:correctAuthButton];
}



-(void)tryAuthRequest
{
    SCApiContext* context = [SCApiContext contextWithHost:WLAWebApiHostNameWithAuth
                                                    login:_userName.text
                                                 password:_password.text];
    
    SCAsyncOp authOp = [context credentialsCheckerForSite:WLASitecoreShellSite];
    

    SCAsyncOpResult onAuthCompleted = ^void(NSNull* blockResult, NSError* blockError)
    {
        NSString *message;
        
        if (blockResult)
        {
            message = @"This user is exist";
        }
        else
        {
            message = @"This user is not exist";
        }
        
        [WLAAlertsHelper showMessageAlertWithText:message];
    };
        
    authOp(onAuthCompleted);

}

@end

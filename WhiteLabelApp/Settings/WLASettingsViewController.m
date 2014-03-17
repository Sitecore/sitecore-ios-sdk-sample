//
//  WLASettingsViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 17/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLASettingsViewController.h"

@interface WLASettingsViewController ()

@end

@implementation WLASettingsViewController
{
    WLAGlobalSettings *_settings;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _settings.WLAWebApiHostName             = self.hostNameField.text;
    _settings.WLASitecoreShellSite          = self.sitePathField.text;
    _settings.WLAUserName                   = self.loginField.text;
    _settings.WLAUserPassword               = self.passwordField.text;
    _settings.WLAHomeItemId                 = self.homeItemIdField.text;
    _settings.WLAWhiteLabelDataSourceRoot   = self.dsRootField.text;
    _settings.WLADatabase                   = self.databaseField.text;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _settings = [WLAGlobalSettings sharedInstance];
    
    self.hostNameField.placeholder     = NSLocalizedString(@"instance path", nil);
    self.sitePathField.placeholder     = NSLocalizedString(@"site path", nil);
    self.loginField.placeholder        = NSLocalizedString(@"login", nil);
    self.passwordField.placeholder     = NSLocalizedString(@"password", nil);
    self.homeItemIdField.placeholder   = NSLocalizedString(@"home item ID", nil);
    self.dsRootField.placeholder       = NSLocalizedString(@"data source root", nil);
    self.databaseField.placeholder     = NSLocalizedString(@"database", nil);
    
    
    self.hostNameField.text     = _settings.WLAWebApiHostName;
    self.sitePathField.text     = _settings.WLASitecoreShellSite;
    self.loginField.text        = _settings.WLAUserName;
    self.passwordField.text     = _settings.WLAUserPassword;
    self.homeItemIdField.text   = _settings.WLAHomeItemId;
    self.dsRootField.text       = _settings.WLAWhiteLabelDataSourceRoot;
    self.databaseField.text     = _settings.WLADatabase;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

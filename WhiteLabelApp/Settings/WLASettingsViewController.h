//
//  WLASettingsViewController.h
//  WhiteLabelApp
//
//  Created by Igor on 17/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLASettingsViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic) IBOutlet UITextField *hostNameField;
@property(nonatomic) IBOutlet UITextField *sitePathField;
@property(nonatomic) IBOutlet UITextField *loginField;
@property(nonatomic) IBOutlet UITextField *passwordField;
@property(nonatomic) IBOutlet UITextField *homeItemIdField;
@property(nonatomic) IBOutlet UITextField *dsRootField;
@property(nonatomic) IBOutlet UITextField *databaseField;
@end

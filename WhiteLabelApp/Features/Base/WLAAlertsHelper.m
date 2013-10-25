//
//  WLAAlertsHelper.m
//  WhiteLabelApp
//
//  Created by Igor on 10/18/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAAlertsHelper.h"

@implementation WLAAlertsHelper

+(void)showMessageAlertWithText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil)
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)showErrorAlertWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

@end

//
//  WLAAlertsHelper.h
//  WhiteLabelApp
//
//  Created by Igor on 10/18/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAAlertsHelper : NSObject

+(void)showMessageAlertWithText:(NSString *)text;
+(void)showErrorAlertWithError:(NSError *)error;
+(void)showErrorAlertWithText:(NSString *)text;

@end

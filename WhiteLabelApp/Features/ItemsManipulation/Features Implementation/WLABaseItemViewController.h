//
//  WLABaseItemViewController.h
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLABaseNativeViewController.h"

@interface WLABaseItemViewController : WLABaseNativeViewController<UITextFieldDelegate>

@property(nonatomic) SCApiSession *context;

-(void)proceedItemReadResult:(id)result error:(NSError *)error;
-(void)addSubview:(UIView *)view;

@end

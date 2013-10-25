//
//  WLAHardwareViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/14/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAHardwareViewController.h"

@interface WLAHardwareViewController ()

@end

@implementation WLAHardwareViewController

-(NSString *)featurePath
{
    return [WLAPathHelper wlaPathToItem:@"Hardware.aspx"];
}

@end

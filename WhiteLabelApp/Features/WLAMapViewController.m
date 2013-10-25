//
//  WLAMapViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAMapViewController.h"

@interface WLAMapViewController ()

@end

@implementation WLAMapViewController

-(NSString *)featurePath
{
    return [WLAPathHelper wlaPathToItem:@"Maps.aspx"];
}

@end

//
//  WLAPathHelper.m
//  WhiteLabelApp
//
//  Created by Igor on 10/22/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAPathHelper.h"

@implementation WLAPathHelper

+(NSString *)wlaPathToItem:(NSString *)item
{
    NSString *dsRoot = [WLAGlobalSettings sharedInstance].WLAWhiteLabelDataSourceRoot;
    
    return [NSString stringWithFormat:@"%@%@", dsRoot, item];
}

@end

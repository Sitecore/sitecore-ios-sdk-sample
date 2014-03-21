//
//  WLAItemsManipulationFeaturesFactory.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemsManipulationFeaturesFactory.h"
#import "WLAItemByPathViewController.h"
#import "WLAItemByIDViewController.h"
#import "WLAItemChildrenViewController.h"
#import "WLAItemCreateViewController.h"
#import "WLAItemDeleteViewController.h"

@implementation WLAItemsManipulationFeaturesFactory

-(id)init
{
    if (self = [super init])
    {
        self.features =
        @{
          @"Read item by path"    :[WLAItemByPathViewController    class],
          @"Read item by ID"      :[WLAItemByIDViewController      class],
          @"Read item children"   :[WLAItemChildrenViewController  class],
          @"Create/Edit item"     :[WLAItemCreateViewController    class],
          @"Delete item"          :[WLAItemDeleteViewController    class],
          };
    }
    
    return self;
}

@end

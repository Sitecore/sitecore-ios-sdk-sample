//
//  WLASwipeViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/14/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLASwipeViewController.h"

@interface WLASwipeViewController ()

@end

@implementation WLASwipeViewController
{
    NSString *_featurePath;
}

-(id)initWithFeaturePath:(NSString *)path
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self->_featurePath = path;
    }
    return self;
}

-(NSString *)featurePath
{
    return self->_featurePath;
}

-(void)viewDidLoad
{
    if (!self->_featurePath)
    {
        self->_featurePath = [WLAPathHelper wlaPathToItem:@"SwipePages/SwipePage1.aspx"];
    }
    
    [super viewDidLoad];
}

@end

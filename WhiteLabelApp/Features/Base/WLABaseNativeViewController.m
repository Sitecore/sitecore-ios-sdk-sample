//
//  WLABaseNativeViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLABaseNativeViewController.h"

@interface WLABaseNativeViewController ()

@end

@implementation WLABaseNativeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildUI];
}

-(void)buildUI
{
    [self doesNotRecognizeSelector:_cmd];
}

@end

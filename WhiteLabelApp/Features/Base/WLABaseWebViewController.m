//
//  WLABaseViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/14/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLABaseWebViewController.h"

@interface WLABaseWebViewController ()

@end

@implementation WLABaseWebViewController

-(NSString *)featurePath
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(void)showWebViewWithFeature
{
    NSString *homstPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    
    SCWebView* webView = [[SCWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", homstPath, self.featurePath]];
    [webView loadURL:url];
    [self.view addSubview:webView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self showWebViewWithFeature];
}

@end

//
//  WLAQRCodeViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAQRCodeViewController.h"

@interface WLAQRCodeViewController ()

@end

@implementation WLAQRCodeViewController
{
    SCQRCodeReaderView *_qrcodeView;
}

-(void)buildUI
{
    _qrcodeView = [SCQRCodeReaderView viewWithDelegate:self
                                          captureRect:self.view.bounds];
    _qrcodeView.frame = self.view.bounds;
    [self.view addSubview:_qrcodeView];
        
    [_qrcodeView startCapture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_qrcodeView stopCapture];
}

-(void)qrCodeReaderView:(SCQRCodeReaderView*)readerView
       didGetScanResult:(NSString*)resultString
{
    NSLog(@"%@", resultString);
    if (resultString)
    {
        [_qrcodeView stopCapture];
        SCApiContext* context = [SCApiContext contextWithHost:WLAWebApiHostName];
    
        [context imageLoaderForSCMediaPath:resultString](^(id result, NSError* error)
         {
             if (!error)
             {
                 [UIView animateWithDuration:.5 animations:^{
                     [_qrcodeView removeFromSuperview];
                     NSLog(@"result:%@", result);
                     UIImageView *imageView = [[UIImageView alloc] initWithImage:result];
                     imageView.frame = self.view.bounds;
                     [imageView setContentMode:UIViewContentModeScaleAspectFit];
                     [self.view addSubview:imageView];
                 }];
                 
             }
             else
             {
                 [WLAAlertsHelper showMessageAlertWithText:resultString];
             }
         });
    }
}

-(void)qrCodeReaderViewDidCancel:(SCQRCodeReaderView*)readerView
{
    NSLog(@"QRCode canceled");
}

@end

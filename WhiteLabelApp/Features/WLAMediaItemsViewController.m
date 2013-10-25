//
//  WLAMediaItemsViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/18/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAMediaItemsViewController.h"

@interface WLAMediaItemsViewController ()

@end

@implementation WLAMediaItemsViewController
{
    SCApiContext *apiContext;
    SCCancelAsyncOperation cancelOperation;
    SCItem* media_item;
    
    UIButton *createButton;
    UIProgressView *progressView;
    UIButton *cancelButton;
    
    BOOL uploadingIsInProgress;
    
    NSData *imageData;
    
    UIAlertView *readingAlert;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    uploadingIsInProgress = NO;
    
    self->apiContext = [SCApiContext contextWithHost:WLAWebApiHostName
                                                login:WLAUserName
                                             password:WLAUserPassword];

    self->apiContext.defaultDatabase = @"web";
    self->apiContext.defaultSite = WLASitecoreShellSite;
}

-(void)viewWillAppear:(BOOL)animated
{
    self->readingAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"image data processing, please wait"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [self->readingAlert show ];
    
    
    void(^readImageBlock)( void ) = ^void()
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[self imageFileName] ofType:@"jpg"];
        self->imageData = [NSData dataWithContentsOfFile:filePath];
        [self->readingAlert dismissWithClickedButtonIndex:0 animated:YES];
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), readImageBlock );
}

-(void)buildUI
{
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 20)];
    [self.view addSubview:progressView];
    
    createButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 40, 130, 50)
                                                  title:@"Upload image"
                                                 target:self
                                               selector:@selector(createMediaItem)];
    [self.view addSubview:createButton];
    
    cancelButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(160, 40, 130, 50)
                                                  title:@"Cancel"
                                                 target:self
                                               selector:@selector(cancelUploading)];
    [self.view addSubview:cancelButton];
}

#pragma mark -----------------------------------------
#pragma mark items manipulation logic
#pragma mark -----------------------------------------

-(NSString *)imageFileName
{
    return @"large_image";
}

-(void)createMediaItem
{
    if (uploadingIsInProgress)
    {
       [WLAAlertsHelper showMessageAlertWithText:@"Uploading is in progress now"];
        return;
    }
    
    uploadingIsInProgress = YES;
    
    SCCancelAsyncOperationHandler cancelCallback = ^void(BOOL isActionTerminated)
    {
        self->cancelOperation = nil;
        [WLAAlertsHelper showMessageAlertWithText:@"Image uploading was canceled!"];
        [self->progressView setProgress:0.f];
        
        uploadingIsInProgress = NO;
    };
    
    SCDidFinishAsyncOperationHandler doneCallback = ^(SCItem* item, NSError* error)
    {
        self->cancelOperation = nil;
        self->media_item = item;
        
        if (error)
            [WLAAlertsHelper showErrorAlertWithError:error];
        else
            [WLAAlertsHelper showMessageAlertWithText:@"Image uploaded successfully"];
        
        uploadingIsInProgress = NO;
    };
    
    SCAsyncOperationProgressHandler progressCallback = ^(id<SCUploadProgress> progressInfo)
    {
        if ([progressInfo respondsToSelector:@selector(progress)])
        {
            NSLog(@"-=== progress:%.2f%%", ([progressInfo progress].floatValue * 100));
            [self->progressView setProgress:[progressInfo progress].floatValue];
        }
    };

    SCCreateMediaItemRequest* request = [SCCreateMediaItemRequest new];
    
    request.fileName      = [NSString stringWithFormat:@"%@.jpg", [self imageFileName]];
    request.itemName      = @"TestMediaItem";
    request.itemTemplate  = @"System/Media/Unversioned/Image";
    request.mediaItemData = self->imageData;
    request.fieldNames    = [NSSet new];
    request.contentType   = @"image/jpg";
    request.folder        = @"/WhiteLabel/BigImageTestData";
    
    SCExtendedAsyncOp loader = [self->apiContext.extendedApiContext mediaItemCreatorWithRequest:request];
    
    self->cancelOperation = loader(progressCallback, cancelCallback, doneCallback);

}

-(void)cancelUploading
{
    if (!self->cancelOperation)
    {
        [WLAAlertsHelper showMessageAlertWithText:@"Start uploading first"];
        return;
    }
    
    self->cancelOperation(YES);
}

@end

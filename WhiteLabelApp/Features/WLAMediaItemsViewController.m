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
    SCApiSession *_apiContext;
    SCCancelAsyncOperation _cancelOperation;
    SCItem* _media_item;
    
    UIButton *_createButton;
    UIProgressView *_progressView;
    UIButton *_cancelButton;
    
    BOOL _uploadingIsInProgress;
    
    NSData *_imageData;
    
    UIAlertView *_readingAlert;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

     self->_uploadingIsInProgress = NO;
    
    NSString *hostPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    NSString *userName = [WLAGlobalSettings sharedInstance].WLAUserName;
    NSString *password = [WLAGlobalSettings sharedInstance].WLAUserPassword;
    NSString *sitePath = [WLAGlobalSettings sharedInstance].WLASitecoreShellSite;
    NSString *database = [WLAGlobalSettings sharedInstance].WLADatabase;
    
    self->_apiContext = [SCApiSession sessionWithHost:hostPath
                                                login:userName
                                             password:password];

    self->_apiContext.defaultDatabase = database;
    self->_apiContext.defaultSite = sitePath;
}

-(void)viewWillAppear:(BOOL)animated
{
    self->_readingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                    message:NSLocalizedString(@"image data processing, please wait", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [self->_readingAlert show ];
    
    
    void(^readImageBlock)( void ) = ^void()
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[self imageFileName] ofType:@"jpg"];
        self->_imageData = [NSData dataWithContentsOfFile:filePath];
        [self->_readingAlert dismissWithClickedButtonIndex:0 animated:YES];
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), readImageBlock );
}

-(void)buildUI
{
    
    self->_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self->_progressView setFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 20)];
    [self.view addSubview:self->_progressView];
    
    self->_createButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(20, 40, 130, 50)
                                                         title:NSLocalizedString(@"Upload image", nil)
                                                        target:self
                                                      selector:@selector(createMediaItem)];
    [self.view addSubview:self->_createButton];
    
    self->_cancelButton = [WLAMainUIFactory wlaButtonWithFrame:CGRectMake(160, 40, 130, 50)
                                                         title:NSLocalizedString(@"Cancel", nil)
                                                        target:self
                                                      selector:@selector(cancelUploading)];
    [self.view addSubview:self->_cancelButton];
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
    if (_uploadingIsInProgress)
    {
       [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Uploading is in progress now", nil)];
        return;
    }
    
    self->_uploadingIsInProgress = YES;
    
    SCCancelAsyncOperationHandler cancelCallback = ^void(BOOL isActionTerminated)
    {
        self->_cancelOperation = nil;
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Image uploading was canceled!", nil)];
        [self->_progressView setProgress:0.f];
        
        self->_uploadingIsInProgress = NO;
    };
    
    SCDidFinishAsyncOperationHandler doneCallback = ^(SCItem* item, NSError* error)
    {
        self->_cancelOperation = nil;
        self->_media_item = item;
        
        if (error)
        {
            [WLAAlertsHelper showErrorAlertWithError:error];
        }
        else
        {
            NSMutableString *message = [NSMutableString stringWithString:NSLocalizedString(@"Image uploaded successfully", nil)];
            [message appendFormat:@"\nitem path: %@", item.path];
            [message appendFormat:@"\nitem name: %@", item.displayName];
            [WLAAlertsHelper showMessageAlertWithText:message];
        }
        
        self->_uploadingIsInProgress = NO;
    };
    
    SCAsyncOperationProgressHandler progressCallback = ^(id<SCUploadProgress> progressInfo)
    {
        if ([progressInfo respondsToSelector:@selector(progress)])
        {
            NSLog(@"-=== progress:%.2f%%", ([progressInfo progress].floatValue * 100));
            [self->_progressView setProgress:[progressInfo progress].floatValue];
        }
    };

    SCUploadMediaItemRequest* request = [SCUploadMediaItemRequest new];
    
    request.fileName      = [NSString stringWithFormat:@"%@.jpg", [self imageFileName]];
    request.itemName      = @"TestMediaItem";
    request.itemTemplate  = @"System/Media/Unversioned/Image";
    request.mediaItemData = self->_imageData;
    request.fieldNames    = [NSSet new];
    request.contentType   = @"image/jpg";
    request.folder        = @"/WhiteLabel/BigImageTestData";
    
    SCExtendedAsyncOp loader = [self->_apiContext.extendedApiSession uploadMediaOperationWithRequest:request];
    
    self->_cancelOperation = loader(progressCallback, cancelCallback, doneCallback);

}

-(void)cancelUploading
{
    if (!self->_cancelOperation)
    {
        [WLAAlertsHelper showMessageAlertWithText:NSLocalizedString(@"Start uploading first", nil)];
        return;
    }
    
    self->_cancelOperation(YES);
}

@end

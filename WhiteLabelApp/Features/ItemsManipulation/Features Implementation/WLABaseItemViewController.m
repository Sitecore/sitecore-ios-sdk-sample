//
//  WLABaseItemViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLABaseItemViewController.h"

@interface WLABaseItemViewController ()

@end

static CGFloat keyboardHeight = 216.f;

@implementation WLABaseItemViewController
{
    UIScrollView *_scrollView;
    CGFloat _maxHeight;
}

- (void)viewDidLoad
{
    self->_scrollView = [UIScrollView new];
    [self->_scrollView setFrame:self.view.bounds];
    [self.view addSubview:self->_scrollView];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
    self->_maxHeight = 0;
    
    NSString *hostPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    NSString *userName = [WLAGlobalSettings sharedInstance].WLAUserName;
    NSString *password = [WLAGlobalSettings sharedInstance].WLAUserPassword;
    NSString *sitePath = [WLAGlobalSettings sharedInstance].WLASitecoreShellSite;
    NSString *database = [WLAGlobalSettings sharedInstance].WLADatabase;
    
    self->_context = [SCApiSession sessionWithHost:hostPath
                                             login:userName
                                          password:password];
    
    self->_context.defaultDatabase = database;
    self->_context.defaultSite = sitePath;
}

-(void)addSubview:(UIView *)view
{
    CGFloat height = view.frame.origin.y + view.frame.size.height;
    
    if ( height > self->_maxHeight )
    {
        self->_maxHeight = height;
    }
    
    CGSize contentSize = CGSizeMake(self.view.bounds.size.width, self->_maxHeight);
    [self->_scrollView setContentSize:contentSize];
    
    [self->_scrollView addSubview:view];
}

-(void)proceedItemReadResult:(id)result error:(NSError *)error
{
    SCItem *item = result;
    
    if (error)
    {
        [WLAAlertsHelper showErrorAlertWithError:error];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Item %@ was successfully read", nil), item.displayName];
        [WLAAlertsHelper showMessageAlertWithText:message];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardWillShow:(id)sender
{
    CGRect frame = self.view.bounds;
    frame.size.height -= keyboardHeight;
    
    [UIView animateWithDuration:.3f animations:^{
        [self->_scrollView setFrame:frame];
    }];
}

-(void)keyboardWillBeHidden:(id)sender
{
    CGRect frame = self.view.bounds;
    
    [UIView animateWithDuration:.3f animations:^{
        [self->_scrollView setFrame:frame];
    }];
}

@end

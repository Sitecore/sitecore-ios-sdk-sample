//
//  WLAItemsTableViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/22/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAItemsTableViewController.h"
#import "WLASwipeViewController.h"

@interface WLAItemsTableViewController ()

@end

@implementation WLAItemsTableViewController
{
    SCApiSession* context;
    
    UITableView *itemsTableView;
    NSArray *itemsList;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    NSString *hostPath = [WLAGlobalSettings sharedInstance].WLAWebApiHostName;
    NSString *userName = [WLAGlobalSettings sharedInstance].WLAUserName;
    NSString *password = [WLAGlobalSettings sharedInstance].WLAUserPassword;
    NSString *sitePath = [WLAGlobalSettings sharedInstance].WLASitecoreShellSite;
    NSString *database = [WLAGlobalSettings sharedInstance].WLADatabase;
    
    self->context = [SCApiSession sessionWithHost:hostPath
                                            login:userName
                                         password:password];
    
    self->context.defaultDatabase = database;
    self->context.defaultSite = sitePath;
    [self downloadItemsList];
}

-(void)buildUI
{
    self->itemsTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self->itemsTableView.dataSource = self;
    self->itemsTableView.delegate = self;
    [self.view addSubview:self->itemsTableView];
}

-(void)downloadItemsList
{
    [context readChildrenOperationForItemPath:[WLAPathHelper wlaPathToItem:@"SwipePages"]](^(NSArray *result, NSError
                                                                          *error)
    {
        if ([result count]>0)
        {
            self->itemsList = result;
            [self->itemsTableView reloadData];
        }
        else
        {
            [WLAAlertsHelper showErrorAlertWithText:NSLocalizedString(@"Content is not available", nil)];
        }
    });
    
}

-(void)showWebViewWithItem:(SCItem *)item
{
    WLASwipeViewController *itemVC = [[WLASwipeViewController alloc] initWithFeaturePath:item.path];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WLACell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    SCItem *currentItem = itemsList[indexPath.row];
    
    cell.textLabel.text = [currentItem displayName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showWebViewWithItem:itemsList[indexPath.row]];
}

@end

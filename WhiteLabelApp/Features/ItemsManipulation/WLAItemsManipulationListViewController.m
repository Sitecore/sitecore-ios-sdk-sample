//
//  WLAItemsManipulationListViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 08/02/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "WLAItemsManipulationListViewController.h"
#import "WLAItemsManipulationFeaturesFactory.h"

@interface WLAItemsManipulationListViewController ()

@end

@implementation WLAItemsManipulationListViewController
{
    NSArray *featuesList;
    WLAItemsManipulationFeaturesFactory *featureFactory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    featureFactory = [WLAItemsManipulationFeaturesFactory new];
    featuesList = [featureFactory featuresList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [featuesList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( !cell )
    {
        cell = [[ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDate *object = featuesList[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *feature = featuesList[indexPath.row];
    
    UIViewController *detailController = [featureFactory featureViewControllerForKey:feature];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

@end

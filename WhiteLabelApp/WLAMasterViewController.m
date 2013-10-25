//
//  WLAMasterViewController.m
//  WhiteLabelApp
//
//  Created by Igor on 10/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAMasterViewController.h"

#import "WLAFeaturesFactory.h"

@interface WLAMasterViewController ()
{
    NSArray *featuesList;
    WLAFeaturesFactory *featureFactory;
}
@end

@implementation WLAMasterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    featureFactory = [WLAFeaturesFactory new];
    featuesList = [featureFactory featuresList];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [featuesList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

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

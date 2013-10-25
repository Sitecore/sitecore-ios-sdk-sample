//
//  WLAFeaturesFactory.h
//  WhiteLabelApp
//
//  Created by Igor on 10/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAFeaturesFactory : NSObject

@property(nonatomic) NSArray *featuresList;

-(UIViewController *)featureViewControllerForKey:(NSString *)key;

@end

#import <Foundation/Foundation.h>

@interface WLAGlobalSettings : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic) NSString* WLAWebApiHostName;
@property(nonatomic) NSString* WLASitecoreShellSite;
@property(nonatomic) NSString* WLAUserName;
@property(nonatomic) NSString* WLAUserPassword;
@property(nonatomic) NSString* WLAHomeItemId;
@property(nonatomic) NSString* WLAWhiteLabelDataSourceRoot;
@property(nonatomic) NSString* WLADatabase;

@end

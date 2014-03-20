#import "WLAGlobalSettings.h"

@implementation WLAGlobalSettings

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *)WLAWebApiHostName
{
    if (!self->_WLAWebApiHostName)
        //http://mobiledev1ua1.dk.sitecore.net:7119/
        return @"http://host_name.com:80";
    
    return self->_WLAWebApiHostName;
}

-(NSString *)WLASitecoreShellSite
{
    if (!self->_WLASitecoreShellSite)
        return @"/sitecore/shell";
    
    return self->_WLASitecoreShellSite;
}

-(NSString *)WLAUserName
{
    if (!self->_WLAUserName)
        return @"admin";
    
    return self->_WLAUserName;
}

-(NSString *)WLAUserPassword
{
    if (!self->_WLAUserPassword)
        return @"b";
    
    return self->_WLAUserPassword;
}

-(NSString *)WLAHomeItemId
{
    if (!self->_WLAHomeItemId)
        return @"{039DE578-616A-4E63-AFA4-0AAA3FE7CBAF}";
    
    return self->_WLAHomeItemId;
}

-(NSString *)WLAWhiteLabelDataSourceRoot
{
    if (!self->_WLAWhiteLabelDataSourceRoot)
        return @"/sitecore/content/WhiteLabelApplication/";
    
    return self->_WLAWhiteLabelDataSourceRoot;
}

-(NSString *)WLADatabase
{
    if (!self->_WLADatabase)
        return @"web";
    
    return self->_WLADatabase;
}

@end

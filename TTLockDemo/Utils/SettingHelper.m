//
//  SettingHelper.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "SettingHelper.h"


@implementation SettingHelper




+(void)setAccessToken:(NSString*)object
{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString*)getAccessToken
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_token"];
}

+(void)setOpenID:(NSString*)object
{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_open_id"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString*)getOpenID
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_open_id"];
}


+(void)setExpireIn:(NSString*)object
{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_expire_in"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSString*)getExpireIn
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_expire_in"];
}
+(void)setUid:(NSString*)object{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_uid"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getUid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_uid"];
}

+(void)setCurrentFingerprintNumber:(NSString*)object{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_CurrentFingerprintNumber"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getCurrentFingerprintNumber{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_CurrentFingerprintNumber"];

}
+(void)setCurrentICNumber:(NSString*)object{
    
    [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"TT_api_ICNumber"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getCurrentICNumber{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"TT_api_ICNumber"];
    
}
@end

//
//  SettingHelper.h
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import <Foundation/Foundation.h>

@interface SettingHelper : NSObject


+(void)setAccessToken:(NSString*)object;

+(NSString*)getAccessToken;

+(void)setOpenID:(NSString*)object;

+(NSString*)getOpenID;

+(void)setExpireIn:(NSString*)object;

+(NSString*)getExpireIn;

+(void)setUid:(NSString*)object;

+(NSString*)getUid;


+(void)setCurrentFingerprintNumber:(NSString*)object;

+(NSString*)getCurrentFingerprintNumber;

+(void)setCurrentICNumber:(NSString*)object;

+(NSString*)getCurrentICNumber;

@end

//
//  Key.m
//
//  Created by 谢元潮 on 15/5/20.
//  Copyright (c) 2015年 谢元潮. All rights reserved.
//

#import "Key.h"


@implementation Key

@dynamic keyId;
@dynamic lockId;
@dynamic userType;
@dynamic keyStatus;
@dynamic lockName;
@dynamic lockAlias;
@dynamic lockKey;
@dynamic lockMac;
@dynamic lockFlagPos;
@dynamic electricQuantity;
@dynamic aesKeyStr;
@dynamic lockVersion;
@dynamic startDate;
@dynamic endDate;
@dynamic remarks;
@dynamic peripheralUUIDStr;
@dynamic adminPwd;
@dynamic noKeyPwd;
@dynamic deletePwd;
@dynamic username;
@dynamic timezoneRawOffset;

- (BOOL)isAdmin
{
    return [self.userType isEqualToString:@"110301"];
}

@end

@implementation KeyModel

- (BOOL)isAdmin
{
    return [self.userType isEqualToString:@"110301"];
}


@end

@implementation SyncKeyInfo

+ (void)load
{
    [super load];
    [SyncKeyInfo mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"keyList" : @"KeyModel"
                 };
    }];

}

@end

@implementation KeyboardPwdVersion



@end

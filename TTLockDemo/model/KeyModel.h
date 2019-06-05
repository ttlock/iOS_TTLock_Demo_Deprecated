//
//  Key.h
//
//  Created by TTLock on 15/5/20.
//  Copyright (c) 2015年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyModel : NSObject

@property (nonatomic) int32_t keyId;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * userType;
@property (nonatomic, strong) NSString *keyStatus;
@property (nonatomic, strong) NSString * lockName;
@property (nonatomic, strong) NSString * lockAlias;
@property (nonatomic,strong) NSString * lockKey;
@property (nonatomic, strong) NSString * lockMac;
@property (nonatomic, assign) int32_t lockFlagPos;
@property (nonatomic, assign) int32_t electricQuantity;
@property (nonatomic, strong) NSString * aesKeyStr;
@property (nonatomic, strong) NSString * lockVersion;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic,strong) NSString * remarks;
@property (nonatomic, retain) NSString *peripheralUUIDStr;
@property (nonatomic, retain) NSString *adminPwd;
@property (nonatomic, retain) NSString *noKeyPwd;
@property (nonatomic, retain) NSString *deletePwd;

@property(nonatomic, strong) NSString *username;

@property(nonatomic,assign) long timezoneRawOffset;
@property (nonatomic,assign) ino64_t specialValue;
@property (nonatomic, retain) NSString *pwdInfo;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSString *modelNum;
@property (nonatomic, retain) NSString *hardwareRevision;
@property (nonatomic, retain) NSString *firmwareRevision;
- (BOOL)isAdmin;

@end








//
//  Key.h
//
//  Created by TTLock on 15/5/20.
//  Copyright (c) 2015年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <JSONModel/JSONModel.h>
#import <MJExtension/MJExtension.h>
#import "LockModel.h"


@interface Key : NSManagedObject

@property (nonatomic) int32_t keyId;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * userType;  
@property (nonatomic, assign) NSString *keyStatus;
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

@property(nonatomic,assign) int32_t timezoneRawOffset;
@property (nonatomic,assign) ino64_t specialValue;
@property (nonatomic, retain) NSString *pwdInfo;
@property (nonatomic, retain) NSString *timestamp;

- (BOOL)isAdmin;
@end

@interface KeyModel : NSObject

@property (nonatomic) int32_t keyId;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * userType;
@property (nonatomic, assign) NSString *keyStatus;
@property (nonatomic, strong) NSString * lockName;
@property (nonatomic, strong) NSString * lockAlias;
@property (nonatomic,strong) NSString * lockKey;
@property (nonatomic, strong) NSString * lockMac;
@property (nonatomic, assign) int32_t lockFlagPos;
@property (nonatomic, assign) int32_t electricQuantity;
@property (nonatomic, strong) NSString * aesKeyStr;
@property (nonatomic, strong) LockVersion * lockVersion;
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
- (BOOL)isAdmin;


@end

@interface SyncKeyInfo : JSONModel
@property (nonatomic,assign) NSString *lastUpdateDate;
@property (nonatomic,strong) NSArray<KeyModel*> *keyList;
@end

@interface KeyboardPwdVersion : NSObject

@property (nonatomic, assign) NSInteger keyboardPwdVersion;

@end







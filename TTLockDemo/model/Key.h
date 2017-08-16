//
//  Key.h
//
//  Created by 谢元潮 on 15/5/20.
//  Copyright (c) 2015年 谢元潮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <JSONModel/JSONModel.h>
#import <MJExtension/MJExtension.h>
#import "LockModel.h"


/*
 电子钥匙状态
 "110401"已接收
 "110402"待生效
 "110404"冻结中"
 "110405"已冻结
 "110406"取消冻结中
 "110407"删除中
 
 "110408"已删除(我的钥匙)
 "110410"已重置(我的钥匙)
 "110411"修改中
 */


/*!
 @class
 @abstract 钥匙类
 */
@interface Key : NSManagedObject

@property (nonatomic) int32_t keyId;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * userType;  //用户类型：110301-管理员钥匙，110302-普通用户钥匙
@property (nonatomic, assign) NSString *keyStatus;
@property (nonatomic, strong) NSString * lockName;
@property (nonatomic, strong) NSString * lockAlias;
@property (nonatomic,strong) NSString * lockKey;
@property (nonatomic, strong) NSString * lockMac;
@property (nonatomic, assign) int32_t lockFlagPos;    //锁开门标志位
@property (nonatomic, assign) int32_t electricQuantity;   //锁电量
@property (nonatomic, strong) NSString * aesKeyStr;
@property (nonatomic, strong) NSString * lockVersion;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic,strong) NSString * remarks;
/**蓝牙的uuid*/
@property (nonatomic, retain) NSString *peripheralUUIDStr;
@property (nonatomic, retain) NSString *adminPwd;
@property (nonatomic, retain) NSString *noKeyPwd;
@property (nonatomic, retain) NSString *deletePwd;

@property (nonatomic, retain) NSString *deletePwdTmp;
@property (nonatomic, retain) NSString *noKeyPwdTmp;

@property(nonatomic, strong) NSString *username;

@property(nonatomic,assign) int32_t timezoneRawOffset;
- (BOOL)isAdmin;
@end

@interface KeyModel : NSObject

@property (nonatomic) int32_t keyId;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * userType;  //用户类型：110301-管理员钥匙，110302-普通用户钥匙
@property (nonatomic, assign) NSString *keyStatus;
@property (nonatomic, strong) NSString * lockName;
@property (nonatomic, strong) NSString * lockAlias;
@property (nonatomic,strong) NSString * lockKey;
@property (nonatomic, strong) NSString * lockMac;
@property (nonatomic, assign) int32_t lockFlagPos;    //锁开门标志位
@property (nonatomic, assign) int32_t electricQuantity;   //锁电量
@property (nonatomic, strong) NSString * aesKeyStr;
@property (nonatomic, strong) LockVersion * lockVersion;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval endDate;
@property (nonatomic,strong) NSString * remarks;
/**蓝牙的uuid*/
@property (nonatomic, retain) NSString *peripheralUUIDStr;
@property (nonatomic, retain) NSString *adminPwd;
@property (nonatomic, retain) NSString *noKeyPwd;
@property (nonatomic, retain) NSString *deletePwd;

@property(nonatomic, strong) NSString *username;

@property(nonatomic,assign) long timezoneRawOffset;


- (BOOL)isAdmin;


@end

@interface SyncKeyInfo : JSONModel
@property (nonatomic,assign) NSString *lastUpdateDate;
@property (nonatomic,strong) NSArray<KeyModel*> *keyList;//钥匙
@end

@interface KeyboardPwdVersion : NSObject

@property (nonatomic, assign) NSInteger keyboardPwdVersion;

@end







//
//  LockModel.h
//
//  Created by 谢元潮 on 14-10-31.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockVersion : NSObject

@property (nonatomic, assign) NSInteger protocolType;

@property (nonatomic, assign) NSInteger protocolVersion;

@property (nonatomic, assign) NSInteger scene;

@property (nonatomic, assign) NSInteger groupId;

@property (nonatomic, assign) NSInteger orgId;

@end


/*!
 @class
 @abstract 钥匙类
 */
@interface LockModel : NSObject

/**蓝牙的uuid*/
@property (nonatomic, retain) NSString *peripheralUUIDStr;
@property (nonatomic) int32_t lockId;
@property (nonatomic, strong) NSString * lockName;
@property (nonatomic, strong) NSString * lockAlias;
@property (nonatomic, strong) NSString * lockMac;
@property (nonatomic,strong) NSString * lockKey;
@property (nonatomic) int32_t lockFlagPos;
@property(nonatomic,strong)NSString *aesKeyStr;
@property(nonatomic,strong)LockVersion *lockVersion;
@property (nonatomic,strong)NSString *adminPwd;
@property (nonatomic, strong) NSString * noKeyPwd;
@property (nonatomic, strong) NSString * deletePwd;
@property (nonatomic, retain) NSString *pwdInfo;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic,assign) int32_t specialValue;
@property (nonatomic,assign) long long timezoneRawOffset;
@property (nonatomic, assign) int32_t electricQuantity; 


@end

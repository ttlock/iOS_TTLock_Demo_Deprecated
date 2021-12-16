//
//  NetworkHelper.h
//  TTLockDemo
//
//  Created by LXX on 17/2/7.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LockModel.h"

typedef void(^RequestBlock)(id info, NSError* error);

@interface NetworkHelper : NSObject


+ (void)apiPost:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion;

+ (void)apiGet:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion;


+ (void)lockInitializeWithlockAlias:(NSString *)lockAlias lockData:(NSString*)lockData completion:(RequestBlock)completion;

+ (void)listOfLock:(NSInteger)pageNo completion:(RequestBlock) completion;

+ (void)keyListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock) completion;

+ (void)deleteAllKey:(NSInteger)lockId completion:(RequestBlock) completion;

+ (void)keyboardPwdListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock) completion;

+ (void)changeAdminKeyboardPwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion;

+ (void)changeDeletePwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion;

+ (void)rename:(NSString*)lockAlias lockId:(NSInteger)lockId completion:(RequestBlock)completion;

+ (void)resetKey:(NSInteger)lockFlagPos lockId:(NSInteger)lockId completion:(RequestBlock)completion;

+ (void)resetKeyboardPwd:(NSString*)pwdInfo lockId:(NSInteger)lockId timestamp:(NSString*)timestamp completion:(RequestBlock)completion;

+ (void)getKeyboardPwdVersion:(NSInteger)lockId completion:(RequestBlock)completion;



+ (void)sendKey:(NSInteger)lockId receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate remarks:(NSString *)remarks completion:(RequestBlock) completion;

+ (void)getkeyListWithCompletion:(RequestBlock) completion;

+ (void)deleteKey:(NSInteger)keyId completion:(RequestBlock) completion;

+ (void)freezeKey:(NSInteger)keyId completion:(RequestBlock) completion;

+ (void)unFreezeKey:(NSInteger)keyId completion:(RequestBlock) completion;

+ (void)changeKeyPeriod:(NSInteger)keyId startDate:(NSString*)startDate endDate:(NSString*)endDate completion:(RequestBlock) completion;



+ (void)getKeyboardPwd:(NSInteger)lockId keyboardPwdVersion:(NSInteger)keyboardPwdVersion keyboardPwdType:(NSInteger)keyboardPwdType startDate:(NSString *)startDate endDate:(NSString *)endDate completion:(RequestBlock) completion;

+ (void)deleteKeyboardPwd:(NSInteger)keyboardPwdId lockId:(NSInteger)lockId deleteType:(NSInteger)deleteType completion:(RequestBlock) completion;


+ (void)getUidWithCompletion:(RequestBlock) completion;
+ (void)isInitSuccessWithGatewayNetMac:(NSString*)gatewayNetMac completion:(RequestBlock) completion;
+ (void)getGatewayListWithCompletion:(RequestBlock) completion;
+ (void)getGatewayListLockWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion;
+ (void)deleteGatewayWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion;
+ (void)lockQueryDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion;
+ (void)lockUpdateDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion;




+(void)lockUpgradeCheckWithLockId:(int)lockId
                       completion:(RequestBlock) completion;

+(void)lockUpgradeRecheckWithLockId:(int)lockId
                           modelNum:(NSString*)modelNum
                   hardwareRevision:(NSString*)hardwareRevision
                   firmwareRevision:(NSString*)firmwareRevision
                       specialValue:(long long)specialValue
                         completion:(RequestBlock) completion;

+(void)getRecoverDataWithClientId:(NSString*)clientId
                      accessToken:(NSString*)accessToken
                           lockId:(int)lockId
                       completion:(RequestBlock)completion;

+(void)gatewayUpgradeCheckWithGatewayId:(NSNumber *)gatewayId
                             completion:(RequestBlock) completion;

+(void)gatewayuploadDetailWithGatewayId:(NSNumber *)gatewayId
                               modelNum:(NSString*)modelNum
                       hardwareRevision:(NSString*)hardwareRevision
                       firmwareRevision:(NSString*)firmwareRevision
                            networkName:(NSString *)networkName
                             completion:(RequestBlock) completion;

+(void)addWirelessKeypadName:(NSString *)name
					number:(NSString *)number
					   mac:(NSString *)mac
wirelessKeypadFeatureValue:(long long)wirelessKeypadFeatureValue
					lockId:(NSNumber *)lockId
				completion:(RequestBlock) completion;

+ (void)deleteWirelessKeypadWithID:(NSString *)ID completion:(RequestBlock) completion;

+ (void)getWirelessKeypadListWithLockId:(NSNumber *)lockId completion:(RequestBlock) completion;

@end

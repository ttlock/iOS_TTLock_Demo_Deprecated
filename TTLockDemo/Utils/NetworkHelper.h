//
//  NetworkHelper.h
//  TTLockDemo
//
//  Created by 刘潇翔 on 17/2/7.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LockModel.h"
#import "KeyboardPs.h"

typedef void(^RequestBlock)(id info, NSError* error);

@interface NetworkHelper : NSObject


+ (void)apiPost:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion;

+ (void)apiGet:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion;


#pragma mark - 锁相关接口
//  锁初始化
+ (void)initLock:(KeyModel *)LockModel completion:(RequestBlock) completion;
//  获取名下锁列表
+ (void)listOfLock:(NSInteger)pageNo completion:(RequestBlock) completion;
//  获取锁的普通钥匙列表
+ (void)keyListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock) completion;
//  删除所有普通钥匙
+ (void)deleteAllKey:(NSInteger)lockId completion:(RequestBlock) completion;
//  获取锁的键盘密码列表
+ (void)keyboardPwdListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock) completion;
//  修改锁管理员键盘密码
+ (void)changeAdminKeyboardPwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion;
//  修改锁的清空密码
+ (void)changeDeletePwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion;
//  修改锁名称
+ (void)rename:(NSString*)lockAlias lockId:(NSInteger)lockId completion:(RequestBlock)completion;
//  重置普通钥匙
+ (void)resetKey:(NSInteger)lockFlagPos lockId:(NSInteger)lockId completion:(RequestBlock)completion;
//  重置键盘密码
+ (void)resetKeyboardPwd:(NSString*)pwdInfo lockId:(NSInteger)lockId timestamp:(NSString*)timestamp completion:(RequestBlock)completion;
//  获取锁的键盘密码版本
+ (void)getKeyboardPwdVersion:(NSInteger)lockId completion:(RequestBlock)completion;

#pragma mark - 钥匙相关接口
//  发送钥匙
+ (void)sendKey:(NSInteger)lockId receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate remarks:(NSString *)remarks completion:(RequestBlock) completion;
//  同步钥匙数据
+ (void)syncKeyData:(NSString*)lastUpdateDate completion:(RequestBlock) completion;
//  删除钥匙
+ (void)deleteKey:(NSInteger)keyId completion:(RequestBlock) completion;
//  冻结钥匙
+ (void)freezeKey:(NSInteger)keyId completion:(RequestBlock) completion;
//  解除冻结钥匙
+ (void)unFreezeKey:(NSInteger)keyId completion:(RequestBlock) completion;
//  修改钥匙有效期
+ (void)changeKeyPeriod:(NSInteger)keyId startDate:(NSString*)startDate endDate:(NSString*)endDate completion:(RequestBlock) completion;

#pragma mark - 键盘密码相关接口
//  获取键盘密码
+ (void)getKeyboardPwd:(NSInteger)lockId keyboardPwdVersion:(NSInteger)keyboardPwdVersion keyboardPwdType:(NSInteger)keyboardPwdType startDate:(NSString *)startDate endDate:(NSString *)endDate completion:(RequestBlock) completion;
//  重置键盘密码 删除方式:1-通过APP走蓝牙删除，2-通过网关走WIFI删除；不传则默认1,必需先通过APP蓝牙删除密码后调用该接口，如果锁有连接网关，则可以直接调用该接口删除密码。
+ (void)deleteKeyboardPwd:(NSInteger)keyboardPwdId lockId:(NSInteger)lockId deleteType:(NSInteger)deleteType completion:(RequestBlock) completion;

#pragma mark - 网关相关接口
+ (void)getUidWithCompletion:(RequestBlock) completion;
+ (void)isInitSuccessWithGatewayNetMac:(NSString*)gatewayNetMac completion:(RequestBlock) completion;
+ (void)getGatewayListWithPageNo:(int)pageNo completion:(RequestBlock) completion;
+ (void)getGatewayListLockWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion;
+ (void)deleteGatewayWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion;
+ (void)lockQueryDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion;
+ (void)lockUpdateDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion;


#pragma mark - 固件升级相关接口
/**2.39	锁固件升级*/
+(void)lockUpgradeCheckWithLockId:(int)lockId
                       completion:(RequestBlock) completion;

+(void)lockUpgradeRecheckWithLockId:(int)lockId
                           modelNum:(NSString*)modelNum
                   hardwareRevision:(NSString*)hardwareRevision
                   firmwareRevision:(NSString*)firmwareRevision
                       specialValue:(long long)specialValue
                         completion:(RequestBlock) completion;
/**	下载升级包 */
+ (void)downloadZip:(NSString *)url key:(NSString *)key completion:(RequestBlock) completion;
+(void)getRecoverDataWithClientId:(NSString*)clientId
                      accessToken:(NSString*)accessToken
                           lockId:(int)lockId
                       completion:(RequestBlock)completion;
@end

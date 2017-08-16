//
//  TTLockDFU.h
//  TTLockDemo
//
//  Created by TTLock on 2017/8/9.
//  Copyright © 2017年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLockLock.h"
typedef NS_ENUM( NSInteger, UpgradeOpration) {
     UpgradeOprationPreparing  = 1,        //准备中
     UpgradeOprationUpgrading,               //升级中
     UpgradeOprationRecovering,             //恢复中
     UpgradeOprationSuccess,               //升级成功
    
};

typedef NS_ENUM( NSInteger, UpgradeErrorCode) {
    UpgradeErrorCodePeripheralPoweredOff  = 1,                //蓝牙关闭
    UpgradeErrorCodeConnectTimeout ,                      //锁连接超时
    UpgradeErrorCodeNetFail ,                             //网络请求失败
    UpgradeErrorCodeNotSupportCommandEnterUpgradeState,   //锁不支持指令进入升级模式
    UpgradeErrorCodeUpgradeLockFail ,                     //锁升级失败
    UpgradeErrorCodeOutOfMemory,                          //内存不足
    UpgradeErrorNONeedUpgrade,
    UpgradeErrorUnknownUpgradeVersion,
};

typedef void(^TTLockDFUSuccessBlock)(UpgradeOpration type ,NSInteger process);
/**
 *  设置失败的信息
 */
typedef void(^TTLockDFUFailBlock)(UpgradeOpration type, UpgradeErrorCode code);


@interface TTLockDFU : NSObject


+ (instancetype _Nonnull  )shareInstance;

/**
 upgrade Firmware
 
 @param clientId 等同appId
 @param accessToken 访问令牌
 @param lockId 锁id
 @param module 产品型号
 @param hardwareRevision 硬件版本号
 @param firmwareRevision 固件版本号
 @param adminPwd 锁的管理员密码，锁管理相关操作需要携带，校验管理员权限
 @param lockKey 锁开门的关键信息，开门用的
 @param aesKeyStr Aes加解密Key
 @param lockFlagPos 锁标志位
 @param timezoneRawOffset 锁所在时区和UTC时区时间的差数，单位milliseconds，默认28800000（中国时区）
 @param ttLockObject ttLockObject
 @param lockMac lockMac
 @param peripheralUUIDStr peripheralUUIDStr
 */
- (void)upgradeFirmwareWithClientId:(nonnull NSString*)clientId
                        accessToken:(nonnull NSString*)accessToken
                             lockId:(NSInteger)lockId
                             module:(nonnull NSString*)module
                   hardwareRevision:(nonnull NSString*)hardwareRevision
                   firmwareRevision:(nonnull NSString*)firmwareRevision
                           adminPwd:(nonnull NSString*)adminPwd
                            lockKey:(nonnull NSString*)lockKey
                          aesKeyStr:(nonnull NSString*)aesKeyStr
                        lockFlagPos:(int)lockFlagPos
                  timezoneRawOffset:(long)timezoneRawOffset
                       ttLockObject:(nonnull TTLockLock *)ttLockObject
                            lockMac:(nonnull NSString*)lockMac
                  peripheralUUIDStr:(nullable NSString*)peripheralUUIDStr
                       successBlock:(nonnull TTLockDFUSuccessBlock)sblock
                          failBlock:(nonnull TTLockDFUFailBlock)fblock;


@property (nonatomic ,assign)NSInteger timeoutInterval; //连接超时时间设置 默认是10s

- (void)retry;  //继续

- (void)upgradeLock; //不支持指令进入升级 输入密码后 再次升级

#pragma mark 升级中UpgradeOprationUpgrading
- (void)pauseUpgrade; 
- (void)restartUpgrade;
- (BOOL)stopUpgrade;
- (BOOL)paused;

@end

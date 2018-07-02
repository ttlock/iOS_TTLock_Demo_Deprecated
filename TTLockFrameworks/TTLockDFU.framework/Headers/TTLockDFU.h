
//  Created by TTLock on 2017/8/9.
//  Copyright © 2017年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TTLock/TTLock.h>
typedef NS_ENUM( NSInteger, UpgradeOpration) {
     UpgradeOprationPreparing  = 1,
     UpgradeOprationUpgrading,
     UpgradeOprationRecovering,
     UpgradeOprationSuccess,
    
};

typedef NS_ENUM( NSInteger, UpgradeErrorCode) {
    UpgradeErrorCodePeripheralPoweredOff  = 1,
    UpgradeErrorCodeConnectTimeout ,
    UpgradeErrorCodeNetFail ,
    UpgradeErrorCodeNotSupportCommandEnterUpgradeState,
    UpgradeErrorCodeUpgradeLockFail ,
    UpgradeErrorCodeOutOfMemory,
    UpgradeErrorNONeedUpgrade,
    UpgradeErrorUnknownUpgradeVersion,
};

typedef void(^TTLockDFUSuccessBlock)(UpgradeOpration type ,NSInteger process);
typedef void(^TTLockDFUFailBlock)(UpgradeOpration type, UpgradeErrorCode code);


@interface TTLockDFU : NSObject


+ (instancetype _Nonnull  )shareInstance;

/**
 upgrade Firmware
 
 @param clientId           The app_id which is assigned by system when you create an application
 @param accessToken        Access token
 @param lockId
 @param module
 @param hardwareRevision
 @param firmwareRevision
 @param adminPwd            admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 @param lockKey             The key data which will be used to unlock
 @param aesKeyStr           AES encryption key
 @param lockFlagPos         The flag which will be used to check the validity of the ekey
 @param timezoneRawOffset   The offset between your time zone and UTC, in millisecond
 @param ttLockObject        ttLockObject
 @param lockMac             lockMac
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
                       ttLockObject:(nonnull TTLock *)ttLockObject
                            lockMac:(nonnull NSString*)lockMac
                  peripheralUUIDStr:(nullable NSString*)peripheralUUIDStr
                       successBlock:(nonnull TTLockDFUSuccessBlock)sblock
                          failBlock:(nonnull TTLockDFUFailBlock)fblock;


/**
 Connection timeout time setting, the default is 10s
 */
@property (nonatomic ,assign)NSInteger timeoutInterval;
/**
 Do not support instructions to enter the upgrade, enter the password, upgrade again.
 */
- (void)upgradeLock;

- (void)retry;

#pragma mark 升级中UpgradeOprationUpgrading
- (void)pauseUpgrade; 
- (void)restartUpgrade;
- (BOOL)stopUpgrade;
- (BOOL)paused;

@end

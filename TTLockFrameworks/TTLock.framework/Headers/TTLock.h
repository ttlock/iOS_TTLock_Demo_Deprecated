
//
//  Created by TTLock on 2017/8/11.
//  Copyright © 2017年 TTLock. All rights reserved.
//  version:2.8.9

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TTSpecialValueUtil.h"
#import "TTUtils.h"
#import "SecurityUtil.h"
#import "TTLockGateway.h"
#import "TTSDKDelegate.h"
#import "TTWirelessKeypad.h"
#import "TTWirelessKeypadScanModel.h"
#import "TTGatewayScanModel.h"
#import "TTSystemInfoModel.h"

@interface TTLock : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>

/**
 Whether or not print the log in SDK
 @param debug The default value is `NO`.
 */
+ (void)setDebug:(BOOL)debug;

/* An object that will receive the TTLock delegate methods */
@property (nonatomic, weak) id <TTSDKDelegate> delegate;

/** Which user's operation is recorded，corresponding to the "openid" of the "openAPI". */

@property (nonatomic, strong) NSString *uid;

/** Special string of v3 lock when adding administrator
    There is a default value that can not be set */
@property (nonatomic, strong) NSString *setClientPara;

/**If yes - the ttlock object is created, if the Bluetooth is not turned on, the system will alert the box.
 The default value is `NO` */
@property (nonatomic,assign) BOOL isShowBleAlert;

/** Entry point to the central role */
@property (nonatomic,strong,readonly) CBCentralManager *manager;

/** Current connected Bluetooth */
@property (nonatomic,strong, readonly) CBPeripheral *activePeripheral;

/*!
 *  @property state
 *
 *  @discussion The current state of the manager, initially set to <code>TTLockManagerStateUnknown</code>.
 *				Updates are provided by required delegate method {@link TTLockManagerDidUpdateState:}.
 *
 */
@property(nonatomic, assign, readonly) TTManagerState state;
/*!
 *  @property isScanning
 *
 *  @discussion Whether or not the central is currently scanning.
 *
 */
@property(nonatomic, assign, readonly) BOOL isScanning NS_AVAILABLE(NA, 9_0);

/** Initialize the TTLock class */
-(id)initWithDelegate:(id<TTSDKDelegate>)TTDelegate;

/** Get a single case */
+ (TTLock*)sharedInstance;

/** Creating a Bluetooth object
 *
 *  @see TTManagerDidUpdateState:
 */
-(void)setupBlueTooth;

/**
 Start scanning near specific service Bluetooth.

 @param isScanDuplicates every time the peripheral is seen, which may be many times per second. This can be useful in specific situations.If you only support v3 lock,we recommend this value to be 'NO',otherwise to be 'YES'.
 *
 *  @see onFoundDevice_peripheralWithInfoDic:
 */
-(void)startBTDeviceScan:(BOOL)isScanDuplicates;
/**
 Start scanning all Bluetooth nearby
 If you need to develop wristbands, you can use this method
 @param isScanDuplicates every time the peripheral is seen, which may be many times per second. This can be useful in specific situations.Recommend this value to be NO
 *
 *  @see onFoundDevice_peripheralWithInfoDic:
 */
- (void)scanAllBluetoothDeviceNearby:(BOOL)isScanDuplicates;

/** Stop scanning
 */
-(void)stopBTDeviceScan;

/** Connecting peripheral
 *  Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link disconnect}.
 *
 *  @see  onBTConnectSuccess_peripheral:lockName:
 */
-(void)connect:(CBPeripheral *)peripheral;

/** Cancel connection
 *
 *  @see onBTDisconnect_peripheral:
 */
-(void)disconnect:(CBPeripheral *)peripheral;

/**
 Connecting peripheral
 Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link cancelConnectPeripheralWithLockMac}.
 @param lockMac (If there is no 'lockMac',you can use 'lockName'）
 *
 *  @see  onBTConnectSuccess_peripheral:lockName:
 */
- (void)connectPeripheralWithLockMac:(NSString *)lockMac;
/**
 Cancel connection
 @param lockMac （If there is no 'lockMac',you can use 'lockName'）
 *
 *  @see onBTDisconnect_peripheral:
 */
- (void)cancelConnectPeripheralWithLockMac:(NSString *)lockMac;

/**
 * Lock initialize (Add administrator, it also applies to Parking Lock)
 * param addDic
 Key                    Type       required     Description
 
 lockMac              NSString      YES
 protocolType         NSNumber      YES
 protocolVersion      NSNumber      YES
 hotelInfo            NSString       NO
 buildingNumber       NSString       NO
 floorNumber          NSString       NO
 *
 *  @see  onLockInitializeWithLockData:
 *  @see  TTError: command: errorMsg:
 */   
-(void)lockInitializeWithInfoDic:(NSDictionary *)infoDic;

/** Get the version of lock
 *
 *  @see  onGetProtocolVersion:
 *  @see  TTError: command: errorMsg:
 */
-(void)getProtocolVersion;

/** Administrator unlock (It also applies to Parking Lock drop)

 *  adminPS    admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey    The key data which will be used to unlock
 *  aesKey     AES encryption key
 *  version    Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag       The flag which will be used to check the validity of the ekey
 *  uniqueid   It is used to identify the lock record inside the lock, and the size can not exceed 4 bytes.Recommended time stamp (in seconds)
 *  timezoneRawOffset   The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onUnlockWithLockTime:
 *  @see  TTError: command: errorMsg:
 */
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/** eKey unlock (It also applies to Parking Lock drop)
 *  lockkey    The key data which will be used to unlock
 *  aesKey     AES encryption key
 *  startDate  The time when it becomes valid.  If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  endDate    The time when it is expired. If it's a permanent key ,set the [NSDate dateWithTimeIntervalSince1970:0]
 *  version    Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag       The flag which will be used to check the validity of the ekey
 *  uniqueid   It is used to identify the lock record inside the lock, and the size can not exceed 4 bytes.Recommended time stamp (in seconds)
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onUnlockWithLockTime:
 *  @see  TTError: command: errorMsg:
 */
-(void)unlockByUser_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate*)startDate endDate:(NSDate*)endDate version:(NSString*)version unlockFlag:(int)flag  uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/**  eKey calibrate the lock's clock and unlock it, consistent with referenceTime.
 *  lockkey    The key data which will be used to unlock
 *  aesKey     AES encryption key
 *  startDate  The time when it becomes valid.  If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  endDate    The time when it is expired. If it's a permanent key ,set the [NSDate dateWithTimeIntervalSince1970:0]
 *  version    Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag       The flag which will be used to check the validity of the ekey
 *  referenceTime  Time of calibration
 *  uniqueid  It is used to identify the lock record inside the lock, and the size can not exceed 4 bytes.Recommended time stamp (in seconds)
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onUnlockWithLockTime:
 *  @see  TTError: command: errorMsg:
 */
-(void)calibationTimeAndUnlock_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate *)sdate endDate:(NSDate *)edate version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/**
 lock （It also applies to door locks that support this function and Parking Lock rise）
 @param lockkey  The key data which will be used to unlock
 @param aesKey   AES encryption key
 @param  flag    The flag which will be used to check the validity of the ekey
 @param uniqueid It is used to identify the lock record inside the lock, and the size can not exceed 4 bytes.Recommended time stamp (in seconds)
 @param isAdmin  YSE is the administrator,otherwise it's ekey
 @param sdate    The time when it becomes valid.  If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 @param edate    The time when it is expired. If it's a permanent key ,set the [NSDate dateWithTimeIntervalSince1970:0]
 @param timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onLockingWithLockTime:
 *  @see  TTError: command: errorMsg:
 */
- (void)locking_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid isAdmin:(BOOL)isAdmin startDate:(NSDate *)sdate endDate:(NSDate *)edate timezoneRawOffset:(long)timezoneRawOffset;

/** Calibrate the lock of the clock
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *  version Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag  The flag which will be used to check the validity of the ekey
 *  referenceTime  Time of calibration
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onSetLockTime
 *  @see  TTError: command: errorMsg:
 */
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time timezoneRawOffset:(long)timezoneRawOffset;

/** Set Admin Passcode
 *  keyboardPassword  Admin Passcod, Passcode range ： v2 lock : 7 - 9 Digits in length
                                                      v3 lock : 4 - 9 Digits in length
 *  adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey  The key data which will be used to unlock
 *  aesKey   AES encryption key
 *  version  Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag     The flag which will be used to check the validity of the ekey
 *
 *  @see  onSetAdminKeyboardPassword
 *  @see  TTError: command: errorMsg:
 */
-(void)setAdminKeyBoardPassword:(NSString*)keyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** Set Erase Passcode
 *  delKeyboardPassword Erase Passcode, Passcode range ： v2 lock : 7 - 9 Digits in length
                                                          v3 lock : 4 - 9 Digits in length
 *  adminPS   admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey   The key data which will be used to unlock
 *  aesKey    AES encryption key
 *  version   Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag      The flag which will be used to check the validity of the ekey
 *
 *  @see  onSetAdminDeleteKeyboardPassword
 *  @see  TTError: command: errorMsg:
 */
-(void)setAdminDeleteKeyBoardPassword:(NSString*)delKeyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/**
 *  Reset ekey
 *  adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *  version Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag    The flag which will be used to check the validity of the ekey
 *
 *  @see  onResetEkey
 *  @see  TTError: command: errorMsg:
 */
-(void)resetEkey_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/** Reset keyboard Passcode
 *  adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey  The key data which will be used to unlock
 *  aesKey   AES encryption key
 *  version  Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag     The flag which will be used to check the validity of the ekey
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onResetKeyboardPassword_timestamp:pwdInfo:
 *  @see  TTError: command: errorMsg:
 */
-(void)resetKeyboardPassword_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/** Get Lock battery（Only for the v3 lock）
 *
 *  @see  onGetElectricQuantity:
 *  @see  TTError: command: errorMsg:
 */
-(void)getElectricQuantity_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;

/** Reset Lock （That is delete the lock，Only for the administrator of v3 lock ）
 *  adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey  The key data which will be used to unlock
 *  aesKey   AES encryption key
 *  version  Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag     The flag which will be used to check the validity of the ekey
 *
 *  @see  onResetLock
 *  @see  TTError: command: errorMsg:
 */
-(void)resetLock_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;
/**
 *  Delete a single keyboard passcode （Only for the administrator of v3 lock）
 *  keyboardPs  The passcode to delete
 *  passwordType(can set any value）
 *  adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey  The key data which will be used to unlock
 *  aesKey   AES encryption key
 *  version  Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag     The flag which will be used to check the validity of the ekey
 *
 *  @see  OnDeleteUserKeyBoardPassword
 *  @see  TTError: command: errorMsg:
 */
-(void)deleteOneKeyboardPassword:(NSString *)keyboardPs adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey passwordType:(KeyboardPsType)passwordType  version:(NSString*)version unlockFlag:(int)flag;
/**
 Modify the keyboard passcode
 
 @param newPassword  new passcode ,Passcode range : 4 - 9 Digits in length. If you do not need to modify the password, set the nil
 @param oldPassword  old passcode
 @param startDate The time when it becomes valid .If you do not need to modify the time, set the nil
 @param endDate  The time when it is expired .If you do not need to modify the time, set the nil
 @param adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 @param lockkey The key data which will be used to unlock
 @param aesKey AES encryption key
 @param flag The flag which will be used to check the validity of the ekey
 @param timezoneRawOffset  The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onModifyUserKeyBoardPassword
 *  @see  TTError: command: errorMsg:
 */
- (void)modifyKeyboardPassword_newPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword  startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;


/**
 Recover the keyboard passcode
 
 @param passwordType  Passcode Type
 @param cycleType     Cycle Type , if passwordType != KeyboardPsTypeCycle ,can set any value
 @param newPassword   New Passcode
 @param oldPassword   Old Passcode
 @param startDate The time when it becomes valid
 @param endDate The time when it is expired, if passwordType != KeyboardPsTypePeriod ,can set nil
 @param adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 @param lockkey  The key data which will be used to unlock
 @param aesKey AES encryption key
 @param flag The flag which will be used to check the validity of the ekey
 @param timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onRecoverUserKeyBoardPassword
 *  @see  TTError: command: errorMsg:
 */
- (void)recoverKeyboardPassword_passwordType:(KeyboardPsType)passwordType cycleType:(NSInteger)cycleType newPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword  startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;

/**
 Add keyboard passcode
 
 @param keyboardPs The Passcode to add ,Passcode range : 4 - 9 Digits in length. If you do not need to modify the password, set the nil
 @param startDate The time when it becomes valid
 @param endDate The time when it is expired
 @param adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 @param lockkey The key data which will be used to unlock
 @param aesKey AES encryption key
 @param flag The flag which will be used to check the validity of the ekey
 @param timezoneRawOffset  The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onAddUserKeyBoardPassword
 *  @see  TTError: command: errorMsg:
 
 */
- (void)addKeyboardPassword_password:(NSString *)keyboardPs startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  Get the operation record
 *  type    OperateLogType
 *  aesKey  AES encryption key
 *  version Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag The flag which will be used to check the validity of the ekey
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onGetOperateLog_LockOpenRecordStr:
 *  @see  TTError: command: errorMsg:
 */
- (void)getOperateLog_type:(OperateLogType)type aesKey:(NSString*)aesKey version:(NSString *)version unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  Get Lock Time
 *  aesKey  AES encryption key
 *  version Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  flag The flag which will be used to check the validity of the ekey
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see  onGetLockTime:
 *  @see  TTError: command: errorMsg:
 */
- (void)getLockTime_aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  Get Lock SpecialValue
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *
 *  @see  onGetDeviceCharacteristic:
 *  @see  TTError: command: errorMsg:
 */
- (void)getDeviceCharacteristic_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;
/**
 *  Operate IC
 *  type      OprationType
 *  ICNumber  Card Number , if (type == OprationTypeClear || type == OprationTypeAdd || type == OprationTypeQuery) ,set the nil.
 *  adminPS   Admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey   The key data which will be used to unlock
 *  aesKey    AES encryption key
 *  startDate The time when it becomes valid. if(type == OprationTypeModify || type == OprationTypeRecover),need to set.If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  endDate   The time when it is expired. if(type == OprationTypeModify || type == OprationTypeRecover),need to set.If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  flag      The flag which will be used to check the validity of the ekey
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see onAddICWithState: ICNumber:
 *  @see onClearIC
 *  @see onDeleteIC
 *  @see onModifyIC
 *  @see onGetOperateLog_LockOpenRecordStr:
 *  @see  TTError: command: errorMsg:
 */
- (void)operate_type:(OprationType)type adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey ICNumber:(NSString*)ICNumber startDate:(NSDate*)startDate endDate:(NSDate*)endDate unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  Operate  Fingerprint
 *  type                OprationType
 *  FingerprintNumber   Fingerprint Number , if (type == OprationTypeClear || type == OprationTypeAdd || type == OprationTypeQuery) ,set the nil.
 *  adminPS             admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey             The key data which will be used to unlock
 *  aesKey              AES encryption key
 *  startDate  The time when it becomes valid. if(type == OprationTypeModify || type == OprationTypeRecover),need to set.If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  endDate    The time when it is expired. if(type == OprationTypeModify || type == OprationTypeRecover),need to set.If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  unlockFlag  The flag which will be used to check the validity of the ekey
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see onAddFingerprintWithState:fingerprintNumber:currentCount:totalCount:
 *  @see onClearFingerprint
 *  @see onDeleteFingerprint
 *  @see onGetOperateLog_LockOpenRecordStr:
 *  @see  TTError: command: errorMsg:
 */
- (void)operateFingerprint_type:(OprationType)type adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey FingerprintNumber:(NSString*)FingerprintNumber startDate:(NSDate*)startDate endDate:(NSDate*)endDate unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  Set Locking Time
 *  OprationType   only Query and Modify
 *  time           Locking time,  if (type == OprationTypeModify),set the 0 means no locking .  if (type == OprationTypeQuery),set the any value
 *  adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *  unlockFlag  The flag which will be used to check the validity of the ekey
 *
 *  @see onQueryLockingTimeWithCurrentTime: minTime: maxTime:
 *  @see onModifyLockingTime
 *  @see  TTError: command: errorMsg:
 */
- (void)setLockingTime_type:(OprationType)type time:(int)time adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Get Device Info   1-Product model 2-Hardware version 3-Firmware version..., reference enum: TTUtils.h -> DeviceInfoType
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *
 *  @see onGetDeviceInfo:
 *  @see  TTError: command: errorMsg:
 */
- (void)getDeviceInfo_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;
/**
 *  Enter lock upgrade state
 *  adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey  The key data which will be used to unlock
 *  aesKey   AES encryption key
 *  unlockFlag  The flag which will be used to check the validity of the ekey
 *
 *  @see onEnterFirmwareUpgradeMode
 *  @see  TTError: command: errorMsg:
 */
- (void)upgradeFirmware_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/** Get Lock Switch State
 *  aesKey  AES encryption key
 *
 *  @see onGetLockSwitchState:
 *  @see  TTError: command: errorMsg:
 */
- (void)getLockSwitchState_aesKey:(NSString*)aesKey;
/**
 Whether the input password is displayed on the screen
 
 @param type   1- Query 2- Modify
 @param isShow Whether or not to display a password , NO-hide  YES-show ,It is useful when the operation type is 2- Modify
 @param adminPS  admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 @param lockkey  The key data which will be used to unlock
 @param aesKey  AES encryption key
 @param unlockFlag The flag which will be used to check the validity of the ekey
 *
 *  @see onGetLockSwitchState:
 *  @see onModifyScreenShowState
 *  @see  TTError: command: errorMsg:
 */
- (void)operateScreen_type:(int)type isShow:(BOOL)isShow adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Read the unlocked password list
 *  adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  aesKey  AES encryption key
 *  timezoneRawOffset The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 *
 *  @see onGetOperateLog_LockOpenRecordStr:
 *  @see  TTError: command: errorMsg:
 */
- (void)getKeyboardPasswordList_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
    Reading new password data
 *
 *  @see onGetPasswordData_timestamp:pwdInfo:
 */
- (void)getPasswordData_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  Operate  Door Sensor Locking
 *  OprationType  only Query and Modify
 *  isOn    Set door sensor locking switch , NO-off  YES-on ,It is useful when the operation type is Modify
 *  adminPS admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *  unlockFlag  The flag which will be used to check the validity of the ekey
 *
 *  @see onQueryDoorSensorLocking:
 *  @see onModifyDoorSensorLocking
 *  @see  TTError: command: errorMsg:
 */
- (void)operateDoorSensorLocking_type:(OprationType)type isOn:(BOOL)isOn adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/** Get Door Sensor State
 *  lockkey The key data which will be used to unlock
 *  aesKey  AES encryption key
 *
 * @see onGetDoorSensorState:
 * @see  TTError: command: errorMsg:
 */
- (void)getDoorSensorState_aesKey:(NSString*)aesKey;
/**
 *  Operate  Remote Unlock Swicth
 *  OprationType    only Query and Modify
 *  isOn            NO-off  YES-on ,It is useful when the operation type is Modify
 *  adminPS         admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey         The key data which will be used to unlock
 *  aesKey          AES encryption key
 *  unlockFlag      The flag which will be used to check the validity of the ekey
 *
 *  @see onOperateRemoteUnlockSwicth_type:stateInfo:
 *  @see  TTError: command: errorMsg:
 */
- (void)operateRemoteUnlockSwicth_type:(OprationType)type isOn:(BOOL)isOn adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Operate Audio Switch
 *  OprationType    only Query and Modify
 *  isOn            NO-off  YES-on ,It is useful when the operation type is Modify
 *  adminPS         admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey         The key data which will be used to unlock
 *  aesKey          AES encryption key
 *  unlockFlag      The flag which will be used to check the validity of the ekey
 *
 *  @see onQueryAudioSwitch:
 *  @see onModifyAudioSwitch
 *  @see  TTError: command: errorMsg:
 */
- (void)operateAudioSwitch_type:(OprationType)type isOn:(BOOL)isOn adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Operate Remote Control
 * If the user presses the button all the time, it needs to send a button message every 500 milliseconds.
 *  OprationType    1-Query , 2-Click button
 *  buttonValue     enum RemoteControlButtonValueType,It is useful when the operation type is 2-Click button
 *  isAdmin         YSE is the administrator,otherwise it's ekey
 *  startDate       The time when it becomes valid.  If it's a permanent key, set the [NSDate dateWithTimeIntervalSince1970:0]
 *  endDate         The time when it is expired. If it's a permanent key ,set the [NSDate dateWithTimeIntervalSince1970:0]
 *  lockkey         The key data which will be used to unlock
 *  aesKey          AES encryption key
 *  version          Lock version ,Consist of protocolType.protocolVersion.scene.groupId.orgId, dot-separated components , Such as: 5.3.2.1.1
 *  unlockFlag      The flag which will be used to check the validity of the ekey
 *  uniqueid        It is used to identify the lock record inside the lock, and the size can not exceed 4 bytes.Recommended time stamp (in seconds).
 *  timezoneRawOffset  The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
 
 *  @see  onQueryRemoteControl:
          Only when 1-Query has a response, the 2-Click button  has no response.
 *  @see  TTError: command: errorMsg:
 */
- (void)operateRemoteControl_type:(int)type buttonValue:(RemoteControlButtonValueType)buttonValue isAdmin:(BOOL)isAdmin startDate:(NSDate*)startDate endDate:(NSDate*)endDate lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)unlockFlag uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  Set NB Server
 *  @see  onSetNBServer
 *  @see  TTError: command: errorMsg:
 */
-(void)setNBServerWithPortNumber:(NSString*)portNumber serverAddress:(NSString*)serverAddress adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/**
 *  Get Admin Unlock Passcode
 *  adminPS         admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey         The key data which will be used to unlock
 *  aesKey          AES encryption key
 *  unlockFlag    The flag which will be used to check the validity of the ekey
 *  @see  onGetAdminKeyBoardPassword:
 *  @see  TTError: command: errorMsg:
 */
-(void)getAdminKeyBoardPasswordWithAdminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/**
 *  Set Lock's Wristband Key
 *  wristbandKey  set wristband Key
 *  keyboardPassword  the lock's Admin Passcode
 *  adminPS      admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey      The key data which will be used to unlock
 *  aesKey       AES encryption key
 *  unlockFlag   The flag which will be used to check the validity of the ekey
 *
 *  @see onSetLockWristbandKey
 *  @see  TTError: command: errorMsg:
 */
- (void)setLockWristbandKey:(NSString*)wristbandKey keyboardPassword:(NSString*)keyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 * Set Wristband's Key
 * isOpen  Does this function open
 *
 *  @see onSetWristbandKey
 *  @see  TTError: command: errorMsg:
 */
- (void)setWristbandKey:(NSString*)wristbandKey isOpen:(BOOL)isOpen;
/**
 * Set Wristband's Rssi
 * rssi    set rssi
 *
 *  @see onSetWristbandRssi
 *  @see  TTError: command: errorMsg:
 */
- (void)setWristbandRssi:(int)rssi;

/**
*  Add FingerprintData
*  fingerprintData         fingerprintData
*  tempFingerprintNumber   temp FingerprintNumber
*  startDate               millisecond
*  endDate                 millisecond
*  adminPS                 admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
*  lockkey                 The key data which will be used to unlock
*  aesKey                  AES encryption key
*  unlockFlag              The flag which will be used to check the validity of the ekey
*  timezoneRawOffset       The offset between your time zone and UTC, in millisecond. Without this value, set the -1.
*
*  @see onAddFingerprintWithState:fingerprintNumber:currentCount:totalCount:
*  @see  TTError: command: errorMsg:
 */
- (void)addFingerprintData:(NSString *)fingerprintData tempFingerprintNumber:(NSString*)tempFingerprintNumber startDate:(long long)startDate endDate:(long long)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  Query Passage Mode
 *  adminPS                 admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey                 The key data which will be used to unlock
 *  aesKey                  AES encryption key
 *  unlockFlag              The flag which will be used to check the validity of the ekey
 *
 *  @see  onQueryPassageModeWithRecord:
 *  @see  TTError: command: errorMsg:
 */
- (void)queryPassageModeWithAdminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Add Or Modify Passage Mode
 *  type                 PassageModeType
 *  weekDays        if type == PassageModeTypeWeek,  week：1~7,1 means Sunday，2 means  Monday ,...,6 means Saturday,  0 means everyday
 if type != PassageModeTypeWeek,  effective value ：1~31
 *  month                   effective value ：1~12， set 0 if type != PassageModeTypeMonthAndDay
 *  startDate               millisecond ,0 means all day
 *  endDate                 millisecond ,0 means all day
 *  adminPS                 admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey                 The key data which will be used to unlock
 *  aesKey                  AES encryption key
 *  unlockFlag              The flag which will be used to check the validity of the ekey
 *
 *  @see  onConfigPassageMode
 *  @see  TTError: command: errorMsg:
 */
- (void)configPassageModeWithType:(PassageModeType)type weekDays:(NSArray*)weekDays month:(int)month startDate:(int)startDate endDate:(int)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  unlockFlag:(int)unlockFlag;
/**
 *  Delete Passage Mode
 *  adminPS                 admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey                 The key data which will be used to unlock
 *  aesKey                  AES encryption key
 *  unlockFlag              The flag which will be used to check the validity of the ekey
 *
 *  @see  onDeletePassageMode
 *  @see  TTError: command: errorMsg:
 */
- (void)deletePassageModeWithType:(PassageModeType)type weekDays:(NSArray*)weekDays day:(int)day month:(int)month adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  Clear Passage Mode
 *  adminPS                 admin code, which only belongs to the admin ekey, will be used to verify the admin permission.
 *  lockkey                 The key data which will be used to unlock
 *  aesKey                  AES encryption key
 *  unlockFlag              The flag which will be used to check the validity of the ekey
 *
 *  @see  onCleanPassageMode
 *  @see  TTError: command: errorMsg:
 */
- (void)clearPassageModeWithAdminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
#pragma mark --- 废弃

@property (nonatomic) BOOL parklockAction __attribute__((deprecated("SDK2.6.3")));
@property (nonatomic,readonly) int allowUnlock __attribute__((deprecated("SDK2.6")));
@property (nonatomic,readonly) int oneMeterRSSI __attribute__((deprecated("SDK2.6")));
- (void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)referenceTime __attribute__((deprecated("SDK2.6")));
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag __attribute__((deprecated("SDK2.6")));
-(void)cancelConnectPeripheral:(CBPeripheral *)peripheral __attribute__((deprecated("SDK2.7.1")));
-(void)startBTDeviceScan __attribute__((deprecated("SDK2.7.1")));
- (void)scanAllBluetoothDeviceNearby __attribute__((deprecated("SDK2.7.1")));
- (void)scanSpecificServicesBluetoothDevice_ServicesArray:(NSArray*)servicesArray __attribute__((deprecated("SDK2.7.1")));
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid __attribute__((deprecated("SDK2.7.1")));
-(void)addAdministrator_advertisementData:(NSDictionary *)advertisementData adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward __attribute__((deprecated("SDK2.7.4")));
- (void)scanSpecificServicesBluetoothDevice_ServicesArray:(NSArray<NSString *>*)servicesArray isScanDuplicates:(BOOL)isScanDuplicates __attribute__((deprecated("SDK2.7.5")));
-(int)getPower;
-(void)addAdministrator_addDic:(NSDictionary *)addDic __attribute__((deprecated("SDK2.7.7")));
-(void)getOperateLog_aesKey:(NSString*)aesKey version:(NSString *)version unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset __attribute__((deprecated("SDK2.7.7")));

@end



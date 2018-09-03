//
//  TTSDKDelegate.h
//  TTLockDemo
//
//  Created by 王娟娟 on 2017/10/25.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTSDKDelegate <NSObject>

@optional

/**
   Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
   <code>TTManagerStatePoweredOn</code>. A state below <code>TTManagerStatePoweredOn</code>
   implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
   <code>TTManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
   manager become invalid and must be retrieved or discovered again.
 */
- (void)TTManagerDidUpdateState:(TTManagerState)state;

/**
 *  This method is invoked when the lock returns an error
 *
 *  @param error     error code
 *  @param command   command value
 *  @param errorMsg  Error description
 */
-(void)TTError:(TTError)error command:(int)command errorMsg:(NSString*)errorMsg;

/**
 *  This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>.
 *  A dictionary containing scan response data.
 *  peripheral
 *  rssi
 *  lockName
 *  lockMac
 *  isContainAdmin      Whether there is an administrator in the lock (that is, whether it is in setting mode)
 *  isAllowUnlock       YES for someone to touch the lock, v2 lock has been YES, parking lock has been NO
 *  oneMeterRSSI        RSSI about one meter away from the lock
 *  protocolType        Protocol type ,  5 is door lock ,  10 is parking lock,  0x3412 is wristband
 *  protocolVersion     Protocol version , 1 is v2 'LOCK' , 4 is v2 lock ,  3 is v3 lock
 *  scene               Scene
 *  lockSwitchState     The switch state of the parking lock (scene = = 7). The value of the lock which does not support this function is TTLockSwitchStateUnknown.
 *  doorSensorState
 *  electricQuantity    Lock battery (a lock that does not get battery, electricQuantity==-1)
 *  isDfuMode           Is it in the upgrade mode
 */
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic;

/**
 *  This method is invoked when a connection initiated by {@link connect:} or {@link connectPeripheralWithLockMac:} has succeeded.
 *
 *  @param peripheral     The <code>CBPeripheral</code> that has connected.
 *  @param lockName       lock Name
 */

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName;

/**
 *  This method is invoked upon the disconnection of a peripheral
 *
 *  @param periphera   The <code>CBPeripheral</code> that has disconnected.
 */
-(void)onBTDisconnect_peripheral:(CBPeripheral*)periphera;

/**
 *  Get Protocol Version
 *  @param versionStr  Consist of protocolType.protocolVersion.scene.groupId.orgId, Connect with a point (.) , Such as: 5.3.2.1.1
 */
-(void)onGetProtocolVersion:(NSString*)versionStr;

/**
 *  This method is invoked when {@link lockInitializeWithInfoDic:} has succeeded.
 */
-(void)onLockInitializeWithLockData:(NSString*)lockData;

/**
 *   This method is invoked when {@link setLockTime_lockKey:aesKey:version:unlockFlag: referenceTime:timezoneRawOffset:} has succeeded.
 */
-(void)onSetLockTime;

/**
 This method is invoked when {@link unlockByAdministrator_adminPS: lockKey: aesKey: version:unlockFlag: uniqueid: timezoneRawOffset:}
                          or {@link unlockByUser_lockKey: aesKey: startDate: endDate: version: unlockFlag:  uniqueid: timezoneRawOffset:}
                          or {@link calibationTimeAndUnlock_lockKey: aesKey:startDate: endDate: version: unlockFlag:referenceTime: uniqueid: timezoneRawOffset:} has succeeded.

 @param lockTime   The time in the lock, "0" means can't get the time
 @param electricQuantity lock battery
 */
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime electricQuantity:(int)electricQuantity;

/**
 This method is invoked when {@link locking_lockKey: aesKey: unlockFlag: uniqueid: isAdmin: startDate: endDate: timezoneRawOffset:} has succeeded.
 
 @param lockTime           The time in the lock, "0" means can't get the time
 @param electricQuantity   lock battery
 */
- (void)onLockingWithLockTime:(NSTimeInterval)lockTime electricQuantity:(int)electricQuantity;

/**
 *  This method is invoked when {@link setAdminKeyBoardPassword: adminPS: lockKey: aesKey:version: unlockFlag:} has succeeded.
 */
-(void)onSetAdminKeyboardPassword;
/**
 *  This method is invoked when {@link setAdminDeleteKeyBoardPassword: adminPS: lockKey: aesKey: version: unlockFlag:} has succeeded.
 */
-(void)onSetAdminDeleteKeyboardPassword;
/**
 *  This method is invoked when {@link resetKeyboardPassword_adminPS: lockKey: aesKey: version: unlockFlag:} has succeeded.
 */
-(void)onResetKeyboardPassword_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo;
/**
 *  Reset Ekey Successfully
 */
-(void)onResetEkey;

/**
 *  Get Lock Battery Successfully
 *  @param electricQuantity
 */
-(void)onGetElectricQuantity:(int)electricQuantity;

/**
 *  Reset Lock Successfully
 */
-(void)onResetLock;

/**
 *  This method is invoked when {@link getOperateLog_aesKey: version: unlockFlag: timezoneRawOffset:}
                             or {@link getKeyboardPasswordList_adminPS:}
                             or {@link operateFingerprint_type}
                             or {@link operate_type: adminPS: lockKey: aesKey: ICNumber: startDate: endDate: unlockFlag: timezoneRawOffset:} has succeeded.
 */
- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr;
/**
 *  Delete User KeyBoard Password Successfully
 */
- (void)OnDeleteUserKeyBoardPassword;
/**
    Modify User KeyBoard Password  Successfully
 */
- (void)onModifyUserKeyBoardPassword;
/**
  Add User KeyBoard Password  Successfully
 */
- (void)onAddUserKeyBoardPassword;
/**
 *  Get Device Characteristic Successfully
    characteristic  Use "TTSpecialValueUtil.h" to judge
 */
- (void)onGetDeviceCharacteristic:(long long)characteristic;
/**
 *  Get Lock Time Successfully
 */
- (void)onGetLockTime:(NSTimeInterval)lockTime;
/**
 *  Set Lock WristbandKey Successfully
 */
- (void)onSetLockWristbandKey;
/**
 *  Set WristbandKey Successfully
 */
- (void)onSetWristbandKey;
/**
 *  Set Wristband Rssi Successfully
 */
- (void)onSetWristbandRssi;
/**
 *  Low Power Callback (Only "LOCK" will be a callback)
 */
- (void)onLowPower;
/**
 *  Add IC Card Successfully
 *
 *  @param state     1->Identify IC card and add successfully  2->Successfully start adding IC card mode
 *  @param ICNumber  State "1" contains card number, other states have no card number.
 */
- (void)onAddICWithState:(AddICState)state ICNumber:(NSString*)ICNumber;
/**
 *  Clear IC Successfully
 */
- (void)onClearIC;
/**
 *   Delete IC Successfully
 */
- (void)onDeleteIC;
/**
 *   Modify IC Successfully
 */
- (void)onModifyIC;
/**
 Add Fingerprint Successfully
 
 @param state                AddFingerprintState
 @param fingerprintNumber    state"AddFingerprintCollectSuccess"Contains fingerprint number, other states do not have fingerprint number
 @param currentCount         The number of fingerprints currently entered (the number of -1 representations is unknown), the first time to return the number of collection is 0, the last direct return to the state of 1 and the fingerprint number state AddFingerprintCollectSuccess do not return.
 @param totalCount   The number of fingerprints required (-1 is unknown) . when the state is AddFingerprintCollectSuccess , it is not returned.
 */
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString*)fingerprintNumber currentCount:(int)currentCount totalCount:(int)totalCount ;
/**
 *   Clear Fingerprint Successfully
 */
- (void)onClearFingerprint;
/**
 *   Delete Fingerprint Successfully
 */
- (void)onDeleteFingerprint;
/**
 *   Modify Fingerprint Successfully
 */
- (void)onModifyFingerprint;
/**
 Query Locking Time Successfully
 currentTime  Current locking time
 minTime  Minimum locking time
 maxTime  maximum locking time
 */
- (void)onQueryLockingTimeWithCurrentTime:(int)currentTime minTime:(int)minTime maxTime:(int)maxTime;
/**
  Modify Locking Time Successfully
 */
- (void)onModifyLockingTime;
/**
  Get Device Info Successfully
  infoDic  Key reference enum: TTUtils.h -> DeviceInfoType
 */
- (void)onGetDeviceInfo:(NSDictionary*)infoDic;
/**
  Enter Firmware Upgrade Mode Successfully
 */
- (void)onEnterFirmwareUpgradeMode;
/**
 Get Lock Switch State Successfully
 
 @param state  reference:TTLockSwitchState
 */
- (void)onGetLockSwitchState:(TTLockSwitchState)state;
/**
 Query Screen State Successfully
 
 @param state  0-hide  1-show
 */
- (void)onQueryScreenState:(BOOL)state;

/**
 Modify Screen Show State Successfully
 */
- (void)onModifyScreenShowState;

/**
 Recover User KeyBoard Password Successfully
 */
- (void)onRecoverUserKeyBoardPassword;
/**
 *  Reading new password data Successfully
 */
-(void)onGetPasswordData_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo;
/**
 Query Door Sensor Locking Successfully
 isOn  YES is open, NO is close
 */
- (void)onQueryDoorSensorLocking:(BOOL)isOn;
/**
 Modify Door Sensor Locking Successfully
 */
- (void)onModifyDoorSensorLocking;
/**
 Get Door Sensor State Successfully
 */
- (void)onGetDoorSensorState:(TTDoorSensorState)state;

/**
 Operate Remote Unlock Swicth Successfully

 @param type reference enum:OprationType
 @param stateInfo
        key:"state" , type:BOOL , NO is close, YES is open, When the type is OprationTypeQuery, this parameter has value.
        key:"specialValue" , type:long long ,When the switch is modified, the characteristic value in the lock will change. When the type is OprationTypeModify, this parameter has value.
 */
- (void)onOperateRemoteUnlockSwicth_type:(OprationType)type stateInfo:(NSDictionary*)stateInfo;
/**
 Query Audio Switch  Successfully
 isOn  YES is open, NO is close
 */
- (void)onQueryAudioSwitch:(BOOL)isOn;
/**
 Modify Audio Switch Successfully
 */
- (void)onModifyAudioSwitch;
/**
 Query Remote Control  Successfully
 */
- (void)onQueryRemoteControl:(RemoteControlButtonValueType)buttonValue;
/**
 Set NB Server Successfully
 */
- (void)onSetNBServer;

#pragma mark --- 废弃
-(void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory __attribute__((deprecated("SDK2.6 onFoundDevice_peripheralWithInfoDic" )));
-(void)onAddAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)versionStr mac:(NSString*)mac timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo electricQuantity:(int)electricQuantity adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward Characteristic:(int)characteristic  __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onAddAdministrator_password:(NSString*)password key:(NSString*)key aesKey:(NSString*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onLock __attribute__((deprecated("SDK2.6.3")));
- (void)TTLockManagerDidUpdateState:(CBCentralManager *)central __attribute__((deprecated("SDK2.6.3")));
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString*)fingerprintNumber __attribute__((deprecated("SDK2.6.3")));
-(void)onStartBTDeviceScan __attribute__((deprecated("SDK2.7.5")));
-(void)onStopBTDeviceScan __attribute__((deprecated("SDK2.7.5")));
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime __attribute__((deprecated("SDK2.7.5")));
- (void)onLockingWithLockTime:(NSTimeInterval)lockTime __attribute__((deprecated("SDK2.7.5")));
-(void)onAddAdministrator_addAdminInfoDic:(NSDictionary*)addAdminInfoDic __attribute__((deprecated("SDK2.7.7")));
@end

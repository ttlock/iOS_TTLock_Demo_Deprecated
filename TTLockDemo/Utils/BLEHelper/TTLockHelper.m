//
//  TTLockHelper.m
//  Sciener
//
//  Created by wjjxx on 17/1/18.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "TTLockHelper.h"
#import "AppDelegate.h"
#import "OnFoundDeviceModel.h"


NSString *const KKBLEErrorCodeKey = @"errorCode";
NSString *const KKBLECommandKey = @"command";

NSString * const KKBLE_SCAN = @"ble_scan";
NSString * const KKBLE_CONNECT = @"ble_connect";
NSString * const KKBLE_DISCONNECT = @"ble_disconnect";

NSString * const KKBLE_ADD_ADMIN = @"ble_add_addmin";
NSString * const KKBLE_UNLOCK = @"ble_unlock";
NSString * const KKBLE_LOCK = @"ble_lock";

NSString * const KKBLE_SET_LOCK_TIME = @"ble_SET_lock_time";
NSString * const KKBLE_READ_TIME = @"ble_read_time";
NSString * const KKBLE_READ_CHARACTERVALUE = @"ble_read_characterValue";
NSString * const KKBLE_LOCK_VERSION = @"ble_lock_version";
NSString * const KKBLE_UNLOCK_RECORD = @"ble_unlock_record";

NSString * const KKBLE_RESET_ADMIN_KEYBORADPWD = @"ble_reset_admin_keyboardpwd";
NSString * const KKBLE_MODIFY_KEYBORADPWD = @"ble_modify_keyboardpwd";
NSString * const KKBLE_RESET_ADMIN_DELETE_KEYBOARDPWD = @"ble_admin_delete_keyboardpwd";
NSString * const KKBLE_DELETE_ONE_KEYBOARDPWD = @"ble_delete_one_keyboardpwd";
NSString * const KKBLE_RESET_KEYBOARDPWD = @"ble_reset_keyboardpwd";
NSString * const KKBLE_RESET_EKEY = @"ble_reset_ekey";
NSString * const KKBLE_RESET_LOCK = @"ble_reset_lock";
NSString * const KKBLE_RESET_TIME = @"ble_reset_time";

NSString * const KKBLE_ACTIVE_UPGRADE = @"ble_active_upgrade";
NSString * const KKBLE_READ_FIRMWARE = @"ble_read_firmware";
NSString * const KKBLE_UPGRADE = @"ble_upgrade";
NSString * const KKBLE_UPGRADE_PROGRESS = @"ble_upgrade_progress";

NSString * const KKBLE_Config_DEVICE = @"ble_config_device";
NSString * const KKBLE_DELETE_DEVICE = @"ble_delete_device";
NSString * const KKBLE_CLEAN_DEVICE = @"ble_clean_device";
NSString * const KKBLE_MODIF_DEVICE = @"ble_modify_device";
NSString * const KKBLE_QUERY_DEVICE = @"ble_query_device";
NSString * const KKBLE_BONG_RSSI = @"ble_bong_rssi";
NSString * const KKBLE_SET_BONG = @"ble_set_bong";
NSString * const KKBLE_CUSTOM_KEYBOARDPWD = @"ble_custom_keyboardpwd";
NSString * const KKBLE_GET_LOCK_TIME = @"ble_get_lock_time";
NSString * const KKBLE_GET_DEVICE_INFO = @"ble_get_device_info";
NSString * const KKBLE_GET_PWD_DATA = @"ble_get_pwd_data";

BOOL isReachDefaultConnectTimeout;

@interface TTLockHelper ()

@property (atomic,strong) NSMutableDictionary *bleBlockDict;
@property (atomic,strong) NSNumber *lockUniqueid;
@property (atomic,assign) BOOL isSendCommandByCRCError;


@end

@implementation TTLockHelper
static  TTLockHelper *instace;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc]initTTLockHelper];
     
        
    });
    return instace;
}

#pragma mark ----- 初始化中心对象  蓝牙交互
- (instancetype)initTTLockHelper{
    
    self.TTObject =  [[TTLock alloc]initWithDelegate:self];
    self.TTObject.isShowBleAlert = YES;
    [self.TTObject setupBlueTooth];
    _bleBlockDict = [NSMutableDictionary dictionary];
   // Whether or not print the log in SDK
//    [TTLock setDebug:YES];
    
    return self;
    
}
- (void)TTManagerDidUpdateState:(TTManagerState)state{
    if (state == TTManagerStatePoweredOn) {
         [_TTObject startBTDeviceScan:YES];
    }else if (state == TTManagerStatePoweredOff){
          [_TTObject stopBTDeviceScan];
    }else if (state == TTManagerStateUnsupported){
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Your device does not support ble4.0, unable to use our app." message:nil delegate:self cancelButtonTitle:LS(@"words_sure_ok") otherButtonTitles: nil];
            [alert show];
            
        });
    }
}


#pragma mark 蓝牙指令

+ (void) connectKey:(Key *)key connectBlock:(BLEConnectBlock)connectBlock{
   
    //One generation lock，ios can not get the mac
    NSString *mac;
    if ([key.lockVersion hasPrefix:@"5.1"]) {
        mac = key.lockName;
    }else{
        mac = key.lockMac.length ? key.lockMac : key.lockName;
    }
    
    if (mac.length == 0) {
        connectBlock(nil,KKBLE_CONNECT_NONE_TARGET);
        return;
    }
    
    async_main(^{

        if ([TTLockHelper shareInstance].currentKey){
      
            NSLog(@"Now there is a key that is trying to connect. It needs to be disconnected.");
            [[TTLockHelper shareInstance] cancelConnectTimeOut];
            [[TTLockHelper shareInstance] connectTimeOut];
        
            //If the lock is not around, there is no callback, so this timeout is used to solve the problem
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
                isReachDefaultConnectTimeout = NO;
                 [[TTLockHelper shareInstance] performSelector:@selector(connectTimeOut) withObject:nil afterDelay:DEFAULT_CONNECT_TIMEOUT];
                [TTLockHelper onlyOnePeripheralCanConnectAtTheSameTimeWithDeviceMAC:mac  key:key  connectBlock:connectBlock];
                
               
             
            });
            
        }else{
            
             isReachDefaultConnectTimeout = NO;
            [[TTLockHelper shareInstance] performSelector:@selector(connectTimeOut) withObject:nil afterDelay:DEFAULT_CONNECT_TIMEOUT];
            [TTLockHelper onlyOnePeripheralCanConnectAtTheSameTimeWithDeviceMAC:mac  key:key  connectBlock:connectBlock];
          
           
        }
        

    });
    
    

}

+ (void)onlyOnePeripheralCanConnectAtTheSameTimeWithDeviceMAC:(NSString *)mac  key:(Key *)key connectBlock:(BLEConnectBlock)connectBlock{
    
    NSLog(@"onlyOnePeripheralCanConnectAtTheSameTimeWithDeviceMAC %@",key.lockName);
    if ([TTLockHelper shareInstance].currentKey) {
        NSLog(@"Now there is a key that is trying to connect. It needs to be disconnected.");
        return;
    }
    if (connectBlock) {
        [[TTLockHelper shareInstance].bleBlockDict setObject:connectBlock forKey:KKBLE_CONNECT];
    }
    TTLockHelperClass.currentKey = key;
    [TTObjectTTLockHelper connectPeripheralWithLockMac:mac];

}

- (void)connectTimeOut{
    
    NSLog(@"connectTimeOut");
     isReachDefaultConnectTimeout = YES;
    [TTLockHelper disconnectKey:TTLockHelperClass.currentKey disConnectBlock:nil];
    TTLockHelperClass.currentKey = nil ;
    [TTLockHelper removeBlock:nil untilExecute:YES];
}
- (void)cancelConnectTimeOut{
    
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:[TTLockHelper shareInstance]
                                              selector:@selector(connectTimeOut)
                                                object:nil];
}
+ (void)disconnectKey:(Key *)key disConnectBlock:(BLEDisconnectBlock)disConnectBlock{
    if (key) {
          ////One generation lock，ios can not get the mac
         NSString *mac;
        if ([key.lockVersion hasPrefix:@"5.1"]) {
            mac = key.lockName;
        }else{
            mac = key.lockMac.length ? key.lockMac : key.lockName;
        }
        NSLog(@"disConnect %@",key.lockName);
        [TTLockHelper disConnectDeviceMAC:mac disConnectBlock:disConnectBlock];
    }
}

+ (void)disConnectDeviceMAC:(NSString *)mac  disConnectBlock:(BLEDisconnectBlock)disConnectBlock{
    if (disConnectBlock) {
        [[TTLockHelper shareInstance].bleBlockDict setObject:disConnectBlock forKey:KKBLE_DISCONNECT];
    }
      [TTObjectTTLockHelper cancelConnectPeripheralWithLockMac:mac];
}

+ (void)unlock:(Key *)key unlockBlock:(BLEBlock)unlockBlock{

    if (!key) {
         return;
    }
  
   if (unlockBlock) {
       
      [[TTLockHelper shareInstance].bleBlockDict setObject:unlockBlock forKey:KKBLE_UNLOCK];
   }
    
     [TTLockHelper shareInstance].lockUniqueid = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];
  
    if (key.isAdmin) {
        [[TTLockHelper shareInstance].TTObject unlockByAdministrator_adminPS:key.adminPwd
                                                                          lockKey:key.lockKey
                                                                           aesKey:key.aesKeyStr
                                                                          version:key.lockVersion
                                                                       unlockFlag:key.lockFlagPos
                                                                         uniqueid:[TTLockHelper shareInstance].lockUniqueid
                                                                timezoneRawOffset:key.timezoneRawOffset];
    }else{
        [[TTLockHelper shareInstance].TTObject unlockByUser_lockKey:key.lockKey
                                                                  aesKey:key.aesKeyStr
                                                               startDate:[NSDate dateWithTimeIntervalSince1970:key.startDate]
                                                                 endDate:[NSDate dateWithTimeIntervalSince1970:key.endDate]
                                                                 version:key.lockVersion
                                                              unlockFlag:key.lockFlagPos
                                                                uniqueid:[TTLockHelper shareInstance].lockUniqueid
                                                       timezoneRawOffset:key.timezoneRawOffset];
    }

}
+ (void)lock:(Key *)key lockBlock:(BLEBlock)lockBlock{
    
    if (!key) {
        return;
    }

    if (lockBlock) {
        [[TTLockHelper shareInstance].bleBlockDict setObject:lockBlock forKey:KKBLE_LOCK];
    }
    [TTLockHelper shareInstance].lockUniqueid = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]];

    if (key.isAdmin) {
          [TTObjectTTLockHelper locking_lockKey:key.lockKey
                                       aesKey:key.aesKeyStr
                                   unlockFlag:key.lockFlagPos
                                     uniqueid:[TTLockHelper shareInstance].lockUniqueid
                                      isAdmin:YES
                                    startDate:nil
                                      endDate:nil
                            timezoneRawOffset:key.timezoneRawOffset];
    }else{
      [TTObjectTTLockHelper locking_lockKey:key.lockKey
                                   aesKey:key.aesKeyStr
                               unlockFlag:key.lockFlagPos
                                 uniqueid:[TTLockHelper shareInstance].lockUniqueid
                                  isAdmin:NO
                                startDate:[NSDate dateWithTimeIntervalSince1970:key.startDate]
                                  endDate:[NSDate dateWithTimeIntervalSince1970:key.endDate]
                        timezoneRawOffset:key.timezoneRawOffset];
    }
}

+ (void)setLockTime:(Key*)key complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_SET_LOCK_TIME];
    
    [[TTLockHelper shareInstance].TTObject setLockTime_lockKey:key.lockKey aesKey:key.aesKeyStr version:key.lockVersion unlockFlag:key.lockFlagPos referenceTime:[NSDate date] timezoneRawOffset:key.timezoneRawOffset];
}

+ (void)resetEkey:(Key *)key complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_RESET_EKEY];
    
    [[TTLockHelper shareInstance].TTObject resetEkey_adminPS:key.adminPwd
                                            lockKey:key.lockKey
                                             aesKey:key.aesKeyStr
                                            version:key.lockVersion
                                         unlockFlag:key.lockFlagPos + 1];
}

+ (void)resetKeyboardPassword:(Key *)key complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_RESET_KEYBOARDPWD];
    
    [[TTLockHelper shareInstance].TTObject resetKeyboardPassword_adminPS:key.adminPwd
                                                        lockKey:key.lockKey
                                                         aesKey:key.aesKeyStr
                                                        version:key.lockVersion
                                                     unlockFlag:key.lockFlagPos];
  
}
+ (void)resetLock:(Key *)key  complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_RESET_LOCK];
    [[TTLockHelper shareInstance].TTObject resetLock_adminPS:key.adminPwd
                                            lockKey:key.lockKey
                                             aesKey:key.aesKeyStr
                                            version:key.lockVersion
                                         unlockFlag:key.lockFlagPos];
}

+ (void)pullUnlockRecord:(Key *)key complition:(BLEBlock)complition{
    if (key == nil) return;
    if (complition) {
       
        [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_UNLOCK_RECORD];
    }
  
    [[TTLockHelper shareInstance].TTObject getOperateLog_aesKey:key.aesKeyStr
                                               version:key.lockVersion
                                            unlockFlag:key.lockFlagPos
                                     timezoneRawOffset:key.timezoneRawOffset];
}
+ (void)adminDeleteOneKeyboardPassword:(NSString *)deletePs key:(Key *)key  complition:(BLEBlock)complition{
    
    if (complition) {
      [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_DELETE_ONE_KEYBOARDPWD];
    }

    [[TTLockHelper shareInstance].TTObject deleteOneKeyboardPassword:deletePs
                                                    adminPS:key.adminPwd
                                                    lockKey:key.lockKey
                                                     aesKey:key.aesKeyStr
                                               passwordType:KeyboardPsTypePermanent
                                                    version:key.lockVersion
                                                 unlockFlag:key.lockFlagPos];
}
+ (void)customKeyboardPwd:(NSString *)newKeyboardPwd
                startDate:(NSDate*)startDate
                  endDate:(NSDate*)endDate
                      key:(Key *)key
               complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_CUSTOM_KEYBOARDPWD];
    
    [[TTLockHelper shareInstance].TTObject addKeyboardPassword_password:newKeyboardPwd
                                                     startDate:startDate
                                                       endDate:endDate
                                                       adminPS:key.adminPwd
                                                       lockKey:key.lockKey
                                                        aesKey:key.aesKeyStr
                                                    unlockFlag:key.lockFlagPos
                                             timezoneRawOffset:key.timezoneRawOffset];
}

+ (void)modifyKeyboardPassword:(NSString *)pwd
                      toNewPwd:(NSString *)newPwd
                     startDate:(NSDate*)startDate
                       endDate:(NSDate*)endDate
                           key:(Key *)key
                    complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_MODIFY_KEYBORADPWD];

    
    [[TTLockHelper shareInstance].TTObject modifyKeyboardPassword_newPassword:newPwd
                                                         oldPassword:pwd
                                                           startDate:startDate
                                                             endDate:endDate
                                                             adminPS:key.adminPwd
                                                             lockKey:key.lockKey
                                                              aesKey:key.aesKeyStr
                                                          unlockFlag:key.lockFlagPos
                                                   timezoneRawOffset:key.timezoneRawOffset];
    
}

+ (void)setAdminKeyboardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_RESET_ADMIN_KEYBORADPWD];

    
    [TTObjectTTLockHelper setAdminKeyBoardPassword:keyboardPs
                                                   adminPS:key.adminPwd
                                                   lockKey:key.lockKey
                                                    aesKey:key.aesKeyStr
                                                   version:key.lockVersion
                                                unlockFlag:key.lockFlagPos];
}

+ (void)setAdminDeleteKeyBoardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition{
 
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_RESET_ADMIN_DELETE_KEYBOARDPWD];
    
    [TTObjectTTLockHelper setAdminDeleteKeyBoardPassword:keyboardPs
                                                         adminPS:key.adminPwd
                                                         lockKey:key.lockKey
                                                          aesKey:key.aesKeyStr
                                                         version:key.lockVersion
                                                      unlockFlag:key.lockFlagPos];
}


+  (void)configLockPeripheralDevType:(ConfigDevType)devType
                           startDate:(NSDate*)startDate
                             endDate:(NSDate*)endDate
                          optionType:(OprationType)optionType
                           devNumber:(NSString *)devNumber
                         lockingTime:(int)lockingTime
                              isShow:(BOOL)isShow
                             key:(Key *)key
                          complition:(BLEBlock)complition{
    
    if (optionType == OprationTypeAdd) {
        [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_Config_DEVICE];
    }else if (optionType == OprationTypeClear){
        [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_CLEAN_DEVICE];
    }else if (optionType == OprationTypeDelete){
        [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_DELETE_DEVICE];
    }else if (optionType == OprationTypeModify){
        [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_MODIF_DEVICE];
    }else if (optionType == OprationTypeQuery){
         [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_QUERY_DEVICE];
    }
    
    if (devType == ConfigDevIC) {
        [TTObjectTTLockHelper operate_type:optionType
                                           adminPS:key.adminPwd
                                           lockKey:key.lockKey
                                            aesKey:key.aesKeyStr
                                          ICNumber:devNumber
                                         startDate:startDate
                                           endDate:endDate
                                        unlockFlag:key.lockFlagPos
                                 timezoneRawOffset:key.timezoneRawOffset];
        
    }else if (devType == ConfigDevFingerprint){
        [TTObjectTTLockHelper operateFingerprint_type:optionType
                                                      adminPS:key.adminPwd
                                                      lockKey:key.lockKey
                                                       aesKey:key.aesKeyStr
                                            FingerprintNumber:devNumber
                                                    startDate:startDate
                                                      endDate:endDate
                                                   unlockFlag:key.lockFlagPos
                                            timezoneRawOffset:key.timezoneRawOffset];
        
    }else if (devType == ConfigDevBong){
      
        [TTObjectTTLockHelper setLockWristbandKey:devNumber
                                         keyboardPassword:key.noKeyPwd
                                                  adminPS:key.adminPwd
                                                  lockKey:key.lockKey
                                                   aesKey:key.aesKeyStr
                                               unlockFlag:key.lockFlagPos];
    }else if (devType == ConfigDevLockingTime){
        [TTObjectTTLockHelper setLockingTime_type:optionType
                                           time:lockingTime
                                        adminPS:key.adminPwd
                                        lockKey:key.lockKey
                                         aesKey:key.aesKeyStr
                                     unlockFlag:key.lockFlagPos];
    }else if (devType == ConfigDevScreenisShow){
          [TTObjectTTLockHelper operateScreen_type:optionType
                                          isShow:isShow
                                         adminPS:key.adminPwd
                                         lockKey:key.lockKey
                                          aesKey:key.aesKeyStr
                                      unlockFlag:key.lockFlagPos];
    }
}
+ (void)getPwdListWithKey:(Key *)key
               complition:(BLEBlock)complition{
     [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_QUERY_DEVICE];
    [TTObjectTTLockHelper getKeyboardPasswordList_adminPS:key.adminPwd
                                                lockKey:key.lockKey
                                                 aesKey:key.aesKeyStr
                                             unlockFlag:key.lockFlagPos
                                      timezoneRawOffset:key.timezoneRawOffset];
    
}
+ (void)getLockTimeWithKey:(Key *)key
                complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_GET_LOCK_TIME];
    [TTObjectTTLockHelper getLockTime_aesKey:key.aesKeyStr
                                   version:key.lockVersion
                                unlockFlag:key.lockFlagPos
                         timezoneRawOffset:key.timezoneRawOffset];
}
+ (void)getDeviceInfoWithKey:(Key *)key
                complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_GET_DEVICE_INFO];
    [TTObjectTTLockHelper getDeviceInfo_lockKey:key.lockKey
                                       aesKey:key.aesKeyStr];
}
+ (void)getPasswordDataWithKey:(Key *)key
                    complition:(BLEBlock)complition{
    
    [[TTLockHelper shareInstance].bleBlockDict setObject:complition forKey:KKBLE_GET_PWD_DATA];
    [TTObjectTTLockHelper getPasswordData_lockKey:key.lockKey
                                         aesKey:key.aesKeyStr
                                     unlockFlag:key.lockFlagPos
                              timezoneRawOffset:key.timezoneRawOffset];
}

#pragma mark TTSDKDelegate
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic{
    
//      OnFoundDeviceModel *deviceModel = [[OnFoundDeviceModel alloc] initOnFoundDeviceModelWithDic:infoDic];
//
//      if (deviceModel.isAllowUnlock == NO) return;
//        __block  Key *dbKey = nil;
//        sync_main(^{
//            if (deviceModel.mac.length){
//                 dbKey =  [[DBHelper sharedInstance] fetchKeyWithLockMac:deviceModel.mac];
//            }
//            else{
//                dbKey =  [[DBHelper sharedInstance] fetchKeyWithDoorName:deviceModel.lockName];
//            }
//        });
//
//    if (dbKey && deviceModel.rssi.intValue >= RSSI_SETTING_1m && deviceModel.rssi.intValue != 127){
//
//        [TTLockHelper onlyOnePeripheralCanConnectAtTheSameTimeWithDeviceMAC:deviceModel.mac.length ? deviceModel.mac : deviceModel.lockName key:dbKey connectBlock:nil];
//
//    }
    
}

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{

  
    [[TTLockHelper shareInstance].bleBlockDict removeObjectForKey:KKBLE_SCAN];
    
     [_TTObject stopBTDeviceScan];
    
    _isSendCommandByCRCError = YES;
    
    self.TTObject.uid = [SettingHelper getOpenID];
    
    BLEConnectBlock connectBlock = _bleBlockDict[KKBLE_CONNECT];
    if (connectBlock)
    {
        async_main(^{
            [self cancelConnectTimeOut];
            connectBlock(peripheral,KKBLE_CONNECT_SUCCESS);
            [_bleBlockDict removeObjectForKey:KKBLE_CONNECT];
        });
    }
    else{

        [TTLockHelper unlock:_currentKey unlockBlock:^(id info, BOOL succeed) {
            
        }];
    }
    
    NSLog(@"-----------CONNECT SUCCESS lockName %@ --------------",peripheral.name);
}


-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime electricQuantity:(int)electricQuantity {
    
    BLEBlock unlockBlock = _bleBlockDict[KKBLE_UNLOCK];
    if (unlockBlock) {
        async_main(^{
            [_bleBlockDict removeObjectForKey:KKBLE_UNLOCK];
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"lockTime"] = @(lockTime);
            info[@"electricQuantity"] = @(electricQuantity);
            unlockBlock(info,YES);
        
        });
    }
    
    [SSToastHelper showToastWithStatus:@"Unlock success"];
}

- (void)onLockingWithLockTime:(NSTimeInterval)lockTime electricQuantity:(int)electricQuantity{
    
    BLEBlock lockBlock = _bleBlockDict[KKBLE_LOCK];
    if (lockBlock) {
        async_main(^{
             [_bleBlockDict removeObjectForKey:KKBLE_LOCK];
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"lockTime"] = @(lockTime);
            info[@"electricQuantity"] = @(electricQuantity);
            lockBlock(info,YES);
           
        });
    }
    
   [SSToastHelper showToastWithStatus:@"Lock success"];
  
}
- (void)onSetLockTime{
       [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];

    BLEBlock setLockTimeBlock = _bleBlockDict[KKBLE_SET_LOCK_TIME];
    if (setLockTimeBlock) {
        async_main(^{
            setLockTimeBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_SET_LOCK_TIME];
        });
    }
}
-(void)onResetEkey{

    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    sync_main(^{
        _currentKey.lockFlagPos = _currentKey.lockFlagPos + 1;
        [[DBHelper sharedInstance]update];
    });
    

    BLEBlock resetEkeyBlock = _bleBlockDict[KKBLE_RESET_EKEY];
    if (resetEkeyBlock) {
        async_main(^{
            resetEkeyBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_RESET_EKEY];
        });
    }
    
}
- (void)onSetAdminKeyboardPassword{
    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setAdminKbPwBlock = _bleBlockDict[KKBLE_RESET_ADMIN_KEYBORADPWD];
    if (setAdminKbPwBlock){
        async_main(^{
            setAdminKbPwBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_RESET_ADMIN_KEYBORADPWD];
        });
    }
}
- (void)onSetAdminDeleteKeyboardPassword{
    
    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock resetAdminDeleteKbPwBlock = _bleBlockDict[KKBLE_RESET_ADMIN_DELETE_KEYBOARDPWD];
    if (resetAdminDeleteKbPwBlock){
        async_main(^{
            resetAdminDeleteKbPwBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_RESET_ADMIN_DELETE_KEYBOARDPWD];
        });
     }
    
}


-(void)onResetKeyboardPassword_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo{

    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    sync_main(^{
        _currentKey.timestamp = timestamp;
        _currentKey.pwdInfo = pwdInfo;
        [[DBHelper sharedInstance]update];
    });
    BLEBlock resetPswBlock = _bleBlockDict[KKBLE_RESET_KEYBOARDPWD];
    if (resetPswBlock){
        async_main(^{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"timestamp"] = timestamp;
            info[@"pwdInfo"] = pwdInfo;
            resetPswBlock(pwdInfo,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_RESET_KEYBOARDPWD];
        });
    }
    [NetworkHelper resetKeyboardPwd:pwdInfo lockId:self.currentKey.lockId timestamp:timestamp completion:^(id info, NSError *error) {
        if (!error)  [SSToastHelper showToastWithStatus:@"alter_Succeed"];
        else    [SSToastHelper showToastWithStatus:@"alter_Failed"];
    }];
}
- (void)OnDeleteUserKeyBoardPassword{
    
    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    
    BLEBlock deleteOneKbPwBlock = _bleBlockDict[KKBLE_DELETE_ONE_KEYBOARDPWD];
    if (deleteOneKbPwBlock){
        async_main(^{
            deleteOneKbPwBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_DELETE_ONE_KEYBOARDPWD];
        });
    }
};

- (void)onResetLock{
   
    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock resetLockBlock = _bleBlockDict[KKBLE_RESET_LOCK];
    if (resetLockBlock){
        async_main(^{
            resetLockBlock(self.currentKey.lockMac,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_RESET_LOCK];
        });
    }
}

- (void)onClearIC{

    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_CLEAN_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_CLEAN_DEVICE];
        });
    }
    
}
- (void)onDeleteIC{

     [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_DELETE_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_DELETE_DEVICE];
        });
    }
   
}
- (void)onModifyIC{

       [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_MODIF_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_MODIF_DEVICE];
        });
    }
 

}
- (void)onClearFingerprint{

      [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_CLEAN_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_CLEAN_DEVICE];
        });
    }
  

}
- (void)onDeleteFingerprint{

       [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_DELETE_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_DELETE_DEVICE];
        });
    }
 
  
}
- (void)onModifyFingerprint{
    

     [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_MODIF_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_MODIF_DEVICE];
        });
    }
   
}
- (void)onSetLockWristbandKey{
    
       [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_Config_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_Config_DEVICE];
        });
    }

 

}

- (void)onAddUserKeyBoardPassword{
   

    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
   
    BLEBlock customPwdBlock = _bleBlockDict[KKBLE_CUSTOM_KEYBOARDPWD];
    if (customPwdBlock){
        async_main(^{
            customPwdBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_CUSTOM_KEYBOARDPWD];
        });
    }

}
- (void)onModifyUserKeyBoardPassword{
    
     [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock updatePwBlock = _bleBlockDict[KKBLE_MODIFY_KEYBORADPWD];
    if (updatePwBlock){
        async_main(^{
            updatePwBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_MODIFY_KEYBORADPWD];
        });
    }

}

- (void)onQueryScreenState:(BOOL)state{

    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_QUERY_DEVICE];
    if (setupDevBlock){
        async_main(^{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"state"] = [NSString stringWithFormat:@"%d",state];
            setupDevBlock(info,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_QUERY_DEVICE];
        });
    }
}

- (void)onModifyScreenShowState{
    
    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_MODIF_DEVICE];
    if (setupDevBlock){
        async_main(^{
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_MODIF_DEVICE];
        });
    }
}
- (void)onQueryLockingTimeWithCurrentTime:(int)currentTime minTime:(int)minTime maxTime:(int)maxTime{

    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_QUERY_DEVICE];
    if (setupDevBlock){
        async_main(^{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"currentTime"] = @(currentTime);
            info[@"minTime"] = @(minTime);
            info[@"maxTime"] = @(maxTime);
            setupDevBlock(info,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_QUERY_DEVICE];
        });
    }
    
}

- (void)onModifyLockingTime{

    [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock setupDevBlock = _bleBlockDict[KKBLE_MODIF_DEVICE];
    if (setupDevBlock){
        async_main(^{
            
            setupDevBlock(nil,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_MODIF_DEVICE];
        });
    }
}

- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr{

     [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
    BLEBlock recordBlock = _bleBlockDict[KKBLE_UNLOCK_RECORD];
    if (recordBlock){
        async_main(^{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"LockOpenRecordStr"] = LockOpenRecordStr;
            recordBlock(info,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_UNLOCK_RECORD];
        });
    }
}
- (void)onGetLockTime:(NSTimeInterval)lockTime{
    
     [SSToastHelper showToastWithStatus:[NSString stringWithFormat:@"%f",lockTime]];
    
     BLEBlock getBlock = _bleBlockDict[KKBLE_GET_LOCK_TIME];
    if (getBlock){
        async_main(^{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            info[@"lockTime"] = @(lockTime);
            getBlock(info,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_GET_LOCK_TIME];
        });
    }
}
- (void)onGetDeviceInfo:(NSDictionary*)infoDic{
    
    BLEBlock getBlock = _bleBlockDict[KKBLE_GET_DEVICE_INFO];
    if (getBlock){
        async_main(^{
            getBlock(infoDic,YES);
            [_bleBlockDict removeObjectForKey:KKBLE_GET_DEVICE_INFO];
        });
    }
}
- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    
    [SSToastHelper showToastWithStatus:errorMsg];
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);

    //有错误就回调回去
    async_main(^{
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[KKBLEErrorCodeKey] = @(error);
        info[KKBLECommandKey] = @(command);
        [TTLockHelper removeBlock:info untilExecute:YES];
    });
    
}
- (void)onBTDisconnect_peripheral:(CBPeripheral *)periphera{
    async_main(^{
        
         NSLog(@"%@ onBTDisconnect_peripheral",NSStringFromClass([self class]));

        self.currentKey = nil;
        
        [self cancelConnectTimeOut];
        
        [TTLockHelper removeBlock:nil untilExecute:YES];
        
        [_TTObject startBTDeviceScan:YES];
      
    });
}

+ (void)removeBlock:(id)info untilExecute:(BOOL)execute{

    NSMutableDictionary *bleBlockDict = [[TTLockHelper shareInstance].bleBlockDict copy];
    [[TTLockHelper shareInstance].bleBlockDict removeAllObjects];
    
    [bleBlockDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:KKBLE_CONNECT])
        {
            BLEConnectBlock connectBlock = bleBlockDict[key];
           
            if (isReachDefaultConnectTimeout == YES) {
                if (connectBlock && execute)connectBlock(info,KKBLE_CONNECT_TIMEOUT);
            }else{
        
                if (connectBlock && execute)connectBlock(info,KKBLE_CONNECTED_INSTANTLY_DISCONNECT);
            }
        }else if ([key isEqualToString:KKBLE_SCAN])
        {
            
        }else if ([key isEqualToString:KKBLE_DISCONNECT])
        {
            BLEDisconnectBlock disconnectBlock = bleBlockDict[key];
            if (disconnectBlock && execute)disconnectBlock(info);
            
        }else if ([key isEqualToString:KKBLE_UPGRADE_PROGRESS])
        {
            
        }else
        {
            BLEBlock bleBlock = bleBlockDict[key];
            if (bleBlock && execute) bleBlock(info,NO);
        }
    }];
}


@end

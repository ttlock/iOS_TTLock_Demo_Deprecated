//
//  AppDelegate.m
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import "AppDelegate.h"
#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Define.h"
#import "RequestService.h"
#import "ProgressHUD.h"
#import "SVProgressHUD.h"
#import "XYCUtils.h"
#import "KeyDetailViewController.h"
#import "OnFoundDeviceModel.h"

@interface AppDelegate ()
{
    Tab0ViewController * root;

}
@end

BOOL isInitPsPool = FALSE;//初始化900个密码
BOOL calibrationPress;
NSString *v3AllowMac = nil; //3代锁是否要连接
NSString *parkAllowMac=nil; //车位锁是否要连接
int changeValidPwdNum = -1;
BOOL isInvalidFlagUpdated;
NSString *deleteOnePwd;
BOOL isRetLock; //是否恢复出厂设置
BOOL isGetOperator; //是否获取操作记录
BOOL isGetLockTime;  //是否获取锁时间
BOOL isGetCharacteristic;  //是否获取特征值
NSString *wristbandKey;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
    _TTObject = [[TTLockLock alloc]initWithDelegate:self];
    [_TTObject setupBlueTooth];

    //是否打印日志
    [TTLockLock setDebug:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    root = [[Tab0ViewController alloc]initWithNibName:@"Tab0ViewController" bundle:nil];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_TTObject stopBTDeviceScan];
   
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
     [_TTObject startBTDeviceScan];
}

#pragma mark ------ TTSDKDelegate
- (void)TTLockManagerDidUpdateState:(CBCentralManager *)central{
   
    if (central.state == CBCentralManagerStatePoweredOn) {
        
        [_TTObject startBTDeviceScan];
        
    }else if (central.state == CBCentralManagerStatePoweredOff){
        [_TTObject stopBTDeviceScan];
    }
    else if(central.state == CBCentralManagerStateUnsupported){
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"非常抱歉，您使用的设备不支持低功耗4.0蓝牙，将无法正常使用我们的程序。(Your device does not support ble4.0, unable to use our app.)" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
            [alert show];
            
        });
        //不支持ble蓝牙
    }

}
-(void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    
    if (error == TTErrorNoPermisston || error == TTErrorIsInvalidFlag ||  error == TTErrorIsWrongPS || error ==  TTErrorNoAdmin || error == TTErrorIsWrongDynamicPS||error == TTErrorHadReseted) {
        
        if (isRetLock == YES) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"onResetLockNot" object:self.currentKey.lockMac];
            isRetLock= NO;
   
        }

    }

    isRetLock = NO; //是否恢复出厂设置
    isGetOperator = NO; //是否获取操作记录
    isGetLockTime = NO;  //是否获取锁时间
    isGetCharacteristic= NO;  //是否获取特征值
    isInvalidFlagUpdated= NO;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showErrorWithStatus:errorMsg];
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
}
//蓝牙搜索，连接相关回调
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic{
    
    OnFoundDeviceModel *deviceModel = [[OnFoundDeviceModel alloc] initOnFoundDeviceModelWithDic:infoDic];
    __block  Key *dbKey = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (deviceModel.mac && deviceModel.mac.length>0) {
            dbKey = [[DBHelper sharedInstance] fetchKeyWithLockMac:deviceModel.mac];
        }
        else{
            dbKey =  [[DBHelper sharedInstance] fetchKeyWithDoorName:deviceModel.lockName];
        }
    });
    
    //三代锁 不判断 会一直开锁
    if (deviceModel.isAllowUnlock == 0 && v3AllowMac == nil && [dbKey.lockVersion hasPrefix:@"5.3"]) {
        return;
    }
    //如果有指定的三代锁 所以不符合的不连
    if (v3AllowMac&& ![dbKey.lockMac isEqualToString:v3AllowMac]) {
        return;
    }
    //车位锁也是一直会连接 影响其他开锁
    if ([dbKey.lockVersion hasPrefix:@"10"]&&parkAllowMac ==nil) {
        return;
    }
    //如果有指定的车位锁 所以不符合的不连
    if (parkAllowMac&& ![dbKey.lockMac isEqualToString:parkAllowMac]) {
        return;
    }
    //查找本地有没有这把锁的钥匙 如果有就进行连接
    if (dbKey!=nil&& deviceModel.rssi.intValue >= RSSI_SETTING_1m &&deviceModel.rssi.intValue != 127) {
        
        NSLog(@"搜索到进行连接时的RSSI %@",deviceModel.rssi);
        NSLog(@"有对应的 lockname:%@,lockmac:%@",dbKey.lockName,dbKey.lockMac);
        if (dbKey.peripheralUUIDStr.length == 0) {
            dbKey.peripheralUUIDStr = deviceModel.peripheral.identifier.UUIDString;
            [[DBHelper sharedInstance]update];
        }
        self.currentKey = dbKey;
        [_TTObject connect:deviceModel.peripheral];
    }

}

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{
    
    //扫描先停止 防止数据错乱
    [_TTObject stopBTDeviceScan];
    
    //连接上之后 把3代锁自定义的开门标识去掉
    v3AllowMac=nil;
    parkAllowMac = nil;
    
    _currentPeripheral= peripheral;
    
    self.TTObject.uid = [SettingHelper getOpenID];

     if (calibrationPress == YES){
         [self.TTObject setLockTime_lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos referenceTime:[NSDate date] timezoneRawOffset:self.currentKey.timezoneRawOffset];
         
     
     }else if (isGetOperator){
        
         
         [self.TTObject getOperateLog_aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos timezoneRawOffset:self.currentKey.timezoneRawOffset];

     }else if (isGetLockTime){

         [self.TTObject getLockTime_aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos timezoneRawOffset:self.currentKey.timezoneRawOffset];
    }
     else if ([self.currentKey.userType isEqualToString:@"110301"]) {
         //蓝牙的指令只能是一条一条执行
         if (self.currentKey.noKeyPwdTmp && self.currentKey.noKeyPwdTmp.length > 0) {
             //设置管理员键盘密码
             [self.TTObject setAdminKeyBoardPassword:self.currentKey.noKeyPwd adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos];
             
         }else if (self.currentKey.deletePwdTmp && self.currentKey.deletePwdTmp.length > 0) {
            //设置管理员删除密码
            [self.TTObject setAdminDeleteKeyBoardPassword:self.currentKey.deletePwd adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos];
        }else if (isInitPsPool){
            [self.TTObject resetKeyboardPassword_adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos];
           
        } else if (isInvalidFlagUpdated == YES){
            [self.TTObject resetEkey_adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos+1];
          
        }else if (isRetLock){
            [self.TTObject resetLock_adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos];
        }else if (isGetCharacteristic){
            [self.TTObject getDeviceCharacteristic_lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr];
        }else if (wristbandKey){

            [self.TTObject setLockWristbandKey:wristbandKey keyboardPassword:_currentKey.noKeyPwd adminPS:_currentKey.adminPwd lockKey:_currentKey.lockKey aesKey:_currentKey.aesKeyStr unlockFlag:self.currentKey.lockFlagPos];
        }
        else {
          //管理员开门
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            
            NSNumber *uniqueid = [NSNumber numberWithInt:time];
            [self.TTObject unlockByAdministrator_adminPS:self.currentKey.adminPwd lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos uniqueid:uniqueid];
            
        
        }
    }else{
        //普通用户开门
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        
        NSNumber *uniqueid = [NSNumber numberWithInt:time];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.currentKey.startDate/1000];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.currentKey.endDate/1000];
        
        [self.TTObject unlockByUser_lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr startDate:startDate endDate:endDate version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos uniqueid:uniqueid timezoneRawOffset:self.currentKey.timezoneRawOffset];
        
        
    }
}

//开锁成功
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"开门成功"];
    [self.TTObject setLockTime_lockKey:self.currentKey.lockKey aesKey:self.currentKey.aesKeyStr version:self.currentKey.lockVersion unlockFlag:self.currentKey.lockFlagPos referenceTime:[NSDate date] timezoneRawOffset:self.currentKey.timezoneRawOffset];
}
//上锁成功
- (void)onLock{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"上锁成功"];
    
}
-(void)onResetEkey{
    //更新锁的标志位
     isInvalidFlagUpdated = NO;
    _currentKey.lockFlagPos = _currentKey.lockFlagPos + 1;
    [[DBHelper sharedInstance]update];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"重置电子钥匙成功"];
    
    [NetworkHelper resetKey:_currentKey.lockFlagPos lockId:_currentKey.lockId completion:^(id info, NSError *error) {
        if (!error)  [SVProgressHUD showSuccessWithStatus:@"重置电子钥匙上传成功"];
        else    [SVProgressHUD showErrorWithStatus:@"重置电子钥匙上传失败"];
    }];

}
- (void)onSetAdminKeyboardPassword{
  
    _currentKey.noKeyPwd = _currentKey.noKeyPwd;
//    _currentKey.adminKeyboardPsTmp = nil;
    [[DBHelper sharedInstance]update];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"设置管理员开门密码成功"];
    [NetworkHelper changeAdminKeyboardPwd:_currentKey.noKeyPwd lockId:_currentKey.lockId completion:^(id info, NSError *error) {
        if (!error)  [SVProgressHUD showSuccessWithStatus:@"设置管理员开门密码上传成功"];
        else    [SVProgressHUD showErrorWithStatus:@"设置管理员开门密码上传失败"];

    }];
}
- (void)onSetAdminDeleteKeyboardPassword{
    self.currentKey.deletePwd = self.currentKey.deletePwd;
    self.currentKey.deletePwd = nil;
    [[DBHelper sharedInstance]update];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"设置管理员删除密码成功"];
    [NetworkHelper changeDeletePwd:_currentKey.deletePwdTmp lockId:_currentKey.lockId completion:^(id info, NSError *error) {
        if (!error)  [SVProgressHUD showSuccessWithStatus:@"设置管理员删除密上传码成功"];
        else    [SVProgressHUD showSuccessWithStatus:@"设置管理员删除密码上传失败"];
    }];
    

    
}
-(void)onResetKeyboardPassword_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo{

    isInitPsPool = NO;
//    _currentKey.timestamp = timestamp;
//    _currentKey.pwdInfo = pwdInfo;
    [[DBHelper sharedInstance]update];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"重置键盘密码成功"];
    [NetworkHelper resetKeyboardPwd:pwdInfo lockId:self.currentKey.lockId timestamp:timestamp completion:^(id info, NSError *error) {
        if (!error)  [SVProgressHUD showSuccessWithStatus:@"重置键盘密码上传成功"];
        else    [SVProgressHUD showErrorWithStatus:@"重置键盘密码上传失败"];
    }];
    
}
- (void)onResetLock{
    //成功后发送通知
    isRetLock = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onResetLockNot" object:self.currentKey.lockMac];

}

- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr{
    if (![_currentKey.lockVersion hasPrefix:@"10.1"]) {
        isGetOperator = NO;
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        if (LockOpenRecordStr.length > 0) {
            [SVProgressHUD showSuccessWithStatus:LockOpenRecordStr];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"读取成功 没有记录"];
        }
    }
}
- (void)onGetLockTime:(NSTimeInterval)lockTime{
    isGetLockTime = NO;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@%f",@"获取锁成功",lockTime]];

}

- (void)onLowPower{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"电压较低，请及时换电池"];
}

- (void)onSetLockTime
{
    if (calibrationPress == YES) {
        calibrationPress = NO;
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"校验时间成功"];
    }
    NSLog(@"校验时间成功");
}
-(void)onGetProtocolVersion:(NSString*)versionStr{
    NSLog(@"versionStr %@",versionStr);
}

-(void)onBTDisconnect_peripheral:(CBPeripheral *)periphera
{
   [_TTObject startBTDeviceScan];
     NSLog(@"断开蓝牙 disconnect");
}

- (void)onGetDeviceCharacteristic:(int)characteristic{
    isGetCharacteristic = NO;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%ld",(long)characteristic]];
}
- (void)onSetWristbandKey{
    wristbandKey = nil;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"onSetWristbandKey"];
}
//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
@end

//
//  TTSDKDelegate.h
//  TTLockDemo
//
//  Created by 王娟娟 on 2017/10/25.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**回调 TTSDK代理*/
@protocol TTSDKDelegate <NSObject>

@optional

/**
 *  蓝牙的状态改变时 The central manager whose state has changed.
 */
- (void)TTManagerDidUpdateState:(TTManagerState)state;
/**
 *  开始扫描
 */
-(void)onStartBTDeviceScan;
/**
 *  断开扫描
 */
-(void)onStopBTDeviceScan;

/**
 *  错误回调 
 *
 *  @param error     错误码
 *  @param command   错误的指令值
 *  @param errorMsg  错误信息
 */
-(void)TTError:(TTError)error command:(int)command errorMsg:(NSString*)errorMsg;

/**
 *  蓝牙搜索到设备的回调
 *  infoDic 返回参数为字典  下面对应键及其值的意义
 *  peripheral     搜索到的蓝牙对象
 *  rssi           信号值
 *  lockName       锁名
 *  mac            锁的mac地址
 *  advertisementData   锁的广播
 *  isContainAdmin      锁是否存在管理员（即是否处于设置模式）  例：YES存在（非设置模式）  NO不存在（设置模式）
 *  isAllowUnlock  三代锁中广播的一个信号值 YES为有人摸锁， 二代锁一直为YES 车位锁一直为NO
 *  oneMeterRSSI   三代锁中广播的一个信号值 这个数值是离锁一米左右的rssi  二代锁为固定的值
 *  protocolType    协议类别   例：5 是门锁  10 是车位锁  0x3412 是手环
 *  protocolVersion     协议版本   返回的值 1是LOCK  4是二代锁 3是三代锁
 *  scene      类型：DoorSceneType   应用场景
 *  lockSwitchState   类型：TTLockSwitchState  车位锁（scene == 7）的开关状态 ,不支持此功能的锁返回的值为TTLockSwitchStateUnknown
 */
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic;

/**
 *  已经连接上蓝牙的回调
 *
 *  @param peripheral     搜索到的蓝牙对象
 *  @param lockName       锁名
 */

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName;

/**
 *  断开与蓝牙的连接
 *
 *  @param periphera   搜索到的蓝牙对象
 */
-(void)onBTDisconnect_peripheral:(CBPeripheral*)periphera;

/**
 *  获取锁的版本号成功
 *  @param versionStr  由（protocolType.protocolVersion.scene.groupId.orgId组成）中间以点(.）连接
 */
-(void)onGetProtocolVersion:(NSString*)versionStr;
/**
 *  添加管理员成功  以字典形式返回参数
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockKey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  mac     mac地址 唯一标识
 *  timestamp 时间戳
 *  pwdInfo  生成的加密密码数据
 *  electricQuantity 如果为-1 则表示没有获取到电量
 *  adminPassword   管理员开门密码
 *  deletePassword  管理员删除密码
 *  Characteristic(LongLong) 锁的特征值 使用类 TTSpecialValueUtil 来判断支持什么功能
 *  unlockFlag   标记位 添加成功的时候为0  注：如果这里没有返回这个参数 需要写成0即可
 *  DeviceInfoType 类型：NSDictionary 读取设备的信息 1 2 3 4 5 6 参考枚举   包括 1-产品型号 2-硬件版本号 3-固件版本号 4-生产日期 5-蓝牙地址 6-时钟
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)
 */
-(void)onAddAdministrator_addAdminInfoDic:(NSDictionary*)addAdminInfoDic;

/**
 *  校准时间成功
 */
-(void)onSetLockTime;
/**
 *  开锁成功   参数lockTime是锁里的时间（只有三代锁有这个时间，其他为0）
 */
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime;

/**
 *  开(闭、上)锁成功   参数lockTime是锁里的时间（只有三代锁有这个时间，其他为0）
 */
- (void)onLockingWithLockTime:(NSTimeInterval)lockTime;

/**
 *  设置管理员开门密码成功
 */
-(void)onSetAdminKeyboardPassword;
/**
 *  设置管理员删除密码成功
 */
-(void)onSetAdminDeleteKeyboardPassword;
/**
 *  重置键盘密码成功
 */
-(void)onResetKeyboardPassword_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo;
/**
 *  重置电子钥匙成功
 */
-(void)onResetEkey;
/**
 *  恢复出厂设置 (只有三代锁有)
 */
-(void)onResetLock;
/**
 *  读取开锁记录 或IC卡记录 或指纹记录 或开门密码 成功的回调 (只有三代锁有)
 *  LockOpenRecordStr 有数据返回json格式的字符串  无数据返回nil
 */
- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr;
/**
 *  删除单个键盘密码 (只有三代锁有)
 */
- (void)OnDeleteUserKeyBoardPassword;
/**
 修改键盘密码 (只有三代锁有)
 */
- (void)onModifyUserKeyBoardPassword;
/**
 添加键盘密码 (只有三代锁有)
 */
- (void)onAddUserKeyBoardPassword;
/**
 *  获取特征值 (只有三代锁有)
 characteristic  锁的特征值 使用类 TTSpecialValueUtil 来判断支持什么功能
 */
- (void)onGetDeviceCharacteristic:(long long)characteristic;
/**
 *  获取锁时间 (只有三代锁有)
 */
- (void)onGetLockTime:(NSTimeInterval)lockTime;
/**
 *  设置锁里手环key成功 (只有三代锁有)
 */
- (void)onSetLockWristbandKey;
/**
 *  设置手环里key成功 (只有三代锁有)
 */
- (void)onSetWristbandKey;
/**
 *  配置手环信号值成功 (只有三代锁有)
 */
- (void)onSetWristbandRssi;
/**
 *  低电量报警 (只有LOCK锁有)
 */
- (void)onLowPower;
/**
 *  添加IC卡
 *
 *  @param state    1 识别到IC卡并成功添加  2成功启动添加IC卡模式
 *  @param ICNumber  状态1包含卡号，其他状态无卡号字段
 */
- (void)onAddICWithState:(AddICState)state ICNumber:(NSString*)ICNumber;
/**
 *   清空IC卡 (只有三代锁有)
 */
- (void)onClearIC;
/**
 *   删除IC卡 (只有三代锁有)
 */
- (void)onDeleteIC;
/**
 *   修改IC卡 (只有三代锁有)
 */
- (void)onModifyIC;
/**
 指纹采集（添加）
 
 @param state AddFingerprintState
 @param fingerprintNumber 状态AddFingerprintCollectSuccess包含指纹编号，其他状态无此状态
 @param currentCount 当前录入指纹的次数（-1表示次数未知）,第一次返回当前采集次数为0，最后一次直接返回状态1及指纹编号 状态AddFingerprintCollectSuccess时不返回
 @param totalCount   需要录入指纹的次数（-1表示次数未知） 状态AddFingerprintCollectSuccess时不返回
 */
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString*)fingerprintNumber currentCount:(int)currentCount totalCount:(int)totalCount ;

- (void)onClearFingerprint;

- (void)onDeleteFingerprint;

- (void)onModifyFingerprint;
/**
 查询闭锁时间
 currentTime  当前闭锁时间
 minTime  锁最小的闭锁时间
 maxTime  锁最大的闭锁时间
 */
- (void)onQueryLockingTimeWithCurrentTime:(int)currentTime minTime:(int)minTime maxTime:(int)maxTime;
/**
  修改闭锁时间成功
 */
- (void)onModifyLockingTime;
/**
  读取设备的信息
  infoDic  字典里key参考枚举 TTUtils.h -> DeviceInfoType
 */
- (void)onGetDeviceInfo:(NSDictionary*)infoDic;
/**
  进入可固件升级状态
 */
- (void)onEnterFirmwareUpgradeMode;
/**
 锁的开关状态
 
 @param state  参考 TTLockSwitchState
 */
- (void)onGetLockSwitchState:(TTLockSwitchState)state;
/**
 查询屏幕上显示状态成功
 
 @param state  0-隐藏  1-显示
 */
- (void)onQueryScreenState:(BOOL)state;

/**
 修改屏幕上显示状态成功
 */
- (void)onModifyScreenShowState;

/**
 修改锁名成功
 */
- (void)onSetLockName;
/**
 恢复键盘密码
 */
- (void)onRecoverUserKeyBoardPassword;
/**
 *  读取新密码方案参数（约定数、映射数、删除日期）键盘密码成功(只有三代锁有)
 */
-(void)onGetPasswordData_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo;

#pragma mark --- 废弃
-(void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory __attribute__((deprecated("SDK2.6 onFoundDevice_peripheralWithInfoDic" )));
-(void)onAddAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)versionStr mac:(NSString*)mac timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo electricQuantity:(int)electricQuantity adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward Characteristic:(int)characteristic  __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onAddAdministrator_password:(NSString*)password key:(NSString*)key aesKey:(NSString*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onLock __attribute__((deprecated("SDK2.6.3 onLockingWithLockTime")));
/**
 *  蓝牙的状态改变时 The central manager whose state has changed.
 */
- (void)TTLockManagerDidUpdateState:(CBCentralManager *)central __attribute__((deprecated("SDK2.6.3 onLockingWithLockTime")));
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString*)fingerprintNumber __attribute__((deprecated("SDK2.6.3 onLockingWithLockTime")));


@end

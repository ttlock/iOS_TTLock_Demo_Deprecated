
//
//  Created by TTLock on 2017/8/11.
//  Copyright © 2017年 TTLock. All rights reserved.


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "TTSpecialValueUtil.h"
#import "TTUtils.h"
#import "SecurityUtil.h"
#import "TTLockGateway.h"
#import "TTSDKDelegate.h"

//以下是接口
@interface TTLock : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>

//用来设置SDK是否打印Log的接口，YES打印，NO不打印 默认为No
+ (void)setDebug:(BOOL)debug;
/** SDK 代理*/
@property (nonatomic, weak) id <TTSDKDelegate> delegate;
/**服务器上用户的唯一标识，用于锁内部存储操作记录 即openid */
@property (nonatomic, strong) NSString *uid;
/**三代锁锁添加管理员时的固定数据 可不设置，用完一次后就会恢复为默认值*/
@property (nonatomic, strong) NSString *setClientPara;
/**设置系统的弹框是否显示，创建完TTLock单例对象就调用 yes开 no关  默认是关闭（启动APP时,如果蓝牙未打开，系统会弹框提醒*/
@property (nonatomic,assign) BOOL isShowBleAlert;
/**中心设备对象*/
@property (nonatomic,strong,readonly) CBCentralManager *manager;
/**当前连接的蓝牙*/
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

/**初始化科蓝牙类*/
-(id)initWithDelegate:(id<TTSDKDelegate>)TTDelegate;

/**获取单例*/
+ (TTLock*)sharedInstance;

/**创建蓝牙对象*/
-(void)setupBlueTooth;

/**
 开始扫描附近的蓝牙 特定服务的门锁 推荐使用

 @param isScanDuplicates every time the peripheral is seen, which may be many times per second. This can be useful in specific situations.Recommend this value to be NO.

 */
-(void)startBTDeviceScan:(BOOL)isScanDuplicates;
/**
 开始扫描附近的蓝牙 所有蓝牙设备 如果开发手环的需要 可以用

 @param isScanDuplicates every time the peripheral is seen, which may be many times per second. This can be useful in specific situations.Recommend this value to be NO

 */
- (void)scanAllBluetoothDeviceNearby:(BOOL)isScanDuplicates;

/**
 开始扫描附近特定服务的蓝牙

 @param servicesArray 服务
 @param isScanDuplicates  every time the peripheral is seen, which may be many times per second. This can be useful in specific situations.Recommend this value to be NO
 */
- (void)scanSpecificServicesBluetoothDevice_ServicesArray:(NSArray<NSString *>*)servicesArray isScanDuplicates:(BOOL)isScanDuplicates;

/** 停止扫描附近的蓝牙*/
-(void)stopBTDeviceScan;

/** 连接蓝牙 Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link disconnect}.
 */
-(void)connect:(CBPeripheral *)peripheral;

/** 断开蓝牙连接
 */
-(void)disconnect:(CBPeripheral *)peripheral;

/**
 连接蓝牙 Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link cancelConnectPeripheralWithLockMac}.
 @param lockMac 锁的mac地址（老的锁没有mac地址就传lockName锁名）
 */
- (void)connectPeripheralWithLockMac:(NSString *)lockMac;
/**
 取消连接蓝牙
 @param lockMac 锁的mac地址（老的锁没有mac地址就传lockName锁名）
 */
- (void)cancelConnectPeripheralWithLockMac:(NSString *)lockMac;

/**
 *  获取锁电量 调用指令成功后，再调用此接口
 */
-(int)getPower;

/** 获取锁版本
 */
-(void)getProtocolVersion;
/**
 *  添加管理员 (也适用于车位锁)
 * param addDic参数为字典  下面对应键及其值的意义
 * lockMac               锁的mac
 * protocolType          协议类别
 * protocolVersion       协议版本
 * adminPassward         可以不传  管理员密码（车位锁没有这个功能）  若传nil 则随机生成7位数密码
 * deletePassward        可以不传  清空码（车位锁与三代锁没有这个功能） 若传nil 则随机生成7位数密码
 *                            密码范围:二代锁7-9位数字 三代锁 4-9位数字
 */
-(void)addAdministrator_addDic:(NSDictionary *)addDic;

/** 管理员开锁 (也适用于车位锁)
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  uniqueid  记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/** eKey开锁 (也适用于车位锁)
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  startDate  开始时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或 2000-1-1 0:0
 *  endDate    结束时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或 2099-12-31 23:59
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  uniqueid  记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
-(void)unlockByUser_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate*)startDate endDate:(NSDate*)endDate version:(NSString*)version unlockFlag:(int)flag  uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/**  eKey 校准锁的时钟并开锁，和referenceTime一致
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  startDate  开始时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2000-1-1 0:0
 *  endDate    结束时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2099-12-31 23:59
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  referenceTime  传入的校准时间
 *  uniqueid  记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
-(void)calibationTimeAndUnlock_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate *)sdate endDate:(NSDate *)edate version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time uniqueid:(NSNumber*)uniqueid timezoneRawOffset:(long)timezoneRawOffset;

/**
 关（闭）锁 （也适用于车位锁以及支持此功能的门锁）
 @param lockkey  约定数
 @param aesKey  aesKey
 @param  flag  标记位
 @param uniqueid 记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 @param isAdmin  YSE为管理员 反之为普通用户  管理员开始和结束时间可任意传
 @param sdate 开始时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2000-1-1 0:0
 @param edate   结束时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2099-12-31 23:59
 @param timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)locking_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid isAdmin:(BOOL)isAdmin startDate:(NSDate *)sdate endDate:(NSDate *)edate timezoneRawOffset:(long)timezoneRawOffset;

/** 设置管理员的键盘密码
 *  keyboardPassword  要设置的键盘密码 密码范围:二代锁7-9位数字 三代锁 4-9位数字
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 */
-(void)setAdminKeyBoardPassword:(NSString*)keyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** 设置管理员的删除键盘密码
 *  delKeyboardPassword 要设置的删除键盘密码 密码范围:二代锁7-9位数字 三代锁 4-9位数字
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 */
-(void)setAdminDeleteKeyBoardPassword:(NSString*)delKeyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** 校准锁的时钟，和传入参考时间一致 (不包含车位锁)
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  referenceTime  传入的校准时间
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time timezoneRawOffset:(long)timezoneRawOffset;


/**
 *  重置电子钥匙
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 */
-(void)resetEkey_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/** 初始化用户键盘密码（即重置键盘密码）
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
-(void)resetKeyboardPassword_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** 恢复出厂设置 （只有三代锁管理员有）
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 */
-(void)resetLock_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;
/**
 *  删除单个密码 （只有三代锁管理员有）
 *  keyboardPs  要删除的密码
 *  passwordType(可任意传）
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 */
-(void)deleteOneKeyboardPassword:(NSString *)keyboardPs adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey passwordType:(KeyboardPsType)passwordType  version:(NSString*)version unlockFlag:(int)flag;
/**
 修改键盘密码
 
 @param newPassword 新密码 密码范围: 三代锁 4-9位数字 如果不需要修改密码，则传nil
 @param oldPassword 旧密码
 @param startDate 开始时间 如果不需要修改时间，则传nil
 @param endDate 结束时间   如果不需要修改时间，则传nil
 @param adminPS 管理员密码 管理员开门时校验管理员身份的
 @param lockkey 约定数开门使用
 @param aesKey 开门使用
 @param flag 开门标记位
 @param timezoneRawOffset  锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)modifyKeyboardPassword_newPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword  startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;


/**
 恢复键盘密码
 
 @param passwordType   密码类型
 @param cycleType    循环类型  循环密码需要传 其他类型任意传
 @param newPassword 新密码
 @param oldPassword 旧密码
 @param startDate 开始时间
 @param endDate 结束时间   限时密码需要结束时间 其他类型可以传nil
 @param adminPS 管理员密码
 @param lockkey  约定数开门使用
 @param aesKey 开门使用
 @param flag 开门标记位
 @param timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)recoverKeyboardPassword_passwordType:(KeyboardPsType)passwordType cycleType:(NSInteger)cycleType newPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword  startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;

/**
 添加键盘密码
 
 @param keyboardPs 要添加的密码 密码范围: 三代锁 4-9位数字
 @param startDate 开始时间 必传
 @param endDate 结束时间 必传
 @param adminPS 管理员密码 管理员开门时校验管理员身份的
 @param lockkey 约定数开门使用
 @param aesKey 开门使用
 @param flag 开门标记位
 @param timezoneRawOffset  锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)addKeyboardPassword_password:(NSString *)keyboardPs startDate:(NSDate*)startDate endDate:(NSDate*)endDate adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  读取开锁记录 （只有三代锁有）
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)getOperateLog_aesKey:(NSString*)aesKey version:(NSString *)version unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  获取锁时间 （只有三代锁有）
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)getLockTime_aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag timezoneRawOffset:(long)timezoneRawOffset;
/**
 *  获取锁特征值 （只有三代锁有）
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 */
- (void)getDeviceCharacteristic_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;
/**
 *  操作IC卡 （只有三代锁有）
 *  type  参考枚举OprationType  恢复的回调是添加成功的那个回调
 *  ICNumber 卡号   类型:清空、添加和查询传 nil
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  startDate endDate 开始时间和结束时间  类型为OprationTypeModify需要传 永久有效卡期限:2000-1-1 0:0  2099-1-1 0:0
 *  flag  标记位
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)operate_type:(OprationType)type adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey ICNumber:(NSString*)ICNumber startDate:(NSDate*)startDate endDate:(NSDate*)endDate unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  操作指纹 （只有三代锁有）
 *  type  参考枚举OprationType
 *  FingerprintNumber 指纹编号   类型:清空、添加和查询传 nil
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  startDate endDate 开始时间和结束时间  类型为OprationTypeModify需要传 永久有效卡期限:2000-1-1 0:0  2099-1-1 0:0
 *  unlockFlag  标记位
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)operateFingerprint_type:(OprationType)type adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey FingerprintNumber:(NSString*)FingerprintNumber startDate:(NSDate*)startDate endDate:(NSDate*)endDate unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
 *  设置门锁里手环的Key （只有三代锁有）
 *  wristbandKey 设置的wristbandKey
 *  keyboardPassword  现有的管理员开门密码 如果想修改管理员密码 也可以不传现有的  必传参数
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  unlockFlag  标记位
 */
- (void)setLockWristbandKey:(NSString*)wristbandKey keyboardPassword:(NSString*)keyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 * 设置手环里的key
 * isOpen 这个功能是否打开
 */
- (void)setWristbandKey:(NSString*)wristbandKey isOpen:(BOOL)isOpen;
/**
 *  设置闭锁时间
 *  OprationType 只有查询和修改
 *  time 是设置的闭锁时间 修改：传0是不闭锁  查询：可传任意值
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 * unlockFlag  标记位
 */
- (void)setLockingTime_type:(OprationType)type time:(int)time adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 * 读取设备的信息  包括 1-产品型号 2-硬件版本号 3-固件版本号 4-生产日期 5-	蓝牙地址 6-时钟
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 */
- (void)getDeviceInfo_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;
/**
 *  进入可固件升级状态
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  unlockFlag 开门标记位
 */
- (void)upgradeFirmware_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/**
 * 配置手环信号值
 * rssi 要设置的信号值
 */
- (void)setWristbandRssi:(int)rssi;

/** 查询锁开关状态
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 */
- (void)getLockSwitchState_aesKey:(NSString*)aesKey;
/**
 是否在屏幕上显示输入的密码
 
 @param type  操作类型 1- 查询 2- 修改
 @param isShow 是否显示密码  0-隐藏  1-显示 操作类型为修改时有用
 @param adminPS  管理员密码
 @param lockkey 约定数
 @param aesKey aesKey
 @param unlockFlag 标记位
 */
- (void)operateScreen_type:(int)type isShow:(BOOL)isShow adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;
/**
 *  读取开锁密码 （只有三代管理员才能读取开锁密码）成功的回调是 onGetOperateLog_LockOpenRecordStr
 *  adminPS 管理员密码
 *  aesKey  开门使用
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)getKeyboardPasswordList_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

/**
 读取新密码方案参数（约定数、映射数、删除日期）
 */
- (void)getPasswordData_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

#pragma mark --- 废弃

/**车位锁 升为yes 降为no*/
@property (nonatomic) BOOL parklockAction __attribute__((deprecated("SDK2.6.3 开锁接口是降 关锁接口locking_lockKey是升")));
/**三代锁中广播的一个信号值 0表示不连接 其他表示连接*/
@property (nonatomic,readonly) int allowUnlock __attribute__((deprecated("SDK2.6")));
/**三代锁中广播的一个信号值 这个数值是离锁一米左右的rssi*/
@property (nonatomic,readonly) int oneMeterRSSI __attribute__((deprecated("SDK2.6")));
/** 管理员开锁 （用的是referenceTime校准）
 *  用上边的unlockByAdministrator_adminPS管理员开锁方法和校准时间方法 替换此方法
 */
- (void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)referenceTime __attribute__((deprecated("SDK2.6")));

/** 校准锁的时钟，和当前使用手机时间一致 (不包含车位锁)
 * 用上边的setLockTime_lockKey校准锁的时钟方法  替换此方法
 */
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag __attribute__((deprecated("SDK2.6")));
/** 取消连接蓝牙
 */
-(void)cancelConnectPeripheral:(CBPeripheral *)peripheral __attribute__((deprecated("SDK2.7.1")));
/** 开始扫描附近的蓝牙 特定服务的门锁 推荐使用 */
-(void)startBTDeviceScan __attribute__((deprecated("SDK2.7.1")));

/** 开始扫描附近的蓝牙 所有蓝牙设备 如果开发手环的需要 可以用 */
- (void)scanAllBluetoothDeviceNearby __attribute__((deprecated("SDK2.7.1")));

/** 开始扫描附近特定服务的蓝牙
 * servicesArray 数组里的元素要NSString类型
 */
- (void)scanSpecificServicesBluetoothDevice_ServicesArray:(NSArray*)servicesArray __attribute__((deprecated("SDK2.7.1")));
/** 管理员开锁*/
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid __attribute__((deprecated("SDK2.7.1")));
/**
 *  添加管理员 (也适用于车位锁)
 *
 *  @param advertisementData  蓝牙广播的数据advertisementData
 *  @param adminPassward      管理员密码（车位锁没有这个功能）  若传nil 则随机生成7位数密码
 *  @param deletePassward     清空码（车位锁与三代锁没有这个功能） 若传nil 则随机生成7位数密码
 *                            密码范围:二代锁7-9位数字 三代锁 4-9位数字
 */
-(void)addAdministrator_advertisementData:(NSDictionary *)advertisementData adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward __attribute__((deprecated("SDK2.7.4")));
@end



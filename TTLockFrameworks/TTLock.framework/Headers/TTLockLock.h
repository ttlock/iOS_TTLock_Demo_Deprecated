//
//
//  Created by TTLock on 14-4-25.
//  Copyright (c) 2014年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

/** 错误码
 *
 */
typedef NS_ENUM(NSInteger, TTError)
{
    TTErrorHadReseted = 0,                              /** 锁可能已被重置 */
    TTErrorDataCRCError = 0x01,                         /** CRC校验出错 */
    TTErrorNoPermisston = 0x02,                         /** 身份校验失败，无操作权限(非管理员) */
    TTErrorIsWrongPS = 0x03,                            /** 管理员密码不正确 */
    TTErrorNoMemory = 0x04,                             /** 存储空间不足, 超出保存用户的最大数量 */
    TTErrorInSettingMode = 0x05,                        /** 处于设置模式(开门必须处于非设置模式) */
    TTErrorNoAdmin = 0x06,                              /** 不存在管理员 */
    TTErrorIsNotSettingMode = 0x07,                     /** 处于非设置模式(添加管理员必须处于设置模式) */
    TTErrorIsWrongDynamicPS = 0x08,                     /** 动态密码错误(约定数字于随机数之和错误) */
    TTErrorIsNoPower = 0x0a,                            /** 电池没电, 无法开门 */
    TTErrorResetKeyboardPs = 0x0b,                      /** 设置900密码失败 */
    TTErrorUpdateKeyboardIndex = 0x0c,                  /** 更新键盘密码序列出错 */
    TTErrorIsInvalidFlag = 0x0d,                        /** 失效flag */
    TTErrorEkeyOutOfDate = 0x0e,                        /** ekey过期 */
    TTErrorPasswordLengthInvalid = 0x0f,                 /** 密码长度无效 */
    TTErrorSuperPasswordIsSameWithDeletePassword = 0x10,  /** 管理员密码与删除密码相等 */
    TTErrorEkeyNotToDate = 0x11,                        /** 未到有效期 */
    TTErrorAesKey = 0x12,                               /** 未登录 无操作权限 */
    TTErrorFail = 0x13,                               /** 操作失败 */
    TTErrorPsswordExist = 0x14,                          /** 添加的密码已经存在 */
    TTErrorPasswordNotExist = 0x15,                     /** 删除或者修改的密码不存在 */
    TTErrorNoFree_Memory = 0x16,						  /** 存储空间不足（比如添加密码时，超过存储容量）*/
    TTErrorInvalidParaLength = 0x17,					  /** 参数长度无效 */
    TTErrorCardNotExist =	0x18,					      /** IC卡不存在 */
    TTErrorFingerprintDuplication =	0x19,			  /** 重复指纹 */
    TTErrorFingerprintNotExist = 0x1A,                   /** 指纹不存在 */
    TTErrorInvalidClientPara = 0x1D,                   /** 无效的特殊字符串 */
    TTErrorNotSupportModifyPwd = 0x60                   /** 不支持修改密码 */

};

/** 键盘密码类型
 *
 */
typedef NS_ENUM(NSInteger, KeyboardPsType)
{
    KeyboardPsTypeOnce = 1,          /** 单次密码 */
    KeyboardPsTypePermanent = 2,     /** 永久密码 */
    KeyboardPsTypePeriod = 3,        /** 时限密码 */
    KeyboardPsTypeCycle = 4          /** 循环密码 **/
};

/** 密码 IC卡等操作类型
 *
 */
typedef NS_ENUM(NSInteger,OprationType)
{
    OprationTypeClear = 1,     /** 清空 */
    OprationTypeAdd = 2,       /** 添加 */
    OprationTypeDelete = 3,    /** 删除 */
    OprationTypeModify = 4,    /** 修改 */
    OprationTypeQuery = 5,      /** 查询 */
    OprationTypeRecover = 6     /** 恢复 */
    
};

/** 添加 IC 卡返回的状态类型
 *
 */
typedef NS_ENUM(NSInteger,AddICState)
{
    AddICStateHadAdd = 1,   /** 识别到IC卡并成功添加 */
    AddICStateCanAdd = 2,   /** 成功启动添加IC卡模式 */
    
};

/** 添加指纹返回的状态类型
 *
 */
typedef NS_ENUM(NSInteger,AddFingerprintState)
{
    AddFingerprintCollectSuccess = 1,     /**  添加指纹成功 包含指纹编号,其他状态无此字段。*/
    AddFingerprintCanCollect = 2,         /** 成功启动添加指纹模式，这时候App可以提示“请按手指” */
    AddFingerprintCanCollectAgain = 3,    /** 第一次采集指纹成功，开始第二次采集，这时候App可以提示“请再次按手指” */
};

/** 读取设备信息的类型
 *
 */
typedef NS_ENUM(NSInteger,DeviceInfoType) {
    DeviceInfoTypeOfProductionModel = 1,    /**  1-	产品型号 */
    DeviceInfoTypeOfHardwareVersion = 2,    /**  2-	硬件版本号 */
    DeviceInfoTypeOfFirmwareVersion = 3,    /**  3-	固件版本号 */
    DeviceInfoTypeOfProductionDate = 4,     /**  4-	生产日期 */
    DeviceInfoTypeOfProductionMac = 5,      /**  5-	蓝牙地址 */
    DeviceInfoTypeOfProductionClock = 6     /**  6-	时钟 */
    
};

/**回调 TTSDK代理*/
@protocol TTSDKDelegate <NSObject>

@optional

/**
 *  相关回调 错误码
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
 *  isAllowUnlock  三代锁中广播的一个信号值 YES为有人摸锁， 二代锁一直为YES
 *  oneMeterRSSI   三代锁中广播的一个信号值 这个数值是离锁一米左右的rssi  二代锁为固定的值
 *  protocolCategory    协议类别   例：5 是门锁  10 是车位锁  0x3412 是手环
 *  protocolVersion     协议版本   返回的值 1是LOCK  4是二代锁 3是三代锁
 *  scene                应用场景   返回的值 1是普通二代门锁 2二代锁带永久密码功能的门锁 、三代锁默认也是这个值 3是荣域定制的门锁 4是门禁 5是保险箱锁 6是自行车锁

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
 *  @param peripheral     搜索到的蓝牙对象
 */
-(void)onBTDisconnect_peripheral:(CBPeripheral*)periphera;

/**
 *  获取锁的版本号成功
 *  @param versionStr  由（protocolType.protocolVersion.scene.groupId.orgId组成）中间以点(.）连接
 */
-(void)onGetProtocolVersion:(NSString*)versionStr;
/**
 *  添加管理员成功  已字典形式返回参数
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  mac     mac地址 唯一标识
 *  timestamp 时间戳
 *  pwdInfo  生成的加密密码数据
 *  electricQuantity 如果为-1 则表示没有获取到电量
 *  adminPassword   管理员开门密码
 *  deletePassword  管理员删除密码
 *  Characteristic  锁的特征值 使用类 TTSpecialValueUtil 来判断支持什么功能
 *  unlockFlag   标记位 添加成功的时候为0  注：如果这里没有返回这个参数 需要写成0即可
 *  DeviceInfoType 读取设备的信息 1 2 3 4 5 6 参考枚举   包括 1-产品型号 2-硬件版本号 3-固件版本号 4-生产日期 5-蓝牙地址 6-时钟
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
- (void)onGetDeviceCharacteristic:(int)characteristic;
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
 *  开始扫描
 */
-(void)onStartBTDeviceScan;
/**
 *  断开扫描
 */
-(void)onStopBTDeviceScan;
/**
 *  蓝牙的状态改变时 The central manager whose state has changed.
 */
- (void)TTLockManagerDidUpdateState:(CBCentralManager *)central;

#pragma mark ------ IC卡
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
#pragma mark ------ 指纹 添加 清空 删除 修改
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString*)fingerprintNumber;

- (void)onClearFingerprint;

- (void)onDeleteFingerprint;

- (void)onModifyFingerprint;
#pragma mark ------ 闭锁时间 查询 修改
- (void)onQueryLockingTimeWithCurrentTime:(int)currentTime minTime:(int)minTime maxTime:(int)maxTime;

- (void)onModifyLockingTime;

#pragma mark ------ 读取设备的信息  包括 1-产品型号 2-硬件版本号 3-固件版本号 4-生产日期 5-蓝牙地址 6-时钟  字典的key参考枚举 DeviceInfoType
- (void)onGetDeviceInfo:(NSDictionary*)infoDic;

#pragma mark ------ 进入可固件升级状态
- (void)onEnterFirmwareUpgradeMode;

#pragma mark ------ 0-关锁 1-开锁 2未知状态
- (void)onGetLockSwitchState:(BOOL)state;

#pragma mark ------ 是否在屏幕上显示输入的密码

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

#pragma mark --- 废弃
-(void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory __attribute__((deprecated("SDK2.6 onFoundDevice_peripheralWithInfoDic" )));
-(void)onAddAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)versionStr mac:(NSString*)mac timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo electricQuantity:(int)electricQuantity adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward Characteristic:(int)characteristic  __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onAddAdministrator_password:(NSString*)password key:(NSString*)key aesKey:(NSString*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac __attribute__((deprecated("onAddAdministrator_addAdminInfoDic")));
-(void)onLock __attribute__((deprecated("SDK2.6.3 onLockingWithLockTime")));

@end


//以下是接口
@interface TTLockLock : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>

//用来设置SDK是否打印Log的接口，YES打印，NO不打印 默认为No
+ (void)setDebug:(BOOL)debug;
/** SDK 代理*/
@property (nonatomic, weak) id <TTSDKDelegate> delegate;
/**中心设备对象*/
@property (nonatomic,strong) CBCentralManager *manager;
/**服务器上用户的唯一标识，用于锁内部存储操作记录*/
@property (nonatomic, strong) NSString *uid;
/**三代锁锁添加管理员时的固定数据 可不设置，用完一次后就会恢复为默认值*/
@property (nonatomic, strong) NSString *setClientPara;
/**当前连接的蓝牙*/
@property (nonatomic, readonly) CBPeripheral *activePeripheral;
/**设置系统的弹框是否显示，创建完TTLock单例对象就调用 yes开 no关  默认是关闭（启动APP时,如果蓝牙未打开，系统会弹框提醒*/
@property (nonatomic,assign) BOOL isShowBleAlert;


/**初始化科蓝牙类*/
-(id)initWithDelegate:(id<TTSDKDelegate>)TTDelegate;

/**获取单例*/
+ (TTLockLock*)sharedInstance;

/**创建蓝牙对象*/
-(void)setupBlueTooth;

/** 开始扫描附近的蓝牙 特定服务的门锁 推荐使用 */
-(void)startBTDeviceScan;

/** 开始扫描附近的蓝牙 所有蓝牙设备 如果开发手环的需要 可以用 */
- (void)scanAllBluetoothDeviceNearby;

/** 开始扫描附近特定服务的蓝牙 
 * servicesArray 数组里的元素要NSString类型
 */
- (void)scanSpecificServicesBluetoothDevice_ServicesArray:(NSArray*)servicesArray;

/** 停止扫描附近的蓝牙*/
-(void)stopBTDeviceScan;

/** 连接蓝牙
 */
-(void)connect:(CBPeripheral *)peripheral;

/** 断开蓝牙连接
 */
-(void)disconnect:(CBPeripheral *)peripheral;

/** 取消连接蓝牙
 */
-(void)cancelConnectPeripheral:(CBPeripheral *)peripheral;

/**
 *  获取锁电量 调用指令成功后，再调用此接口
 */
-(int)getPower;

/** 获取锁版本
 */
-(void)getProtocolVersion;

/**
 *  添加管理员
 *
 *  @param advertisementData  蓝牙广播的数据advertisementData
 *  @param adminPassward      管理员密码（车位锁没有这个功能）  若传nil 则随机生成7位数密码
 *  @param deletePassward     清空码（车位锁与三代锁没有这个功能） 若传nil 则随机生成7位数密码
 *                            密码范围:二代锁7-9位数字 三代锁 4-9位数字
 */
-(void)addAdministrator_advertisementData:(NSDictionary *)advertisementData adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward;

/** 管理员开锁
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成） 中间以点(.）连接
 *  flag  标记位
 *  uniqueid  记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 */
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag uniqueid:(NSNumber*)uniqueid;

/** eKey开锁
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
  	关（闭）锁 （适用车位锁以及支持此功能的门锁）
 @param lockkey  约定数
 @param aesKey
 @param  flag  标记位
 @param uniqueid 记录唯一标识 用于锁内部存储开锁记录 大小不能超过4个字节 建议传时间戳（秒为单位）
 @param isAdmin  YSE为管理员 反之为普通用户  管理员开始和结束时间可任意传
 @param startDate 开始时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2000-1-1 0:0
 @param endDate   结束时间  如果是永久钥匙 传 [NSDate dateWithTimeIntervalSince1970:0]  或2099-12-31 23:59
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
 * 设置闭锁时间
 * OprationType 只有查询和修改
 * time 是设置的闭锁时间 查询可传任意值
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
 @param aesKey
 @param unlockFlag 标记位
 */
- (void)operateScreen_type:(int)type isShow:(BOOL)isShow adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/**
 设置蓝牙名字

 @param lockName 名字  注：名字不能超过15个字节 可以使用类TTUtils里方法convertToByte来获取名字所占字符
 @param adminPS 管理员密码
 @param lockkey 约定数
 @param aesKey aesKey
 @param unlockFlag 标记位
 */
- (void)setLockName:(NSString *)lockName adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag;

/**
 *  读取开锁密码 （只有三代锁有）成功的回调是 onGetOperateLog_LockOpenRecordStr
 *  aesKey  开门使用
 *  timezoneRawOffset 锁初始化时所在时区和UTC时区时间的差数,单位milliseconds(毫秒)  没有这个值，则传-1
 */
- (void)getKeyboardPasswordList_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey unlockFlag:(int)unlockFlag timezoneRawOffset:(long)timezoneRawOffset;

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
@end



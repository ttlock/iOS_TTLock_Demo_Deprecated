//
// 
//  BTstackCocoa
//
//  Created by TTLock on 13-1-31.
//
//

#import <Foundation/Foundation.h>

/** 错误码
 *
 */
typedef NS_ENUM(NSInteger, TTError)
{
    TTErrorHadReseted = 0,                              /** 锁可能已被重置 */
    TTErrorDataCRCError = 0x01,                         /** CRC校验出错 */
    TTErrorNoPermisston = 0x02,                         /** 身份校验失败，无操作权限*/
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

/*!
 *  @enum TTManagerState
 *
 *  @discussion Represents the current state of a Manager.
 *
 *  @constant TTManagerStateUnknown       State unknown, update imminent.
 *  @constant TTManagerStateResetting     The connection with the system service was momentarily lost, update imminent.
 *  @constant TTManagerStateUnsupported   The platform doesn't support the Bluetooth Low Energy Central/Client role.
 *  @constant TTManagerStateUnauthorized  The application is not authorized to use the Bluetooth Low Energy role.
 *  @constant TTManagerStatePoweredOff    Bluetooth is currently powered off.
 *  @constant TTManagerStatePoweredOn     Bluetooth is currently powered on and available to use.
 *
 */
typedef NS_ENUM(NSInteger, TTManagerState) {
    TTManagerStateUnknown = 0,
    TTManagerStateResetting,
    TTManagerStateUnsupported,
    TTManagerStateUnauthorized,
    TTManagerStatePoweredOff,
    TTManagerStatePoweredOn,
} ;

typedef NS_ENUM(int, DoorSceneType)
{
    CommonDoorLockSceneType = 1,           /**普通二代门锁*/
    AdvancedDoorLockSceneType = 2,             /**二代锁带永久密码功能的门锁、三代锁默认也是这个值*/
    RYDoorLock = 3,                           /**荣域定制的门锁*/
    GateLockSceneType = 4,                    /**门禁*/
    SafeLockSceneType = 5,                     /**保险箱锁*/
    BicycleLockSceneType = 6,                  /**自行车锁*/
    ParkSceneType = 7                   /**三代车位锁*/
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

/*!
 *  @enum LockState
 *
 *  @discussion 锁的开关状态
 *
 *  @constant LockStateLock       已关锁
 *  @constant LockStateUnlock     已开锁
 *  @constant LockStateUnknown    状态未知
 *  @constant LockStateUnlockHasCar  已开锁，有车
 *
 */
typedef NS_ENUM(NSInteger,TTLockSwitchState)
{
    TTLockSwitchStateLock = 0,
    TTLockSwitchStateUnlock = 1,
    TTLockSwitchStateUnknown = 2,
    TTLockSwitchStateUnlockHasCar = 3,
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
    AddFingerprintCollectProgress = 4,    /** 指纹采集进度 */
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
//1 是搜索 2 是添加
typedef NS_ENUM(NSInteger, AdvertisementDataType)
{
    AdvertisementDataTypeSearch = 1,
    AdvertisementDataTypeAdd,
};


@interface TTUtils : NSObject

#define DEBUG_UTILS YES
#define DateFormateStringDefault @"yyyy-MM-dd HH:mm:ss"
#define RSSI_SETTING_1m -85    //对应开锁距离1m
#define RSSI_SETTING_2m -150    //对应开锁距离2m
#define RSSI_SETTING_3m -180    //对应开锁距离3m
#define RSSI_SETTING_4m -210    //对应开锁距离4m
#define RSSI_SETTING_5m -240    //对应开锁距离5m

#define DISTANCE_DEFAULT_FOR_SAVE 2.5f               // 默认保存的开锁距离

#define RSSI_SETTING_MAX -65    //对应最近距离0.5m
#define RSSI_SETTING_MIN -140

//#define RSSI_SETTING_CLOSE -60
#define RSSI_SETTING_MIDDLE_0 -85
#define RSSI_SETTING_MIDDLE_1 -100
//#define RSSI_SETTING_FAR -120

#pragma mark --- 时间转换
/** 把NSDate类型 转化成字符串 并根据timezoneRawOffset转化锁里时区的时间 */
+(NSString*)formateDate:(NSDate*)date format:(NSString*)format timezoneRawOffset:(long)timezoneRawOffset;

+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format timezoneRawOffset:(long)timezoneRawOffset;
/**获取当前时间的年份 格式是 yyyy*/
+ (NSString *)getCurrentYear;

#pragma mark --- 数据类型转换
//3字节及以下 用int
+(int)intFromHexBytes:(Byte*)bytes length:(int)dataLen;
//4字节及以上 用long long
+(long long)longFromHexBytes:(Byte*)bytes length:(int)dataLen;
/**字节转字符串*/
+(NSString*)stringFormBytes:(Byte*)bytes length:(int)dataLen;

+(NSData*)DataFromHexStr:(NSString *)hexString;

+(BOOL)isString:(NSString*)source contain:(NSString*)subStr;

+(long) getLongForBytes:(Byte*)packet;

+(void) printByteByByte:(Byte *)packet withLength:(int)length;

+(Byte)generateRandomByte;//随机数

+(void) arrayCopyWithSrc:(Byte*)src srcPos:(int)srcPos dst:(Byte*)dst dstPos:(NSUInteger)dstPos length:(NSUInteger)length;

+(void)getMacBytes:(NSString*)macStr withByte:(Byte*)macBytes;

+(void) generateDynamicPassword:(Byte*)bytes length:(int) length;

+(NSString *) generateDynamicPassword:(int) length;

+(NSData *)EncodeScienerPSBytes:(Byte *)sourceBytes length:(int)length;

+(NSData *)EncodeScienerPS:(NSString *)password;
+(NSData *)DecodeScienerPSToData:(NSData *)data;
+(NSString *)DecodeScienerPS:(NSData *)data;

+(int)RandomNumber0To9_length:(int)length;

+(int)RandomInt0To9;
//随机生成7位数
+ (NSString *)getRandom7Length;
+(NSString *) md5: (NSString *) inPutText;
+(NSString*)EncodeSharedKeyValue:(NSString*)edate;
+(NSString*)DecodeSharedKeyValue:(NSString*)edateStr;

/**
 求字符串所占字节

 @param str 字符串
 @return 所占字节
 */
+ (int)convertToByte:(NSString*)str;

@end

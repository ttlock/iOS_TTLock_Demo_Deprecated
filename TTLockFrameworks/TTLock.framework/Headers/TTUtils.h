//
// 
//  BTstackCocoa
//
//  Created by TTLock on 13-1-31.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TTError)
{
    TTErrorHadReseted = 0,                               /** The lock may have been reset */
    TTErrorDataCRCError = 0x01,                          /** Error of CRC check */
    TTErrorNoPermisston = 0x02,                          /** Failure of identity verification and no operation permissions */
    TTErrorIsWrongPS = 0x03,                             /** Admin code is incorrect */
    TTErrorNoMemory = 0x04,                              /** Lack of storage space */
    TTErrorInSettingMode = 0x05,                         /** In setting mode */
    TTErrorNoAdmin = 0x06,                               /** No administrator */
    TTErrorIsNotSettingMode = 0x07,                      /** Not in setting mode */
    TTErrorIsWrongDynamicPS = 0x08,                      /** Dynamic password error */
    TTErrorIsNoPower = 0x0a,                             /** Battery without electricity */
    TTErrorResetKeyboardPs = 0x0b,                       /** Setting 900 passwords failed */
    TTErrorUpdateKeyboardIndex = 0x0c,                   /** Update the keyboard password sequence error */
    TTErrorIsInvalidFlag = 0x0d,                         /** Invalid flag */
    TTErrorEkeyOutOfDate = 0x0e,                         /** ekey expired */
    TTErrorPasswordLengthInvalid = 0x0f,                 /** Invalid password length */
    TTErrorSuperPasswordIsSameWithDeletePassword = 0x10, /** Admin Passcode is the same as Erase Passcode */
    TTErrorEkeyNotToDate = 0x11,                         /** Short of validity */
    TTErrorAesKey = 0x12,                                /** No login, no operation permissions */
    TTErrorFail = 0x13,                                  /** operation failed */
    TTErrorPsswordExist = 0x14,                          /** The added password has already existed */
    TTErrorPasswordNotExist = 0x15,                      /** The password that are deleted or modified does not exist */
    TTErrorNoFree_Memory = 0x16,						 /** Lack of storage space (as when adding a password) */
    TTErrorInvalidParaLength = 0x17,					 /** Invalid parameter length */
    TTErrorCardNotExist =	0x18,					     /** IC card does not exist */
    TTErrorFingerprintDuplication =	0x19,			     /** Duplication of fingerprints */
    TTErrorFingerprintNotExist = 0x1A,                   /** Fingerprints do not exist */
    TTErrorInvalidClientPara = 0x1D,                     /** Invalid special string */
    TTErrorNotSupportModifyPwd = 0x60                    /** Do not support the modification of the password */
    
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

/*!
 *  @enum DoorSceneType
 *
 *  @discussion Different scenes, different locks
 *
 *  @constant CommonDoorLockSceneType       common v2 lock
 *  @constant AdvancedDoorLockSceneType     v2 lock with permanent password function, v3 lock is also the default value.
 *  @constant RYDoorLock
 *  @constant GateLockSceneType             Gate lock
 *  @constant SafeLockSceneType             Safe Lock
 *  @constant BicycleLockSceneType          Bicycle Lock
 *  @constant ParkSceneType                 Parking Lock
 *  @constant PadLockSceneType              Pad Lock
 *  @constant CylinderLockSceneType         Cylinder Lock
 *
 */
typedef NS_ENUM(int, DoorSceneType)
{
    CommonDoorLockSceneType = 1,
    AdvancedDoorLockSceneType = 2,
    RYDoorLock = 3,
    GateLockSceneType = 4,
    SafeLockSceneType = 5,
    BicycleLockSceneType = 6,
    ParkSceneType = 7,
    PadLockSceneType = 8,
    CylinderLockSceneType = 9,
};
/*!
 *  @enum KeyboardPsType
 *
 *  @discussion Keyboard password type
 *
 *  @constant KeyboardPsTypeOnce           One-time
 *  @constant KeyboardPsTypePermanent      Permanent
 *  @constant KeyboardPsTypePeriod         Timed
 *  @constant KeyboardPsTypeCycle          Cyclic
 *
 */
typedef NS_ENUM(NSInteger, KeyboardPsType)
{
    KeyboardPsTypeOnce = 1,
    KeyboardPsTypePermanent = 2,
    KeyboardPsTypePeriod = 3,
    KeyboardPsTypeCycle = 4
};

/*!
 *  @enum Operation type
 *
 *  @constant OprationTypeClear           Clear
 *  @constant OprationTypeAdd             Add
 *  @constant OprationTypeDelete          Delete
 *  @constant OprationTypeModify          Modify
 *  @constant OprationTypeQuery           Query
 *  @constant OprationTypeRecover         Recover
 *
 */
typedef NS_ENUM(NSInteger,OprationType)
{
    OprationTypeClear = 1,
    OprationTypeAdd = 2,
    OprationTypeDelete = 3,
    OprationTypeModify = 4,
    OprationTypeQuery = 5,
    OprationTypeRecover = 6
    
};

/*!
 *  @enum TTLockSwitchState
 *
 *  @discussion Lock Switch State
 *
 *  @constant LockStateLock       Lock
 *  @constant LockStateUnlock     Unlock
 *  @constant LockStateUnknown    Unknown
 *  @constant LockStateUnlockHasCar  Unlock，Has Car
 *
 */
typedef NS_ENUM(NSInteger,TTLockSwitchState)
{
    TTLockSwitchStateLock = 0,
    TTLockSwitchStateUnlock = 1,
    TTLockSwitchStateUnknown = 2,
    TTLockSwitchStateUnlockHasCar = 3,
};
/*!
 *  @enum TTDoorSensorState
 *
 *  @discussion Door Sensor State
 *
 *  @constant TTDoorSensorStateOff    No door sensor was detected
 *  @constant TTDoorSensorStateOn     Detection of door sensor
 *
 */
typedef NS_ENUM(NSInteger,TTDoorSensorState)
{
    TTDoorSensorStateOff = 0,
    TTDoorSensorStateOn = 1,
};

/*!
 *  @enum AddICState
 *
 *  @discussion State type returned
 *
 *  @constant AddICStateHadAdd    Identify IC card and add successfully
 *  @constant AddICStateCanAdd    Successfully start adding IC card mode
 *
 */
typedef NS_ENUM(NSInteger,AddICState)
{
    AddICStateHadAdd = 1,
    AddICStateCanAdd = 2,
    
};

/*!
 *  @enum AddFingerprintState
 *
 *  @discussion State type returned by adding a fingerprint
 *
 *  @constant AddFingerprintCollectSuccess     Add fingerprint successfully
 *  @constant AddFingerprintCanCollect         Start adding fingerprint mode Successfully
 *  @constant AddFingerprintCanCollectAgain    Start the second collection
 *
 */
typedef NS_ENUM(NSInteger,AddFingerprintState)
{
    AddFingerprintCollectSuccess = 1,
    AddFingerprintCanCollect = 2,
    AddFingerprintCanCollectAgain = 3,
};

/*!
 *  @enum DeviceInfoType
 *
 *  @discussion Read device information
 *
 *  @constant DeviceInfoTypeOfProductionModel     Product model
 *  @constant DeviceInfoTypeOfHardwareVersion     Hardware version
 *  @constant DeviceInfoTypeOfFirmwareVersion     Firmware version
 *  @constant DeviceInfoTypeOfProductionDate      Production Date
 *  @constant DeviceInfoTypeOfProductionMac       Mac
  *  @constant DeviceInfoTypeOfProductionClock    Clock
 *
 */
typedef NS_ENUM(NSInteger,DeviceInfoType) {
    DeviceInfoTypeOfProductionModel = 1,
    DeviceInfoTypeOfHardwareVersion = 2,
    DeviceInfoTypeOfFirmwareVersion = 3,
    DeviceInfoTypeOfProductionDate = 4,
    DeviceInfoTypeOfProductionMac = 5,
    DeviceInfoTypeOfProductionClock = 6
    
};

typedef NS_ENUM(NSInteger, AdvertisementDataType)
{
    AdvertisementDataTypeSearch = 1,
    AdvertisementDataTypeAdd,
};


@interface TTUtils : NSObject

#define DEBUG_UTILS YES
#define DateFormateStringDefault @"yyyy-MM-dd HH:mm:ss"
#define RSSI_SETTING_1m -85     //Corresponding unlocking distance :1m
#define RSSI_SETTING_2m -150    //Corresponding unlocking distance :2m
#define RSSI_SETTING_3m -180    //Corresponding unlocking distance :3m
#define RSSI_SETTING_4m -210    //Corresponding unlocking distance :4m
#define RSSI_SETTING_5m -240    //Corresponding unlocking distance :5m

#define DISTANCE_DEFAULT_FOR_SAVE 2.5f
#define RSSI_SETTING_MAX -65    //Corresponding unlocking distance :0.5m
#define RSSI_SETTING_MIN -140

//#define RSSI_SETTING_CLOSE -60
#define RSSI_SETTING_MIDDLE_0 -85
#define RSSI_SETTING_MIDDLE_1 -100
//#define RSSI_SETTING_FAR -120

#pragma mark --- 时间转换
/** According to timezoneRawOffset, convert NSDate type into NSString. */
+(NSString*)formateDate:(NSDate*)date format:(NSString*)format timezoneRawOffset:(long)timezoneRawOffset;

+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format timezoneRawOffset:(long)timezoneRawOffset;
/** Get the current time of the year, the format is yyyy */
+ (NSString *)getCurrentYear;

#pragma mark --- 数据类型转换
//3bytes and below
+(int)intFromHexBytes:(Byte*)bytes length:(int)dataLen;
//4 bytes and above
+(long long)longFromHexBytes:(Byte*)bytes length:(int)dataLen;

+(NSString*)stringFormBytes:(Byte*)bytes length:(int)dataLen;

+(NSData*)DataFromHexStr:(NSString *)hexString;

+(BOOL)isString:(NSString*)source contain:(NSString*)subStr;

+(long) getLongForBytes:(Byte*)packet;

+(void) printByteByByte:(Byte *)packet withLength:(int)length;

+(Byte)generateRandomByte;

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
//Random generation of 7 digits
+ (NSString *)getRandom7Length;
+(NSString *) md5: (NSString *) inPutText;
+(NSString*)EncodeSharedKeyValue:(NSString*)edate;
+(NSString*)DecodeSharedKeyValue:(NSString*)edateStr;

/**
 The bytes of the string

 @param str
 @return Bytes
 */
+ (int)convertToByte:(NSString*)str;

@end

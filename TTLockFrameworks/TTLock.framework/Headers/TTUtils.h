//
// 
//  BTstackCocoa
//
//  Created by TTLock on 13-1-31.
//
//

#import <Foundation/Foundation.h>
#import "TTLockLock.h"

@interface TTUtils : NSObject




//1 是搜索 2 是添加
typedef NS_ENUM(NSInteger, AdvertisementDataType)
{
    AdvertisementDataTypeSearch = 1,
    AdvertisementDataTypeAdd,
};

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

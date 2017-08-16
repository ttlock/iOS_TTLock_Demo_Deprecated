//
//  Utils.h
//  BTstackCocoa
//
//  Created by wan on 13-1-31.
//
//

#import <Foundation/Foundation.h>
#import "Key.h"
//#import "UserInfo.h"
//#import "Command.h"
/*!
 @class
 @abstract 工具类
 */
@interface XYCUtils : NSObject

#define DateFormateStringDefault @"yyyy-MM-dd HH:mm:ss"

#define DISTANCE_DEFAULT_FOR_SAVE 2.5f               // 默认保存的开锁距离
// 260->200->170
// 越远越小，越近越大
//#define RSSI_SETTING_MAX -45
//#define RSSI_SETTING_MIN -100
//
//#define RSSI_SETTING_CLOSE -50
//#define RSSI_SETTING_MIDDLE -70
//#define RSSI_SETTING_FAR -80


#define RSSI_SETTING_MAX -65    //对应最近距离0.5m
#define RSSI_SETTING_MIN -140

//#define RSSI_SETTING_CLOSE -60
#define RSSI_SETTING_MIDDLE_0 -85
#define RSSI_SETTING_MIDDLE_1 -100
//#define RSSI_SETTING_FAR -120


/*!
 @method
 @abstract 把日期转化成字符串
 @discussion
 @param date 日期
 @param format 格式
 @result NSString
*/
+(NSString*)formateDate:(NSDate*)date format:(NSString*)format;

/*!
 @method
 @abstract  检验无钥匙密码格式是否正确
 @discussion
 @param tagStr 无钥匙密码
 @result BOOL
 */
+(BOOL)checkNokeyPassword:(NSString *)tagStr;


/*!
 @method
 @abstract  获取当前时间,以毫秒为单位
 @discussion
 @result NSString
 */
+(NSString*)GetCurrentTimeInMillisecond;


/*!
 @method
 @abstract  把日期字符串按照一定的格式转换成NSDate类型
 @discussion
 @param dateStr 日期字符串
 @param format  格式
 @result NSDate
 */
+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format;


/*!
 @method
 @abstract  检查注册的用户名
 @discussion
 @param tagStr 用户名
 @result BOOL
 */
+(BOOL)checkRegistUserName:(NSString *)tagStr;


/*!
 @method
 @abstract  检查无钥匙密码
 @discussion
 @param tagStr 无钥匙密码
 @param ok4Zero 是否能等于0的标志
 @result BOOL
 */
+(BOOL)checkNokeyPassword:(NSString *)tagStr ok4Zero:(BOOL)ok4Zero;

/*!
 @method
 @abstract  把hexstring类型转换成NSData
 @discussion
 @param hexString 16进制字符串
 @result NSData
 */
+(NSData*)DataFromHexStr:(NSString *)hexString;


/*!
 @method
 @abstract  按字节和长度打印data
 @discussion
 @param data data数据
 @param length 长度
 @result void
 */
+(void) printByteByByte:(Byte *)data withLength:(int)length;

/*!
 @method
 @abstract  给定起始位置和源字节数据, 按一定的长度拷贝到目标位置和目标字节数据
 @discussion
 @param src 源字节数据
 @param srcPos 源字节位置
 @param dst 目标字节数据
 @param dstPos 目标字节位置
 @param length 长度
 @result void
 */
+(void) arrayCopyWithSrc:(Byte*)src srcPos:(int)srcPos dst:(Byte*)dst dstPos:(NSUInteger)dstPos length:(NSUInteger)length;


@end

//
//  TTSmartLinkLock.h
//  TTLockDemo
//
//  Created by wjjxx on 17/3/23.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLockGateway : NSObject

typedef void(^TTSmartLinkProcessBlock)(NSInteger process);

typedef void(^TTSmartLinkSuccessBlock)(NSString *ip,NSString *mac);
/**
 *  Fail Block
 *
 *  Connection timeout, please confirm whether the gateway is in the add state.
 */
typedef void(^TTSmartLinkFailBlock)();


/**
 *  Get the name of the wireless network SSID for the current connection. If returned nil, the current mobile phone is not connected to the wireless network.
 */
+ (NSString *)getSSID;

/**
 *  Start configuration (method one)
 *
 * @param SSID     Wireless network name
 * @param wifiPwd  Wireless password (no Chinese)
 * @param uid      uid
 * @param userPwd  User password (clear text)
 */
+(void)startWithSSID:(NSString*)SSID wifiPwd:(NSString*)wifiPwd uid:(int)uid userPwd:(NSString*)userPwd  processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;

/**
   Start configuration (method two)

 @param infoDic   key:SSID      type:NSString
                  key:wifiPwd   type:NSString  (no Chinese)
                  key:uid       type:NSNumber
                  key:userPwd   type:NSString
 @param pblock    Process Block
 @param sblock    Success Block
 @param fblock    Fail Block
 */
+(void)startWithInfoDic:(NSDictionary*)infoDic processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;

@end

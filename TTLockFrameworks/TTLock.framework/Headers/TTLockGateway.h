//
//  TTSmartLinkLock.h
//  TTLockDemo
//
//  Created by wjjxx on 17/3/23.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTGATEWAY_CONNECT_TIMEOUT,
    TTGATEWAY_CONNECT_SUCCESS,
    TTGATEWAY_CONNECT_FAIL,
}TTGATEWAY_CONNECT_STATUS;

typedef enum {
    TTGATEWAY_SUCCESS = 0,
    TTGATEWAY_FAIL = 1,
    TTGATEWAY_WRONG_SSID = 3,
    TTGATEWAY_WRONG_WIFI_PASSWORD = 4,
    TTGATEWAY_CRC_ERROR = -1,
    TTGATEWAY_AESKEY_ERROR = -2,
    TTGATEWAY_NOT_CONNECT = -3,
    TTGATEWAY_DISCONNECT = -4,
}TTGATEWAY_STATUS;

@interface TTLockGateway : NSObject
/**
 *  Get the name of the wireless network SSID for the current connection. If returned nil, the current mobile phone is not connected to the wireless network.
 */
+ (NSString *)getSSID;

#pragma mark --- G2

typedef void(^TTGatewayScanBlock)(NSDictionary *infoDic);
typedef void(^TTGatewayConnectBlock)(TTGATEWAY_CONNECT_STATUS connectStatus);
typedef void(^TTGatewayGetWiFiBlock)(BOOL isFinished, NSArray *WiFiArr,TTGATEWAY_STATUS status);
typedef void(^TTGatewayBlock)(TTGATEWAY_STATUS status);
typedef void(^TTInitializeGatewayBlock)(NSDictionary *infoDic,TTGATEWAY_STATUS status);

//扫描
+ (void)startScanGatewayWithBlock:(TTGatewayScanBlock)block;
//停止扫描
+ (void)stopScanGateway;
//连接网关
+ (void)connectGatewayWithLockMac:(NSString *)lockMac block:(TTGatewayConnectBlock)block;
//取消连接
+ (void)disconnectGatewayWithLockMac:(NSString *)lockMac block:(TTGatewayBlock)block;
//获取网关附近WiFi
+ (void)scanWiFiByGatewayWithBlock:(TTGatewayGetWiFiBlock)block;
//初始化（添加）网关
+ (void)initializeGatewayWithInfoDic:(NSDictionary *)infoDic block:(TTInitializeGatewayBlock)block;
+ (void)upgradeGatewayWithLockMac:(NSString *)lockMac block:(TTGatewayBlock)block;

#pragma mark --- G1

typedef void(^TTSmartLinkProcessBlock)(NSInteger process);

typedef void(^TTSmartLinkSuccessBlock)(NSString *ip,NSString *mac);
/**
 *  Fail Block
 *
 *  Connection timeout, please confirm whether the gateway is in the add state.
 */
typedef void(^TTSmartLinkFailBlock)();

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

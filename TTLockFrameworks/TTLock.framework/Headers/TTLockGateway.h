//
//  TTSmartLinkLock.h
//  TTLockDemo
//
//  Created by wjjxx on 17/3/23.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGatewayScanModel.h"
#import "TTSystemInfoModel.h"

typedef NS_ENUM(NSInteger, TTGatewayConnectStatus){
    TTGatewayConnectTimeout = 1,
    TTGatewayConnectSuccess = 2,
    TTGatewayConnectFail = 3,
};

typedef NS_ENUM(NSInteger, TTGatewayStatus){
    TTGatewaySuccess = 0,
    TTGatewayWrongSSID = 3,
    TTGatewayWrongWifiPassword = 4,
    TTGatewayWrongCRC = -1,
    TTGatewayWrongAeskey = -2,
    TTGatewayNotConnect = -3,
    TTGatewayDisconnect = -4,
    TTGatewayFailConfigRouter = -5,
    TTGatewayFailConfigServer = -6,
    TTGatewayFailConfigAccount = -7,

};

@interface TTLockGateway : NSObject
/**
 *  Get the name of the wireless network SSID for the current connection. If returned nil, the current mobile phone is not connected to the wireless network.
 */
+ (NSString *)getSSID;

#pragma mark --- G2
typedef void(^TTGatewayScanBlock)(TTGatewayScanModel *model);
typedef void(^TTGatewayConnectBlock)(TTGatewayConnectStatus connectStatus);
typedef void(^TTGatewayScanWiFiBlock)(BOOL isFinished, NSArray *WiFiArr,TTGatewayStatus status);
typedef void(^TTGatewayBlock)(TTGatewayStatus status);
typedef void(^TTInitializeGatewayBlock)(TTSystemInfoModel *systemInfoModel,TTGatewayStatus status);

/**
 start Scan Gateway
 */
+ (void)startScanGatewayWithBlock:(TTGatewayScanBlock)block;

/**
 Stop Scan
 */
+ (void)stopScanGateway;

/**
 Connect gateway
 */
+ (void)connectGatewayWithGatewayMac:(NSString *)gatewayMac block:(TTGatewayConnectBlock)block;

/**
 Cancel connect with gateway
 */
+ (void)disconnectGatewayWithGatewayMac:(NSString *)gatewayMac block:(TTGatewayBlock)block;

/**
 Get wifi nearby gateway
 */
+ (void)scanWiFiByGatewayWithBlock:(TTGatewayScanWiFiBlock)block;

/**
 initialize Gateway
 
 @param infoDic  @{@"SSID": xxx, @"wifiPwd": xxx, @"uid": xxx ,@"userPwd": xxx, @"gatewayName": xxx}
                 gatewayName  Cannot exceed 48 bytes, exceeding will be truncated
 
 */
+ (void)initializeGatewayWithInfoDic:(NSDictionary *)infoDic block:(TTInitializeGatewayBlock)block;

/**
 Enter gateway into upgrade mode
 */
+ (void)upgradeGatewayWithGatewayMac:(NSString *)gatewayMac block:(TTGatewayBlock)block;

#pragma mark --- G1

typedef void(^TTSmartLinkProcessBlock)(NSInteger process);

typedef void(^TTSmartLinkSuccessBlock)(NSString *ip,NSString *mac);
/**
 *  Fail Block
 *
 *  Connection timeout, please confirm whether the gateway is in the add state.
 */
typedef void(^TTSmartLinkFailBlock)(void);

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

 @param infoDic @{@"SSID": xxx, @"wifiPwd": xxx, @"uid": xxx ,@"userPwd": xxx，@"gatewayName":xxx}
                wifiPwd        Cannot contain Chinese
                gatewayName    Cannot exceed 51 bytes, exceeding will be truncated

 @param pblock    Process Block
 @param sblock    Success Block
 @param fblock    Fail Block
 */
+(void)startWithInfoDic:(NSDictionary*)infoDic processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;

@end

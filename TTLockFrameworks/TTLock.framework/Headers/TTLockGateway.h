//
//  TTSmartLinkLock.h
//  TTLockDemo
//
//  Created by wjjxx on 17/3/23.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLockGateway : NSObject
/**
 *  连接进度的Block
 *
 *  @param process 进度
 */
typedef void(^TTSmartLinkProcessBlock)(NSInteger process);

/**
 *  设置成功以后的Block
 *
 *  @param ip
 *  @param mac
 */
typedef void(^TTSmartLinkSuccessBlock)(NSString *ip,NSString *mac);
/**
 *  设置失败的信息
 *
 *  连接超时，请确认网关是否处于可添加状态。
 */
typedef void(^TTSmartLinkFailBlock)();


/**
 *  获取当前连接的无线网名字SSID 如果返回为nil 说明当前手机没有连接无线网
 */
+ (NSString *)getSSID;

/**
 *  开始配置
 *
 * @param SSID     无线网名称
 * @param wifiPwd  无线密码
 * @param uid      用户id
 * @param userPwd  用户密码
 */
+(void)startWithSSID:(NSString*)SSID wifiPwd:(NSString*)wifiPwd uid:(int)uid userPwd:(NSString*)userPwd  processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;



@end

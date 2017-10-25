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
 *  开始配置（方法一）
 *
 * @param SSID     无线网名称
 * @param wifiPwd  无线密码(不能有中文）
 * @param uid      用户id
 * @param userPwd  用户密码（明文）
 */
+(void)startWithSSID:(NSString*)SSID wifiPwd:(NSString*)wifiPwd uid:(int)uid userPwd:(NSString*)userPwd  processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;

/**
  开始配置（方法二，功能与方法一相同）

 @param infoDic   key:SSID      type:NSString
                  key:wifiPwd   type:NSString  (不能有中文）
                  key:uid       type:NSNumber
                  key:userPwd   type:NSString
 @param pblock 进度的回调
 @param sblock 成功的回调
 @param fblock 失败的回调
 */
+(void)startWithInfoDic:(NSDictionary*)infoDic processblock:(TTSmartLinkProcessBlock)pblock successBlock:(TTSmartLinkSuccessBlock)sblock failBlock:(TTSmartLinkFailBlock)fblock;

@end

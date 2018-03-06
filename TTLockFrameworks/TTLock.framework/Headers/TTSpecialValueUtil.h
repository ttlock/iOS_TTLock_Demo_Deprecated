//
//  TTSpecialValueUtil.h
//  TTLockDemo
//
//  Created by TTLock on 17/4/20.
//  Copyright © 2017年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSpecialValueUtil : NSObject


/**
 是否支持密码

 @param specialValue 特征值
 @return YES为支持  反之不支持
 */
+(BOOL)isSupportPwd:(long long)specialValue;
/**
 是否支持IC卡
 */
+(BOOL)isSupportIC:(long long)specialValue;
/**
 是否支持指纹
 */
+ (BOOL)isSupportFingerPrint:(long long)specialValue;
/**
 是否支持手环
 */
+ (BOOL)isSupportWristband:(long long)specialValue;
/**
 是否支持自动闭锁
 */
+ (BOOL)isSupportAutoLock:(long long)specialValue;
/**
 是否支持密码带删除功能
 */
+ (BOOL)isSupportPasswordDeleteFunction:(long long)specialValue;
/**
 是否支持固件升级
 */
+ (BOOL)isSupportUpgradeFirmware:(long long)specialValue;
/**
 是否支持密码管理功能
 */
+ (BOOL)isSupportPasswordManagement:(long long)specialValue;
/**
 是否支持闭锁指令
 */
+ (BOOL)isSupportLocking:(long long)specialValue;
/**
 是否支持密码显示或者隐藏的控制
 */
+ (BOOL)isSupportPasswordDisplayOrHideControl:(long long)specialValue;
/**
 是否支持网关开锁指令
 */
+ (BOOL)isSupportGatewayUnlock:(long long)specialValue;
/**
 是否支持网关冻结、解冻
 */
+ (BOOL)isSupportGatewayFreezeAndUnfreeze:(long long)specialValue;
/**
 是否支持循环密码
 */
+ (BOOL)isSupportCyclePassword:(long long)specialValue;
/**
 是否支持门磁
 */
+ (BOOL)isSupportDoorSensor:(long long)specialValue;
/**
 是否支持远程开锁开关控制
 */
+ (BOOL)isSupportRemoteUnlockSwicth:(long long)specialValue;
@end

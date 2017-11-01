//
//  TTLockHelper.h
//  Sciener
//
//  Created by wjjxx on 17/1/18.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TTLockHelperClass [TTLockHelper shareInstance]
#define TTObjectTTLockHelper [[TTLockHelper shareInstance] TTObject]

UIKIT_EXTERN NSString *const KKBLEErrorCodeKey ;
UIKIT_EXTERN NSString *const KKBLECommandKey ;

typedef enum {
    KKBLE_CONNECT_DISABLE,
    KKBLE_CONNECT_NONE_TARGET,//连接目标不存在
    KKBLE_CONNECT_REFUSED,//连接被拒绝(蓝牙已经处于连接中)
    KKBLE_CONNECT_TIMEOUT,//连接超时
    KKBLE_CONNECT_TURNOFF,//连接断开
    KKBLE_CONNECT_SUCCESS,//连接成功
    KKBLE_CONNECTED_INSTANTLY_DISCONNECT, //连接成功就断开
    KKBLE_RENTER_DATED, //租客过期
}KKBLE_CONNECT_STATUS;


typedef NS_ENUM(NSInteger,ConfigDevType) {
    ConfigDevIC = 1,
    ConfigDevFingerprint,
    ConfigDevBong,
    ConfigDevLockingTime,
    ConfigDevScreenisShow 
};

typedef void(^BLEBlock)(id info,BOOL succeed);
typedef void(^BLEConnectBlock)(CBPeripheral *peripheral,KKBLE_CONNECT_STATUS connectStatus);
typedef void(^BLEDisconnectBlock)(CBPeripheral *peripheral);

@interface TTLockHelper : NSObject<TTSDKDelegate>

+ (instancetype)shareInstance;

@property (strong, nonatomic) TTLock *TTObject;
@property (strong, nonatomic)  Key * currentKey;


+ (void)connectKey:(Key *)key connectBlock:(BLEConnectBlock)connectBloc;
+ (void)disconnectKey:(Key *)key disConnectBlock:(BLEDisconnectBlock)disConnectBlock;
+ (void)unlock:(Key *)key unlockBlock:(BLEBlock)unlockBlock;
+ (void)lock:(Key *)key lockBlock:(BLEBlock)lockBlock;

+ (void)setLockTime:(Key*)key complition:(BLEBlock)complition;
/* 读取开锁记录 */
+ (void)pullUnlockRecord:(Key *)key complition:(BLEBlock)complition;
+ (void)resetEkey:(Key *)key complition:(BLEBlock)complition;
+ (void)resetKeyboardPassword:(Key *)key complition:(BLEBlock)complition;
+ (void)resetLock:(Key *)key  complition:(BLEBlock)complition;
+ (void)adminDeleteOneKeyboardPassword:(NSString *)deletePs key:(Key *)key  complition:(BLEBlock)complition;
//自定义（添加）一个密码
+ (void)customKeyboardPwd:(NSString *)newKeyboardPwd
                startDate:(NSDate*)startDate
                  endDate:(NSDate*)endDate
                      key:(Key *)key
               complition:(BLEBlock)complition;
//修改密码
+ (void)modifyKeyboardPassword:(NSString *)pwd
                      toNewPwd:(NSString *)newPwd
                     startDate:(NSDate*)startDate
                       endDate:(NSDate*)endDate
                           key:(Key *)key
                    complition:(BLEBlock)complition;
//设置管理员键盘密码
+ (void)setAdminKeyboardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition;
//设置管理员删除密码
+ (void)setAdminDeleteKeyBoardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition;
//操作IC卡 指纹或手环 闭锁时间 屏幕是否显示密码
+  (void)configLockPeripheralDevType:(ConfigDevType)devType
                           startDate:(NSDate*)startDate
                             endDate:(NSDate*)endDate
                          optionType:(OprationType)optionType
                           devNumber:(NSString *)devNumber
                         lockingTime:(int)lockingTime
                              isShow:(BOOL)isShow
                                 key:(Key *)key
                          complition:(BLEBlock)complition;
//读取键盘密码列表
+ (void)getPwdListWithKey:(Key *)key
               complition:(BLEBlock)complition;

//读取新密码方案参数（约定数、映射数、删除日期）
+ (void)getPasswordDataWithKey:(Key *)key
                    complition:(BLEBlock)complition;

//获取锁时间
+ (void)getLockTimeWithKey:(Key *)key
                complition:(BLEBlock)complition;
//获取锁版本信息
+ (void)getDeviceInfoWithKey:(Key *)key
                  complition:(BLEBlock)complition;



@end

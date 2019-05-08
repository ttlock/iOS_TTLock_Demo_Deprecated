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
    KKBLE_CONNECT_NONE_TARGET,
    KKBLE_CONNECT_REFUSED,
    KKBLE_CONNECT_TIMEOUT,
    KKBLE_CONNECT_TURNOFF,
    KKBLE_CONNECT_SUCCESS,
    KKBLE_CONNECTED_INSTANTLY_DISCONNECT,
    KKBLE_RENTER_DATED,
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
+ (void)pullUnlockRecord:(Key *)key complition:(BLEBlock)complition;
+ (void)resetEkey:(Key *)key complition:(BLEBlock)complition;
+ (void)resetKeyboardPassword:(Key *)key complition:(BLEBlock)complition;
+ (void)resetLock:(Key *)key  complition:(BLEBlock)complition;
+ (void)adminDeleteOneKeyboardPassword:(NSString *)deletePs key:(Key *)key  complition:(BLEBlock)complition;

+ (void)customKeyboardPwd:(NSString *)newKeyboardPwd
                startDate:(NSDate*)startDate
                  endDate:(NSDate*)endDate
                      key:(Key *)key
               complition:(BLEBlock)complition;

+ (void)modifyKeyboardPassword:(NSString *)pwd
                      toNewPwd:(NSString *)newPwd
                     startDate:(NSDate*)startDate
                       endDate:(NSDate*)endDate
                           key:(Key *)key
                    complition:(BLEBlock)complition;
//Set Admin Passcode
+ (void)setAdminKeyboardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition;
//Set Erase Passcode
+ (void)setAdminDeleteKeyBoardPassword:(NSString *)keyboardPs key:(Key *)key complition:(BLEBlock)complition;
//Operate IC /Fingerprint/Wristband/Locking Time/ Whether the input password is displayed on the screen
+  (void)configLockPeripheralDevType:(ConfigDevType)devType
                           startDate:(NSDate*)startDate
                             endDate:(NSDate*)endDate
                          optionType:(OprationType)optionType
                           devNumber:(NSString *)devNumber
                         lockingTime:(int)lockingTime
                              isShow:(BOOL)isShow
                                 key:(Key *)key
                          complition:(BLEBlock)complition;

+ (void)getPwdListWithKey:(Key *)key
               complition:(BLEBlock)complition;


+ (void)getPasswordDataWithKey:(Key *)key
                    complition:(BLEBlock)complition;


+ (void)getLockTimeWithKey:(Key *)key
                complition:(BLEBlock)complition;

+ (void)getDeviceInfoWithKey:(Key *)key
                  complition:(BLEBlock)complition;



@end

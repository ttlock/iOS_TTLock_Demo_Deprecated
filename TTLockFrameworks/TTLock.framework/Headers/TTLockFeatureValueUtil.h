//
//  TTLockFeatureValue.h
//  TTLock
//
//  Created by 王娟娟 on 2020/2/24.
//  Copyright © 2020 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TTLockFeatureValue) {
    TTLockFeatureValuePasscode = 0,
    TTLockFeatureValueICCard = 1,
    TTLockFeatureValueFingerprint = 2,
    TTLockFeatureValueWristband = 3,
    TTLockFeatureValueAutoLock = 4,
    TTLockFeatureValueDeletePasscode = 5,
    TTLockFeatureValueManagePasscode = 7,
    TTLockFeatureValueLocking = 8,
    TTLockFeatureValuePasscodeVisible = 9,
    TTLockFeatureValueGatewayUnlock = 10,
    TTLockFeatureValueLockFreeze = 11,
    TTLockFeatureValueCyclePassword = 12,
    TTLockFeatureValueDoorSensor = 13,
    TTLockFeatureValueRemoteUnlockSwicth = 14,
    TTLockFeatureValueAudioSwitch = 15,
    TTLockFeatureValueNBIoT = 16,
    TTLockFeatureValueGetAdminPasscode = 18,
    TTLockFeatureValueHotelCard = 19,
    TTLockFeatureValueNoClock = 20,
    TTLockFeatureValueNoBroadcastInNormal = 21,
    TTLockFeatureValuePassageMode = 22,
    TTLockFeatureValueTurnOffAutoLock = 23,
    TTLockFeatureValueWirelessKeypad = 24,
    TTLockFeatureValueLight = 25,
    TTLockFeatureValueHotelCardBlacklist = 26,
    TTLockFeatureValueIdentityCard = 27,
    TTLockFeatureValueTamperAlert = 28,
    TTLockFeatureValueResetButton = 29,
    TTLockFeatureValuePrivacyLock = 30,
    TTLockFeatureValueDeadLock = 32,
    TTLockFeatureValueCycleCardOrFingerprint = 34,
	TTLockFeatureValueFingerVein = 37,
	
};

@interface TTLockFeatureValueUtil : NSObject

+ (BOOL)lockFeatureValue:(NSString *)featureValue suportFunction:(TTLockFeatureValue)function;

@end


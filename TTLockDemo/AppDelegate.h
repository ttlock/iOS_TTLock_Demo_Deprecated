//
//  AppDelegate.h
//
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"
/*!
 @class
 @abstract App代理类
*/
@interface AppDelegate : UIResponder <UIApplicationDelegate,TTSDKDelegate>
{
    
   
    UIAlertView * alertView;
    
}

@property (nonatomic,assign) BOOL isAddPsw;

@property (strong, nonatomic)  Key * currentKey;

@property (strong,nonatomic) Key *currentUsedKey;

@property (strong, nonatomic)  CBPeripheral * currentPeripheral;
/*!
 @property
 @abstract 程序窗口
*/
@property (strong, nonatomic) UIWindow *window;

/*!
 @property
 @abstract 通通锁类
*/
@property (strong, nonatomic) TTLockLock* TTObject;
//@property (nonatomic) BOOL isCalibationLockDate;








@end


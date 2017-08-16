//
//  Define.h
//  TTLockDemo
//
//  Created by wjjxx on 16/9/2.
//  Copyright © 2016年 wjj. All rights reserved.
//

#ifndef Define_h
#define Define_h


#define TTLockURL @"https://api.ttlock.com.cn/v3"
#define TTAppkey  @"7946f0d923934a61baefb3303de4d132"
#define TTAppSecret @"56d9721abbc3d22a58452c24131a5554"



#define DEBUG_UTILS YES

#define TTRedirectUri @"http://www.sciener.cn"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define LS(localized) NSLocalizedString(localized, nil)

#define NET_REQUEST_ERROR_NO_DATA -1001
#define NET_REQUEST_ERROR_wrong_backup_ps -2005

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define COMMON_BLUE_COLOR RGB(0,185,255)
#define COMMON_FONT_BLACK_COLOR RGB(29,29,38)
#define COMMON_FONT_GRAY_COLOR RGB(178,178,178)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define StrongSelf(strongSelf)  __strong typeof(weakSelf) strongSelf = weakSelf
#define TTWindow [UIApplication sharedApplication].keyWindow
#define TTAppdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
/*!
 @enum
 @abstract 时效密码类型
 @constant TIME_PS_GROUP_DAY_1D = 1 1天
 @constant TIME_PS_GROUP_DAY_2D = 1 2天
 @constant TIME_PS_GROUP_DAY_3D = 1 3天
 @constant TIME_PS_GROUP_DAY_4D = 1 4天
 @constant TIME_PS_GROUP_DAY_5D = 1 5天
 @constant TIME_PS_GROUP_DAY_6D = 1 6天
 @constant TIME_PS_GROUP_DAY_7D = 1 7天
 @constant TIME_PS_GROUP_DAY_10M = 1 10分钟
 */
typedef enum {
    TIME_PS_GROUP_DAY_1D = 1,
    TIME_PS_GROUP_DAY_2D,
    TIME_PS_GROUP_DAY_3D,
    TIME_PS_GROUP_DAY_4D,
    TIME_PS_GROUP_DAY_5D,
    TIME_PS_GROUP_DAY_6D,
    TIME_PS_GROUP_DAY_7D,
    TIME_PS_GROUP_DAY_10M
} TimePsGroup;

#endif /* Define_h */

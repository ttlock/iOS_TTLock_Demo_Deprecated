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
#define TTLockLoginURL @"https://api.ttlock.com.cn"
#define TTAppkey  @"7946f0d923934a61baefb3303de4d132"
#define TTAppSecret @"56d9721abbc3d22a58452c24131a5554"
#define TTRedirectUri @"http://www.sciener.cn"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAVIGATIONBAR_HEIGHT 44.0
#define BAR_TOTAL_HEIGHT  (NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT)

#define LS(localized) NSLocalizedString(localized, nil)
#define NET_REQUEST_ERROR_NO_DATA -1001
#define DEFAULT_CONNECT_TIMEOUT  10

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define StrongSelf(strongSelf)  __strong typeof(weakSelf) strongSelf = weakSelf
#define TTWindow [UIApplication sharedApplication].keyWindow
#define TTAppdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


// rgb（Hex->decimal）
#define RGBFromHexadecimal(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGB_A(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define COMMON_BLUE_COLOR RGB(0,185,255)
#define COMMON_FONT_BLACK_COLOR RGB(29,29,38)
#define COMMON_FONT_GRAY_COLOR RGB(178,178,178)

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

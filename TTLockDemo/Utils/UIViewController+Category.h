//
//  UIViewController+Category.h
//
//  Created by wjjxx on 16/8/26.
//  Copyright © 2016年 谢元潮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"
@interface UIViewController (Category)


//计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

//根据日期获取是一周的第几天
- (NSInteger)orderDayFromDate:(NSDate*)inputDate;

- (void)showHUD:(NSString *)status;

- (void)showToast:(NSString *)status;

- (void)showHUDToWindow:(NSString *)status;

- (void)hideHUD;

- (void)showLockNotNearToast;

- (void)showLockOperateFailed;
@end

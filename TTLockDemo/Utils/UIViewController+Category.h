//
//  UIViewController+Category.h
//
//  Created by wjjxx on 16/8/26.
//  Copyright © 2016年 TTLock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"
@interface UIViewController (Category)


- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;


- (NSInteger)orderDayFromDate:(NSDate*)inputDate;

- (void)showHUD:(NSString *)status;

- (void)showToast:(NSString *)status;

- (void)showHUDToWindow:(NSString *)status;

- (void)hideHUD;

- (void)showLockNotNearToast;

- (void)showLockOperateFailed;
@end

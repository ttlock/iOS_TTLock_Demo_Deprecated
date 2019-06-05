//
//  UIViewController+Category.h
//
//  Created by wjjxx on 16/8/26.
//  Copyright © 2016年 TTLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)


- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

- (void)showHUD:(NSString *)status;

- (void)showToast:(NSString *)status;

- (void)showHUDToWindow:(NSString *)status;

- (void)hideHUD;

- (void)showLockNotNearToast;

- (void)showLockOperateFailed;

- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            placeholder:(NSString *)placeholder
                             completion:(void(^)(NSString *text))completion;

@end

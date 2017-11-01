//
//  SSToastHelper.h
//  Sciener
//
//  Created by 王娟娟 on 2017/7/24.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>

void async_main(dispatch_block_t block);
void async_global(dispatch_block_t block);
void sync_global(dispatch_block_t block);
void sync_main(dispatch_block_t block);

@interface SSToastHelper : NSObject

/**
 展示Toast 加载在Window上 允许交互

 @param status status description
 */
+ (void)showToastWithStatus:(NSString *)status;

/**
 展示Toast 加载在指定view  允许交互
 
 @param status status description
 @param containerView 加载到的view
 */
+ (void)showToastWithStatus:(NSString *)status containerView:(UIView*)containerView;
/**
  展示hud 加载在Window上  不允许交互

 @param status status description
 */
+ (void)showHUDToWindow:(NSString *)status;

/**
 展示hud 加载在指定view  覆盖的范围 不允许交互

 @param status status description
 @param containerView 加载到的view
 */
+ (void)showHUD:(NSString *)status containerView:(UIView*)containerView;
/**
 隐藏hud
 */
+ (void)hideHUD;


@end

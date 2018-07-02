//
//  SSToastHelper.h
//  Sciener
//
//  Created by WJJ on 2017/7/24.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>

void async_main(dispatch_block_t block);
void async_global(dispatch_block_t block);
void sync_global(dispatch_block_t block);
void sync_main(dispatch_block_t block);

@interface SSToastHelper : NSObject

+ (void)showToastWithStatus:(NSString *)status;

+ (void)showToastWithStatus:(NSString *)status containerView:(UIView*)containerView;

+ (void)showHUDToWindow:(NSString *)status;

+ (void)showHUD:(NSString *)status containerView:(UIView*)containerView;

+ (void)hideHUD;


@end

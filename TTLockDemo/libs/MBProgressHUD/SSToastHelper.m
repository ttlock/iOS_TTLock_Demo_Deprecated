//
//  SSToastHelper.m
//  Sciener
//
//  Created by 王娟娟 on 2017/7/24.
//  Copyright © 2017年 sciener. All rights reserved.
//

void async_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (block) {
            @autoreleasepool {
                block();
            }
        }
    });
}

void async_global(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        if (block) {
            @autoreleasepool {
                block();
            }
        }
    });
}
void sync_global(dispatch_block_t block) {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        if (block) {
            @autoreleasepool {
                block();
            }
        }
    });
}

void sync_main(dispatch_block_t block) {
    dispatch_sync(dispatch_get_main_queue(), ^(){
        if (block) {
            @autoreleasepool {
                block();
            }
        }
    });
}
#import "SSToastHelper.h"
#import "SSHUDHelper.h"

@implementation SSToastHelper
+ (void)showToastWithStatus:(NSString *)status{
    
    //加载到 uiwindow上
      async_main(^{
    [SSToastHelper showToastWithStatus:status containerView:TTWindow];
         });
    
}
+ (void)showToastWithStatus:(NSString *)status containerView:(UIView*)containerView{
    //如果提示语长度为0 就不显示
   
    
         async_main(^{
             if (status.length == 0) {
                   [[SSHUDHelper sharedInstance] dismiss];
                 return;
             }
             
             [[SSHUDHelper sharedInstance] dismiss];
             
             [SSHUDHelper sharedInstance].containerView = containerView;
             
             [SSHUDHelper sharedInstance].mode = MBProgressHUDModeText;
             
             [[SSHUDHelper sharedInstance]show:status];
         });

    
    //加载到
    
    
    
}
+ (void)showHUDToWindow:(NSString *)status{
    
    async_main(^{
    [SSToastHelper showHUD:status containerView:TTWindow];
      });
    
}

+ (void)showHUD:(NSString *)status containerView:(UIView*)containerView{
    
    async_main(^{
       [[SSHUDHelper sharedInstance] dismiss];
        
        [SSHUDHelper sharedInstance].containerView = containerView;
        
        [SSHUDHelper sharedInstance].mode = MBProgressHUDModeIndeterminate;
        
        [[SSHUDHelper sharedInstance]show:status];

    });
    
    
}
+ (void)hideHUD{
    async_main(^{
          [[SSHUDHelper sharedInstance] dismiss];
    });
  
}



@end

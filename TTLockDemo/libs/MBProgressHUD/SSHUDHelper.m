//
//  HUDHelper.m
//  Sciener
//
//  Created by WJJ on 2017/8/6.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "SSHUDHelper.h"
#define kHudDuration 3

@interface SSHUDHelper()

@end

@implementation SSHUDHelper

+(SSHUDHelper *) sharedInstance {
    
    static SSHUDHelper * hUDHelper ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hUDHelper = [[SSHUDHelper alloc] init];
    });
    
    return hUDHelper;
    
}

- (void)show:(NSString*)status{

         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
         hud.contentColor = [UIColor whiteColor];
         hud.bezelView.color = RGB_A(0, 0, 0, 1);
         hud.label.numberOfLines = 0;
         hud.removeFromSuperViewOnHide = YES;
         hud.mode = self.mode;
         hud.label.text = status;
         
         if (hud.mode == MBProgressHUDModeText) {
             if ([self.containerView isKindOfClass:[UIWindow class]]) {
                 
                 [hud setOffset:CGPointMake(0, SCREEN_HEIGHT/2 - 100) ];
             }else{
                 [hud setOffset:CGPointMake(0, self.containerView.frame.size.height/2 - BAR_TOTAL_HEIGHT - 100) ];
             }
             hud.userInteractionEnabled = NO;
             [self dismiss:YES hud:hud afterDelay:kHudDuration];
         }else{
             if ([self.containerView isKindOfClass:[UIWindow class]]) {
                 
                 [hud setOffset:CGPointMake(0, -20) ];
             }else{
                 [hud setOffset:CGPointMake(0, -20 - BAR_TOTAL_HEIGHT) ];
             }
             hud.userInteractionEnabled = YES;
             
         }
}
- (void)dismiss{
    
        [MBProgressHUD hideHUDForView:self.containerView animated:NO];
         
}
- (void)dismiss:(BOOL)animated hud:(MBProgressHUD*)hud afterDelay:(NSTimeInterval)delay{
        async_main(^{
           [hud hideAnimated:animated afterDelay:delay];
        });
}
@end

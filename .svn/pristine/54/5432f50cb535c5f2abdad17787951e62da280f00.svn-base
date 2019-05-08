//
//  UIViewController+Category.m
//
//  Created by wjjxx on 16/8/26.
//  Copyright © 2016年 TTLock. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)


- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (NSInteger)orderDayFromDate:(NSDate*)inputDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return theComponents.weekday;
}
- (void)showHUD:(NSString *)status{
    [SSToastHelper showHUD:status containerView:self.view];
}
- (void)showToast:(NSString *)status{
    
    [SSToastHelper showToastWithStatus:status containerView:self.view];
    
}
- (void)showHUDToWindow:(NSString *)status{
 
    [SSToastHelper showHUD:status containerView:TTWindow];
}
- (void)hideHUD{
    [SSToastHelper hideHUD];
}
- (void)showLockNotNearToast{
       [self showToast:LS(@"make_sure_the_lock_nearby")];
}
- (void)showLockOperateFailed{
    [self showToast:LS(@"alter_Failed")];
    [TTLockHelper disconnectKey:TTLockHelperClass.currentKey disConnectBlock:nil];
    
}
@end

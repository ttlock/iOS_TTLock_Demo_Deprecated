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
- (void)presentAlertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                            placeholder:(NSString *)placeholder
                             completion:(void(^)(NSString *text))completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LS(@"words_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    __weak UIAlertController *weakAlertController = alertController;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:LS(@"words_sure_ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = weakAlertController.textFields.firstObject;
        completion(textField.text);
    }];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

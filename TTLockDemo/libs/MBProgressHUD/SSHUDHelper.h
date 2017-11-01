//
//  HUDHelper.h
//  Sciener
//
//  Created by 王娟娟 on 2017/8/6.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface SSHUDHelper : NSObject

+(SSHUDHelper *_Nullable) sharedInstance;

@property (strong, nonatomic, nullable) UIView *containerView;

@property (nonatomic,assign)MBProgressHUDMode mode;


- (void)show:(NSString*_Nullable)status;  //调用之前 一定要设置 containerView

- (void)dismiss;


@end

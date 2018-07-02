//
//  ChangeKeyDateViewController.h
//  TTLockDemo
//
//  Created by LXX on 17/2/15.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeKeyDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *beginTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@property (nonatomic, assign) NSTimeInterval startDate;
@property (nonatomic, assign) NSTimeInterval endDate;
@property (nonatomic, assign) NSInteger keyId;

@end

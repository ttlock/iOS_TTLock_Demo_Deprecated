//
//  FingerprintManagerVC.h
//  TTLockDemo
//
//  Created by wjjxx on 16/11/8.
//  Copyright © 2016年 wjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICAndFingerprintManagerVC : UIViewController

@property (nonatomic,assign)int type;//0 ic   1 Fingerprint
@property(nonatomic,strong)KeyModel *selectedKey;

@end

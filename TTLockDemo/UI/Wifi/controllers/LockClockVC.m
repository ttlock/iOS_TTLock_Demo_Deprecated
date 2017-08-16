//
//  LockClockVC.m
//  TTLockDemo
//
//  Created by wjjxx on 17/3/24.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "LockClockVC.h"
#import "PlugLockListModel.h"
#import "XYCUtils.h"
@interface LockClockVC ()
@property (nonatomic,strong) UILabel *timelabel;
@property (nonatomic,strong)UIButton *bottomBtn;
@end

@implementation LockClockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =LS(@"words_Lock_Clock");
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    //获取锁时间成功后 才能做其他操作
    [self getLockDate];
    // Do any additional setup after loading the view.
}
- (void)createView{
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, 120)];
    CGFloat fontSize = 18;
    _timelabel.font = [UIFont systemFontOfSize:fontSize];
    _timelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timelabel];
    
    _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 64+130, SCREEN_WIDTH-40, 40)];
    _bottomBtn.backgroundColor = COMMON_BLUE_COLOR;
    [_bottomBtn setTitle:LS(@"words_sure_ok") forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    [self.view addSubview:_bottomBtn];
    [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)getLockDate{
    [SVProgressHUD show];
    [NetworkHelper lockQueryDateWithLockId:self.model.lockId completion:^(id info, NSError *error) {
        if (!error ) {
            [SVProgressHUD dismiss];
             _timelabel.text = [XYCUtils  formateDate:[NSDate dateWithTimeIntervalSince1970:[info[@"date"] longLongValue]/1000]  format:@"yyyy.MM.dd HH:mm:ss"];
        }
    }];
 
}
- (void)bottomBtnClick{
    [SVProgressHUD show];
    [NetworkHelper lockUpdateDateWithLockId:self.model.lockId completion:^(id info, NSError *error) {
        if (!error ) {
            [SVProgressHUD dismiss];
            _timelabel.text = [XYCUtils  formateDate:[NSDate dateWithTimeIntervalSince1970:[info[@"date"] longLongValue]/1000] format:@"yyyy.MM.dd HH:mm:ss"];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

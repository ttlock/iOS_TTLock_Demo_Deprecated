//
//  V3SendPwdBaseVC.m
//  Sciener
//
//  Created by wjjxx on 16/7/6.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "V3SendPwdBaseVC.h"
#import "V3SendkeyBoardPwdVC.h"
#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"
@interface V3SendPwdBaseVC ()

@end

@implementation V3SendPwdBaseVC{
    
    SCNavTabBarController * _navTabBarController;
}



- (void)viewDidLoad {
  [super viewDidLoad];
   self.title = NSLocalizedString(@"send_keyboard_password", nil);
    V3SendkeyBoardPwdVC *view1=[[V3SendkeyBoardPwdVC alloc]init];
    view1.type= 0;
    view1.selectedKey = _selectedKey;
    view1.title=NSLocalizedString(@"forever_password",nil);
    V3SendkeyBoardPwdVC* view2=[[V3SendkeyBoardPwdVC alloc]init];
    view2.type=1;
    view2.selectedKey = _selectedKey;
    view2.title=NSLocalizedString(@"words_time_limit_key",nil);
    V3SendkeyBoardPwdVC* view3=[[V3SendkeyBoardPwdVC alloc]init];
    view3.type=2;
    view3.selectedKey = _selectedKey;
    view3.title=NSLocalizedString(@"alert_recycle",nil);
    
    V3SendkeyBoardPwdVC* view4=[[V3SendkeyBoardPwdVC alloc]init];
    view4.type=3;
    view4.selectedKey = _selectedKey;
    view4.title=NSLocalizedString(@"word_single",nil);
   
    // 初始化 navTabBarController，并初始化其子视图
    _navTabBarController = [[SCNavTabBarController alloc] init];
    _navTabBarController.navTabBarColor = [UIColor whiteColor];
    _navTabBarController.subViewControllers = @[view1, view2,view3,view4];
    _navTabBarController.navTabBarLineColor = COMMON_BLUE_COLOR;
    //    _navTabBarController.mainViewBounces
    [_navTabBarController addParentController:self];
    // Do any additional setup after loading the view.
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

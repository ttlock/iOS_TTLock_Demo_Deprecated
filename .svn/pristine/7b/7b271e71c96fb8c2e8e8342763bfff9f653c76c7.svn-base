//
//  LoginViewController.m
//  TTLockDemo
//
//  Created by wjjxx on 16/9/5.
//  Copyright © 2016年 wjj. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestService.h"
@interface LoginViewController ()

@end

@implementation LoginViewController{
    UITextField *_passField;
    UITextField *_phoneField;
    UIButton *_loginButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor  whiteColor];

    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(15, 64+10, SCREEN_WIDTH-15-15, 50)];
    _phoneField.placeholder = LS(@"input_email_or_account");
    _phoneField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneField];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 64+10+50, SCREEN_WIDTH-15-15, 1)];
    line.backgroundColor = COMMON_BLUE_COLOR;
    [self.view addSubview:line];

    _passField = [[UITextField alloc]initWithFrame:CGRectMake(15, 64+10+50+15, SCREEN_WIDTH-15-15, 50)];
    _passField.placeholder = LS(@"words_login_ps_holdspace");
    _passField.secureTextEntry = YES; //密码
    _passField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passField];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 64+10+50+15+50, SCREEN_WIDTH-15-15, 1)];
    line2.backgroundColor = COMMON_BLUE_COLOR;
    [self.view addSubview:line2];
    

    //    登陆界面
    _loginButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 64+10+50+15+50+30, 200, 50)];
    [_loginButton setTitle:LS(@"words_login") forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = COMMON_BLUE_COLOR;
    _loginButton.layer.cornerRadius = 50/2;
    [self.view addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)loginButtonClick{
    [self.view endEditing:YES];
    if (_phoneField.text.length == 0 || _passField.text.length == 0) {
        [self showToast:LS(@"alter_empty")];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block id ret;
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            
            ret = [RequestService loginWithUsername:_phoneField.text password:_passField.text];
            
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([ret isKindOfClass:[NSDictionary class]]) {
                [SettingHelper setAccessToken:ret[@"access_token"]];
                [SettingHelper setOpenID:ret[@"openid"]];
                [SettingHelper setExpireIn:ret[@"expires_in"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

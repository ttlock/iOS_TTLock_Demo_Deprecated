//
//  AddWifiViewController.m
//  Sciener
//
//  Created by wjjxx on 16/12/26.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "Gateway1AddViewController.h"
#import "PlugListViewController.h"
#import "NextAddWifiVC.h"

@interface Gateway1AddViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *baseWifiTableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString* SSID;
@property (nonatomic,strong)UITextField *wifiPwdTextField;
@property (nonatomic,strong)UITextField *userPwdTextField;
@end

@implementation Gateway1AddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"words_add_WiFiGateway");
    self.SSID = [TTLockGateway getSSID];
    [self createTableview];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:LS(@"words_sure_ok") style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationItemClicked)];
    
    // Do any additional setup after loading the view.
}

- (void)createTableview{
     self.dataArray = [NSMutableArray arrayWithArray:@[LS(@"words_wifi_name"),LS(@"words_wifi_password"),LS(@"words_account_password")]];
    self.baseWifiTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.baseWifiTableview.delegate = self;
    self.baseWifiTableview.dataSource = self;
    [self.view addSubview:self.baseWifiTableview];
    
}

#pragma mark ----- UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.SSID;
    }else if (indexPath.row == 1){
        _wifiPwdTextField = [self createTextFieldWithPlaceholder:LS(@"words_enter_wifi_password") cell:cell];
        
    }else if (indexPath.row == 2){
        _userPwdTextField = [self createTextFieldWithPlaceholder:LS(@"words_please_input_admin_password") cell:cell];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark rightNavigationItemClicked
- (void)rightNavigationItemClicked{
    [self.view endEditing:YES];
    if (_wifiPwdTextField.text.length > 0 && _userPwdTextField.text.length > 0) {
        
        NextAddWifiVC *VC= [NextAddWifiVC new];
        VC.SSID = self.SSID;
        VC.wifiPwd = _wifiPwdTextField.text;
        VC.uid =  [SettingHelper getUid];
        VC.userPwd =  _userPwdTextField.text;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }else{
        [self showToast:LS(@"alter_empty")];
    }
    
}



- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder cell:(UITableViewCell*)cell{
   UITextField * commonTextField = [[UITextField alloc]init];
    commonTextField.textAlignment = NSTextAlignmentRight;
    commonTextField.placeholder = placeholder;
    commonTextField.textColor = COMMON_FONT_BLACK_COLOR;
    [cell addSubview:commonTextField];
  
    
    [commonTextField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.right).offset(-15);
        make.left.equalTo(cell.textLabel.right).offset(6);
        make.centerY.equalTo(cell);
    }];

    return commonTextField;
}
- (void)dealloc{
     NSLog(@"******************* %@ dealloc *******************",NSStringFromClass([self class]));
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

//
//  Gateway2AddViewController.m
//  TTLockSourceCodeDemo
//
//  Created by Jinbo Lu on 2019/4/26.
//  Copyright © 2019 Sciener. All rights reserved.
//

#import "Gateway2AddViewController.h"
#import "RoundCornerButton.h"
#import "ChooseSSIDView.h"

@interface Gateway2AddViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *wifiName;
@property (nonatomic, strong) UITextField *wifiPasswordTextField;
@property (nonatomic, strong) UITextField *gatewayNameTextField;
@property (nonatomic, strong) UITextField *userPwdTextField;
@property (nonatomic, strong) NSString *uid;
@end

@implementation Gateway2AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wifiName = [TTLockGateway getSSID];
    [self _setupView];
    [self _loadData];
}

- (void)_setupView{
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)_loadData{
    _dataArray = @[@[@{LS(@"words_wifi_name"):@""},@{LS(@"words_wifi_password"):LS(@"words_enter_wifi_password")},@{LS(@"words_WiFiGateway_name"):LS(@"words_enter_wifi_name")},@{LS(@"words_account_password"):LS(@"Alter_Enter_your_App_account_password")}]];
}

- (void)nextButtonClick{

    if (_wifiName.length == 0
        || _wifiPasswordTextField.text.length == 0
        || _userPwdTextField.text.length == 0
        || _gatewayNameTextField.text == 0) {
        [self showToast:LS(@"alter_empty")];
        return;
    }
    [self showHUDToWindow:nil];
    NSMutableDictionary *ginfoDic = [NSMutableDictionary new];
    ginfoDic[@"SSID"] = _wifiName;
    ginfoDic[@"wifiPwd"] = _wifiPasswordTextField.text;
    ginfoDic[@"uid"] = [SettingHelper getUid];
    ginfoDic[@"userPwd"] = _userPwdTextField.text;
    ginfoDic[@"gatewayName"]= _gatewayNameTextField.text;
    [TTLockGateway initializeGatewayWithInfoDic:ginfoDic block:^(TTSystemInfoModel *systemInfoModel, TTGatewayStatus status) {
        
#warning todo
        if (status == TTGatewayNotConnect || status == TTGatewayDisconnect) {
            [self notConnect];
            return ;
        }
        if (status == TTGatewaySuccess) {
            [TTLockGateway disconnectGatewayWithGatewayMac:self.gatewayMac block:nil];
             [self isUploadSuccess:systemInfoModel];
            return;
        }
        if (status == TTGatewayWrongSSID) {
            [self showToast:LS(@"words_Choose_WiFi")];
            return;
        }
        if (status == TTGatewayWrongSSID) {
            [self showToast:LS(@"tint_Bad_WiFi_name")];
            return;
        }
         [self showToast:LS(@"alter_Failed")];
    }];
  
}
- (void)notConnect{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
     [self showToast:LS(@"hint_make_sure_the_gateway_is_in_adding_status")];
}
- (void)isUploadSuccess:(TTSystemInfoModel *)systemInfoModel{
    [self showHUDToWindow:nil];
    [NetworkHelper isInitSuccessWithGatewayNetMac:self.gatewayMac completion:^(id info, NSError *error) {
        if (error) {
            return ;
        }
        [NetworkHelper gatewayuploadDetailWithGatewayId:info[@"gatewayId"] modelNum:systemInfoModel.modelNum hardwareRevision:systemInfoModel.hardwareRevision firmwareRevision:systemInfoModel.firmwareRevision networkName:_wifiName completion:^(id info, NSError *error) {
            if (error) {
             
                return ;
            }
            
            [self showToast:LS(@"alter_Succeed")];
            [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 5 ] animated:YES];
            
        }];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = [_dataArray[indexPath.section][indexPath.row] allKeys].firstObject;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    if (indexPath.row == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text  = _wifiName;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (_wifiPasswordTextField == nil) {
            _wifiPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            _wifiPasswordTextField.textAlignment = NSTextAlignmentRight;
            _wifiPasswordTextField.keyboardType = UIKeyboardTypeAlphabet;
            _wifiPasswordTextField.placeholder = [_dataArray[indexPath.section][indexPath.row] allValues].firstObject;
        }
        cell.accessoryView = _wifiPasswordTextField;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2){
        if (_gatewayNameTextField == nil) {
            _gatewayNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            _gatewayNameTextField.textAlignment = NSTextAlignmentRight;
            _gatewayNameTextField.keyboardType = UIKeyboardTypeDefault;
            _gatewayNameTextField.placeholder = [_dataArray[indexPath.section][indexPath.row] allValues].firstObject;
        }
        
        cell.accessoryView = _gatewayNameTextField;
    }
    if (indexPath.section == 0 && indexPath.row == 3){
        if (_userPwdTextField == nil) {
            _userPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            _userPwdTextField.textAlignment = NSTextAlignmentRight;
            _userPwdTextField.keyboardType = UIKeyboardTypeDefault;
            _userPwdTextField.placeholder = [_dataArray[indexPath.section][indexPath.row] allValues].firstObject;
        }
        
        cell.accessoryView = _userPwdTextField;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
    line.backgroundColor = RGB(200, 200, 200);
    [footerView addSubview:line];
    
    RoundCornerButton *footButton = [RoundCornerButton buttonWithTitle:LS(@"words_next") cornerRadius:4 borderWidth:0.5];
    footButton.frame = CGRectMake(20, 50, tableView.frame.size.width - 20 * 2, 50);
    [footButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:footButton];
    
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChooseSSIDView *SSIDview = [[ChooseSSIDView alloc]init];
        [TTLockGateway  scanWiFiByGatewayWithBlock:^(BOOL isFinished, NSArray *WiFiArr, TTGatewayStatus status) {
            if (status == TTGatewayNotConnect || status == TTGatewayDisconnect ) {
                [self notConnect];
                [SSIDview dismiss];
                return ;
            }
            
            if (WiFiArr.count > 0) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:WiFiArr];
                if (isFinished == YES) {
                    SSIDview.testActivityIndicator.hidden = YES;
                }
                SSIDview.ssidArr = [NSArray arrayWithArray:arr];
                [SSIDview.ssidTableView reloadData];
                
            }
        }];
        WS(weakSelf);
        SSIDview.chooseSSIDBlock = ^(NSString *SSID) {
            weakSelf.wifiName = SSID;
            [weakSelf.tableView reloadData];
        };
    }
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

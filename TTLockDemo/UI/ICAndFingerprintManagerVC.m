//
//  FingerprintManagerVC.m
//  TTLockDemo
//
//  Created by wjjxx on 16/11/8.
//  Copyright © 2016年 wjj. All rights reserved.
//

#import "ICAndFingerprintManagerVC.h"
#import "DBHelper.h"
#import "AppDelegate.h"
#import "OnFoundDeviceModel.h"
@interface ICAndFingerprintManagerVC ()<UITableViewDelegate,UITableViewDataSource,TTSDKDelegate>

@end

@implementation ICAndFingerprintManagerVC{
    NSArray *_dataArray;
    UITableView *_tableView;
    NSString *_Number;
    AppDelegate * delegate;
    int  fingerprintOprationType; //操作类型
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    fingerprintOprationType = -1;
    TTObjectTTLockHelper.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    TTObjectTTLockHelper.delegate = TTLockHelperClass;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _type == 0?@"IC卡操作":@"指纹操作";
    _dataArray = _type == 0? @[@"清空IC卡",@"添加IC卡",@"删除IC卡",@"修改IC卡",@"查询IC卡"]:@[@"清空指纹",@"添加指纹",@"删除指纹",@"修改指纹",@"查询指纹"];
    _Number = _type == 0? [SettingHelper getCurrentICNumber]:[SettingHelper getCurrentFingerprintNumber];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view  addSubview:_tableView];
    UIView *view = [[UIView alloc]init];
    [_tableView setTableFooterView:view];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 1 || indexPath.row == 2 ||indexPath.row == 3) {
        cell.detailTextLabel.text = _Number;
    }
    cell.textLabel.text = _dataArray[indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showHUD:nil];
    switch (indexPath.row) {
        case 0:{
            fingerprintOprationType = OprationTypeClear;
        }break;
        case 1:{
            fingerprintOprationType = OprationTypeAdd;
        }break;
        case 2:{
            fingerprintOprationType = OprationTypeDelete;
        }break;
        case 3:{
            fingerprintOprationType = OprationTypeModify;
        }break;
        case 4:{
            fingerprintOprationType = OprationTypeQuery;
        }break;
        default:
            break;
    }
    [TTObjectTTLockHelper connectPeripheralWithLockMac:_selectedKey.lockMac.length ? _selectedKey.lockMac : _selectedKey.lockName];
    async_main(^{
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:DEFAULT_CONNECT_TIMEOUT];
    });
}

- (void)connectTimeOut{
    [self showToast:LS(@"make_sure_the_lock_nearby")];
    [TTLockHelper disconnectKey:_selectedKey disConnectBlock:nil];
    
    
}
#pragma mark ---- ttsdk
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic{
    OnFoundDeviceModel *deviceModel = [[OnFoundDeviceModel alloc] initOnFoundDeviceModelWithDic:infoDic];
    if (fingerprintOprationType != -1) {
        if ([deviceModel.mac isEqualToString:_selectedKey.lockMac]) {
            if (_selectedKey.peripheralUUIDStr.length == 0) {
                _selectedKey.peripheralUUIDStr = deviceModel.peripheral.identifier.UUIDString;
                [[DBHelper sharedInstance]update];
            }
            [[TTLock sharedInstance] connect:deviceModel.peripheral];
        }
    }

}


- (void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString *)lockName{
   //先停止扫描
    [[TTLock sharedInstance] stopBTDeviceScan];
    if (_type == 0) {
         [[TTLock sharedInstance] operate_type:fingerprintOprationType adminPS:_selectedKey.adminPwd lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr ICNumber:_Number  startDate:[NSDate dateWithTimeIntervalSinceNow:1000] endDate:[NSDate dateWithTimeIntervalSinceNow:10000] unlockFlag:_selectedKey.lockFlagPos timezoneRawOffset:_selectedKey.timezoneRawOffset];
        
    }else{
      [[TTLock sharedInstance] operateFingerprint_type:fingerprintOprationType adminPS:_selectedKey.adminPwd lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr FingerprintNumber:_Number  startDate:[NSDate dateWithTimeIntervalSinceNow:1000] endDate:[NSDate dateWithTimeIntervalSinceNow:10000] unlockFlag:_selectedKey.lockFlagPos timezoneRawOffset:_selectedKey.timezoneRawOffset];
    }
    fingerprintOprationType = -1;
}
#pragma mark----------- 指纹
- (void)onAddFingerprintWithState:(AddFingerprintState)state fingerprintNumber:(NSString *)fingerprintNumber{
    _Number = fingerprintNumber;
    [SettingHelper setCurrentFingerprintNumber:fingerprintNumber];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    [self showToast:[NSString stringWithFormat:@"%ld %@",(long)state,fingerprintNumber]];
  
   
}
- (void)onDeleteFingerprint{
    _Number = @"";
    [SettingHelper setCurrentFingerprintNumber:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
   [self showToast:@"删除成功"];

}
- (void)onClearFingerprint{
    _Number = @"";
    [SettingHelper setCurrentFingerprintNumber:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    [self showToast:@"清空成功"];
}
-(void)onModifyFingerprint{
    [self showToast:@"修改成功"];

}
#pragma mark----------- ic
- (void)onAddICWithState:(AddICState)state ICNumber:(NSString *)ICNumber{
    _Number = ICNumber;
    [SettingHelper setCurrentICNumber:ICNumber];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    [self showToast:[NSString stringWithFormat:@"添加 状态%ld 卡号%@",(long)state,ICNumber]];

    NSLog(@"ICNumber  %@",ICNumber);
}

- (void)onDeleteIC{
    _Number = @"";
    [SettingHelper setCurrentICNumber:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    [self showToast:@"删除成功"];
}
- (void)onModifyIC{
   [self showToast:@"修改成功"];
}
- (void)onClearIC{
    _Number = @"";
    [SettingHelper setCurrentICNumber:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    [self showToast:@"清空成功"];
}
#pragma mark ---- 公用
- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr{
    if (![_selectedKey.lockVersion hasPrefix:@"10.1"]) {
        if (LockOpenRecordStr.length > 0) {
            [self showToast:LockOpenRecordStr];
        }else{
            [self showToast:@"读取成功 没有记录"];
        }
    }
}
- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    [self showToast:errorMsg];
}
- (void)onBTDisconnect_peripheral:(CBPeripheral *)periphera{
    [TTObjectTTLockHelper startBTDeviceScan:YES];
    NSLog(@"断开蓝牙 disconnect");
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

//
//  SSUpdateViewController.m
//  Sciener
//
//  Created by wjjxx on 17/1/23.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "TTUpgradeViewController.h"
#import "FirmwareUpdateModel.h"
#import "DBHelper.h"

@interface TTUpgradeViewController ()<TTSDKDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UIButton * bottomBtn;
@end

@implementation TTUpgradeViewController{
    FirmwareUpdateModel *_updateModel;
    FirmwareUpdateModel *_tempUpdateModel;
    UILabel *_versionTitleLabel;
    UILabel *_versionDetailLabel;
    //是否要连接蓝牙
    NSString *_v3AllowMac;
    CBPeripheral * _peripheral;
    
    BOOL isGetDeviceInfo;
    BOOL isgetChara;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [TTLockLock sharedInstance].delegate = self;
    [[TTLockLock sharedInstance] startBTDeviceScan];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
    
    //如果正在升级 必须先pauseUpgrade 再stopUpgrade 才能退出升级模式
    [[TTLockDFU shareInstance] pauseUpgrade];
    [[TTLockDFU shareInstance]stopUpgrade];
    
    if (_peripheral.state == CBPeripheralStateConnected){
        [[TTLockLock sharedInstance] disconnect:_peripheral];
        [TTLockLock sharedInstance].delegate = TTAppdelegate;
    }else{
        [TTLockLock sharedInstance].delegate = TTAppdelegate;
        [[TTLockLock sharedInstance] startBTDeviceScan];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = LS(@"Words_Lock_Upgrade");
    [SVProgressHUD show];
    [self createView];
    [self lockUpgradeCheck];
    
    
    // Do any additional setup after loading the view.
}
- (void)lockUpgradeCheck{
    
    [NetworkHelper lockUpgradeCheckWithLockId:self.selectedKey.lockId  completion:^(id info, NSError *error) {
        if (error == nil && [info isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD dismiss];
            
            _updateModel =  [[FirmwareUpdateModel alloc]initWithDictionary:info error:nil];
            //是否需要升级：0-否，1-是，2-未知
            if (_updateModel.needUpgrade.intValue == 0) {
                _versionTitleLabel.text = LS(@"Words_No_updates");
                _versionDetailLabel.text = [NSString stringWithFormat:@"%@%@",LS(@"Words_Version"),_updateModel.firmwareRevision];
                [self.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
                self.bottomBtn.hidden = NO;
                self.bottomBtn.tag = 101;
            }else if (_updateModel.needUpgrade.intValue == 1){
                
                self.bottomBtn.hidden = NO;
                self.bottomBtn.tag = 100;
                _versionTitleLabel.text = LS(@"Words_New_version_found");
                _versionDetailLabel.text = [NSString stringWithFormat:@"%@%@",LS(@"Words_Version"),_updateModel.version];
                [self.bottomBtn setTitle:LS(@"Words_Upgrade") forState:UIControlStateNormal];
            }else {
                
                self.bottomBtn.hidden = NO;
                self.bottomBtn.tag = 101;
                _versionTitleLabel.text = LS(@"Words_Unknown_lock_version");
                [self.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
            }
        }
    }];
    
}
- (void)createView{
    
    
    _versionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 50, SCREEN_WIDTH, 30)];
    CGFloat fontSize = 20;
    _versionTitleLabel.font = [UIFont systemFontOfSize:fontSize];
    _versionTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_versionTitleLabel];
    
    _versionDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 80, SCREEN_WIDTH, 30)];
    _versionDetailLabel.font = [UIFont systemFontOfSize:15];
    _versionDetailLabel.textAlignment = NSTextAlignmentCenter;
    _versionDetailLabel.textColor = COMMON_FONT_GRAY_COLOR;
    [self.view addSubview:_versionDetailLabel];
    
    UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 64 + 130, SCREEN_WIDTH - 40 , 40)];
    bottomButton.backgroundColor = COMMON_BLUE_COLOR;
    [self.view addSubview:bottomButton];
    [bottomButton addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.hidden = YES;
    self.bottomBtn = bottomButton;
    
    
}

#pragma mark ----- 点击底部按钮  不管是哪种情况 都是先读取锁内信息
- (void)bottomBtnClick{
    
    
    if (self.bottomBtn.tag == 100) {
        [SVProgressHUD show];
        TTLockDFU *dfu = [TTLockDFU shareInstance];
        
        WS(weakSelf);
        [dfu upgradeFirmwareWithClientId:TTAppkey accessToken:[SettingHelper getAccessToken] lockId:self.selectedKey.lockId module:_updateModel.modelNum hardwareRevision:_updateModel.hardwareRevision firmwareRevision:_updateModel.firmwareRevision adminPwd:self.selectedKey.adminPwd lockKey:self.selectedKey.lockKey aesKeyStr:self.selectedKey.aesKeyStr lockFlagPos:self.selectedKey.lockFlagPos timezoneRawOffset:self.selectedKey.timezoneRawOffset ttLockObject:[TTLockLock sharedInstance] lockMac:self.selectedKey.lockMac peripheralUUIDStr:self.selectedKey.peripheralUUIDStr successBlock:^(UpgradeOpration type, NSInteger process) {
            
            if (type == UpgradeOprationSuccess ) {
                
                //把代理给到这个类
                [TTLockLock sharedInstance].delegate = weakSelf;
                
                weakSelf.bottomBtn.tag = 101;
                [SVProgressHUD showSuccessWithStatus:@"升级成功"];
                 [weakSelf.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
                
                return ;
            }
            
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"successBlock type%ld process%ld",(long)type,(long)process]];
            
        } failBlock:^(UpgradeOpration type, UpgradeErrorCode code) {
            
            if (code == UpgradeErrorCodeNotSupportCommandEnterUpgradeState) {
                [weakSelf passcodeUpgrade];
                return ;
            }
            if (code == UpgradeErrorCodeOutOfMemory) {
                NSLog(@"内存已满，继续升级");
                return;
            }
            weakSelf.bottomBtn.tag = 105;
            [weakSelf.bottomBtn setTitle:@"重试" forState:UIControlStateNormal];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"failBlock UpgradeOpration%ld UpgradeErrorCode%ld ",(long)type,(long)code]];
        }];
    }
    
    if (self.bottomBtn.tag == 101) {
        //如果是未知 那就去获取锁里的相关的数据
        if ([BLEHelper getBlueState]) {
            [SVProgressHUD show];
            
            isGetDeviceInfo = YES;
            _v3AllowMac = _selectedKey.lockMac;
            if (_selectedKey.peripheralUUIDStr.length != 0 ) {
                [BLEHelper connectLock:_selectedKey];
            }
        }
        
    }
    
    if (self.bottomBtn.tag == 105) {
         [SVProgressHUD show];
        //重试
        [[TTLockDFU shareInstance] retry];
    }
}
- (void)passcodeUpgrade{
    NSString *decodePwd = _selectedKey.noKeyPwd;
    NSString *pwd = [NSString stringWithFormat:@"*7539#%@#",decodePwd];
    NSMutableString *message1 = [NSMutableString stringWithString:@""];
    [message1 appendString:LS(@"Tint_Enter_the_following_password_on_the_lock")];
    [message1 appendString:@"\n"];
    [message1 appendString:pwd];
    [message1 appendString:@"\n"];
    [message1 appendString:LS(@"Tint_Enter_Click_the_Upgrade_to_start_upgrading")];
    UIAlertView *alterview = [ [UIAlertView alloc]initWithTitle:message1 message:nil delegate:self cancelButtonTitle:LS(@"words_cancel") otherButtonTitles:LS(@"Words_Upgrading"), nil];
    [alterview show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [[TTLockDFU shareInstance] upgradeLock];
    }
}
#pragma mark - TTSDKDelegate

- (void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)rssi lockName:(NSString *)lockName mac:(NSString *)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory{
    
    if ( [_v3AllowMac isEqualToString:mac] && _v3AllowMac != nil) {
        
        if (_selectedKey.peripheralUUIDStr.length == 0) {
            _selectedKey.peripheralUUIDStr = peripheral.identifier.UUIDString;
            [[DBHelper sharedInstance] update];
        }
        [[TTLockLock sharedInstance] connect:peripheral];
        
    }
}

- (void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString *)lockName{
    
    _v3AllowMac = nil;
    _peripheral = peripheral;
    [[TTLockLock sharedInstance] stopBTDeviceScan];
    if (isgetChara) {
        [[TTLockLock sharedInstance] getDeviceCharacteristic_lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr];
    }
    else if (isGetDeviceInfo) {
        [[TTLockLock sharedInstance] getDeviceInfo_lockKey:_selectedKey.lockKey  aesKey:_selectedKey.aesKeyStr];
        isGetDeviceInfo = NO;
    }else{
        [[TTLockLock sharedInstance] upgradeFirmware_adminPS:_selectedKey.adminPwd lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr unlockFlag:_selectedKey.lockFlagPos];
    }
    
    
}
#pragma mark ---- 获取锁基本信息成功
- (void)onGetDeviceInfo:(NSDictionary *)infoDic{
    
    NSString *modelNum = infoDic[@"1"];
    NSString *hardwareRevision = infoDic[@"2"];
    NSString *firmwareRevision = infoDic[@"3"];
    _tempUpdateModel = [FirmwareUpdateModel new];
    _tempUpdateModel.modelNum = modelNum;
    _tempUpdateModel.hardwareRevision = hardwareRevision;
    _tempUpdateModel.firmwareRevision = firmwareRevision;
    [[TTLockLock sharedInstance] getDeviceCharacteristic_lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr];
    
}

- (void)onBTDisconnect_peripheral:(CBPeripheral *)periphera{
    NSLog(@"断开连接");
    [[TTLockLock sharedInstance] startBTDeviceScan];
    
}
- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    [SVProgressHUD dismiss];
    if (_peripheral.state == CBPeripheralStateConnected){
        [[TTLockLock sharedInstance] disconnect:_peripheral];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
    
}


- (void)onGetDeviceCharacteristic:(int)characteristic{
    
    [self initDataWithModelNum:_tempUpdateModel.modelNum hardwareRevision:_tempUpdateModel.hardwareRevision firmwareRevision:_tempUpdateModel.firmwareRevision characteristic:characteristic];;
    
}
- (void)initDataWithModelNum:(NSString*)modelNum
            hardwareRevision:(NSString*)hardwareRevision
            firmwareRevision:(NSString*)firmwareRevision
              characteristic:(int)characteristic{
    
    [NetworkHelper lockUpgradeRecheckWithLockId:self.selectedKey.lockId modelNum:modelNum hardwareRevision:hardwareRevision firmwareRevision:modelNum specialValue:characteristic completion:^(id info, NSError *error) {
        if (error == nil && [info isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD dismiss];
            
            _updateModel =  [[FirmwareUpdateModel alloc]initWithDictionary:info error:nil];
            //是否需要升级：0-否，1-是，2-未知
        if (_updateModel.needUpgrade.intValue == 0) {
            _versionTitleLabel.text = LS(@"Words_No_updates");
            _versionDetailLabel.text = [NSString stringWithFormat:@"%@%@",LS(@"Words_Version"),_updateModel.firmwareRevision];
            [self.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
            self.bottomBtn.hidden = NO;
            self.bottomBtn.tag = 101;
        }else if (_updateModel.needUpgrade.intValue == 1){
                
                self.bottomBtn.hidden = NO;
                self.bottomBtn.tag = 100;
                _versionTitleLabel.text = LS(@"Words_New_version_found");
                _versionDetailLabel.text = [NSString stringWithFormat:@"%@%@",LS(@"Words_Version"),_updateModel.version];
                [self.bottomBtn setTitle:LS(@"Words_Upgrade") forState:UIControlStateNormal];
            }else {
                
                self.bottomBtn.hidden = NO;
                self.bottomBtn.tag = 101;
                _versionTitleLabel.text = LS(@"Words_Unknown_lock_version");
                [self.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
            }
        }
    }];
    
    
}
- (void)dealloc{
    NSLog(@"  TTUpgradeViewController dealloc ");
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

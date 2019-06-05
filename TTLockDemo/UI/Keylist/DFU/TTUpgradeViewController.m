//
//  SSUpdateViewController.m
//  Sciener
//
//  Created by wjjxx on 17/1/23.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "TTUpgradeViewController.h"
#import "FirmwareUpdateModel.h"
@interface TTUpgradeViewController ()<TTSDKDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UIButton * bottomBtn;
@end

@implementation TTUpgradeViewController{
    FirmwareUpdateModel *_updateModel;
    FirmwareUpdateModel *_tempUpdateModel;
    UILabel *_versionTitleLabel;
    UILabel *_versionDetailLabel;
    CBPeripheral * _peripheral;
    BOOL isGetDeviceInfo;
    BOOL isgetChara;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [TTLock sharedInstance].delegate = self;
    [[TTLock sharedInstance] startBTDeviceScan:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
    
 //Exit and upgrade
    [[TTLockDFU shareInstance] pauseUpgrade];
    [[TTLockDFU shareInstance]stopUpgrade];
    
    TTObjectTTLockHelper.delegate = TTLockHelperClass;
    [TTLockHelper disconnectKey:_selectedKey disConnectBlock:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = LS(@"Words_Lock_Upgrade");
    [self showHUD:nil];
    [self createView];
    [self lockUpgradeCheck];
    
    
    // Do any additional setup after loading the view.
}
- (void)lockUpgradeCheck{
    
    [NetworkHelper lockUpgradeCheckWithLockId:self.selectedKey.lockId  completion:^(id info, NSError *error) {
        if (error == nil && [info isKindOfClass:[NSDictionary class]]) {
            [self hideHUD];
            
            _updateModel = [FirmwareUpdateModel mj_objectWithKeyValues:info];
            // Is upgrading available: 0-No, 1-Yes, 2-Unknown
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

#pragma mark ----- Click the bottom button to read the information in the lock
- (void)bottomBtnClick{
    
    
    if (self.bottomBtn.tag == 100) {
        [self showHUD:nil];
        TTLockDFU *dfu = [TTLockDFU shareInstance];
        
        WS(weakSelf);
        [dfu upgradeFirmwareWithClientId:TTAppkey accessToken:[SettingHelper getAccessToken] lockId:self.selectedKey.lockId module:_updateModel.modelNum hardwareRevision:_updateModel.hardwareRevision firmwareRevision:_updateModel.firmwareRevision adminPwd:self.selectedKey.adminPwd lockKey:self.selectedKey.lockKey aesKeyStr:self.selectedKey.aesKeyStr lockFlagPos:self.selectedKey.lockFlagPos timezoneRawOffset:self.selectedKey.timezoneRawOffset ttLockObject:[TTLock sharedInstance] lockMac:self.selectedKey.lockMac peripheralUUIDStr:self.selectedKey.peripheralUUIDStr successBlock:^(UpgradeOpration type, NSInteger process) {
            
            if (type == UpgradeOprationSuccess ) {
                
                //把代理给到这个类
                [TTLock sharedInstance].delegate = weakSelf;
                
                weakSelf.bottomBtn.tag = 101;
                [weakSelf showToast:LS(@"Alter_Upgrade_succeeded")];
                 [weakSelf.bottomBtn setTitle:LS(@"Words_Check_for_updates") forState:UIControlStateNormal];
                
                return ;
            }
            
            [weakSelf showHUD:[NSString stringWithFormat:@"successBlock type%ld process%ld",(long)type,(long)process]];
            
        } failBlock:^(UpgradeOpration type, UpgradeErrorCode code) {
            
            if (code == UpgradeErrorCodeNotSupportCommandEnterUpgradeState) {
                [weakSelf passcodeUpgrade];
                return ;
            }
            if (code == UpgradeErrorCodeOutOfMemory) {
                NSLog(@"UpgradeErrorCodeOutOfMemory");
                return;
            }
            weakSelf.bottomBtn.tag = 105;
            [weakSelf.bottomBtn setTitle:LS(@"Tint_Retry") forState:UIControlStateNormal];
            [weakSelf showToast:[NSString stringWithFormat:@"failBlock UpgradeOpration%ld UpgradeErrorCode%ld ",(long)type,(long)code]];
        }];
    }
    if (self.bottomBtn.tag == 101) {

        if ([BlueToothHelper getBlueState]) {
            [self showHUDToWindow:nil];
            isGetDeviceInfo = YES;
  
            [TTObjectTTLockHelper connectPeripheralWithLockMac:_selectedKey.lockMac.length ? _selectedKey.lockMac : _selectedKey.lockAlias];
            
        }
        
    }
    
    if (self.bottomBtn.tag == 105) {
         [self showHUD:nil];
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

- (void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString *)lockName{
    

    _peripheral = peripheral;
    [[TTLock sharedInstance] stopBTDeviceScan];
    if (isgetChara) {
        [[TTLock sharedInstance] getDeviceCharacteristic_lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr];
    }
    else if (isGetDeviceInfo) {
        [[TTLock sharedInstance] getDeviceInfo_lockKey:_selectedKey.lockKey  aesKey:_selectedKey.aesKeyStr];
        isGetDeviceInfo = NO;
    }else{
        [[TTLock sharedInstance] upgradeFirmware_adminPS:_selectedKey.adminPwd lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr unlockFlag:_selectedKey.lockFlagPos];
    }
    
    
}
- (void)onGetDeviceInfo:(NSDictionary *)infoDic{
    
    NSString *modelNum = infoDic[@"1"];
    NSString *hardwareRevision = infoDic[@"2"];
    NSString *firmwareRevision = infoDic[@"3"];
    _tempUpdateModel = [FirmwareUpdateModel new];
    _tempUpdateModel.modelNum = modelNum;
    _tempUpdateModel.hardwareRevision = hardwareRevision;
    _tempUpdateModel.firmwareRevision = firmwareRevision;
    [[TTLock sharedInstance] getDeviceCharacteristic_lockKey:_selectedKey.lockKey aesKey:_selectedKey.aesKeyStr];
    
}

- (void)onBTDisconnect_peripheral:(CBPeripheral *)periphera{
    [[TTLock sharedInstance] startBTDeviceScan:NO];
    
}
- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    [self hideHUD];
    if (_peripheral.state == CBPeripheralStateConnected){
        [[TTLock sharedInstance] disconnect:_peripheral];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
    
}


- (void)onGetDeviceCharacteristic:(long long)characteristic{
    
    [self initDataWithModelNum:_tempUpdateModel.modelNum hardwareRevision:_tempUpdateModel.hardwareRevision firmwareRevision:_tempUpdateModel.firmwareRevision characteristic:characteristic];;
    
}
- (void)initDataWithModelNum:(NSString*)modelNum
            hardwareRevision:(NSString*)hardwareRevision
            firmwareRevision:(NSString*)firmwareRevision
              characteristic:(long long)characteristic{
    
    [NetworkHelper lockUpgradeRecheckWithLockId:self.selectedKey.lockId modelNum:modelNum hardwareRevision:hardwareRevision firmwareRevision:@"0.0" specialValue:characteristic completion:^(id info, NSError *error) {
        if (error == nil && [info isKindOfClass:[NSDictionary class]]) {
            [self hideHUD];
            
            _updateModel =  [FirmwareUpdateModel mj_objectWithKeyValues:info];

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

//
//  KeyDetailViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "KeyDetailViewController.h"
#import "DateHelper.h"
#import "RequestService.h"
#import "Define.h"
#import "SendKeyBoardPsViewController.h"
#import "SendKpsViewController.h"
#import "V3SendPwdBaseVC.h"
#import "ICAndFingerprintManagerVC.h"
#import "TTUpgradeViewController.h"
#import "KeypadTableViewController.h"

@interface KeyDetailViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *indexpath;
@end


@implementation KeyDetailViewController


@synthesize selectedKey;

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = selectedKey.lockAlias;
    self.tableView.sectionHeaderHeight = 20;
    [self createDataArray];

}
- (void)createDataArray{

    self.dataArray = [NSMutableArray array];
    NSArray *arraySection0 = [NSArray array];
    NSArray *arraySection1 = [NSArray array];
    NSArray *arraySection3 = [NSArray array];
    NSArray *arraySection4 = [NSArray array];
    NSArray *arraySection5 = [NSArray array];
    if (selectedKey.isAdmin == YES) {
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            
            arraySection0 = @[LS(@"words_Adjust_Clock"),LS(@"words_click_to_unlock"),LS(@"Tint_Reading_operating_logs"),LS(@"words_Get_lock_time"),LS(@"resetting_ekey"),LS(@"reset_keyboard_password"),LS(@"title_nokeyps_manage")];
            arraySection1 = @[LS(@"send_ekey"),LS(@"words_Get_a_passcode")];
            arraySection3 = @[LS(@"Words_Lock_Upgrade")];
            arraySection4 = @[LS(@"words_IC_card_operation"),LS(@"words_Fingerprint_operation")];
            arraySection5 = @[LS(@"words_Wireless_Keypad")];
        }else{
            arraySection0 = @[LS(@"words_Adjust_Clock"),LS(@"resetting_ekey"),LS(@"reset_keyboard_password"),LS(@"title_nokeyps_manage"),LS(@"alert_set_delete_ps")];
            arraySection1 = @[LS(@"send_ekey"),LS(@"words_Get_a_passcode")];
        }
        
    }else{
       
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            arraySection0 = @[LS(@"words_Adjust_Clock"),LS(@"words_click_to_unlock")];
        }else{
           arraySection0 = @[LS(@"words_Adjust_Clock")];
        }
    }
     [self.dataArray addObject:arraySection0];
     [self.dataArray addObject:arraySection1];
     [self.dataArray addObject:arraySection3];
     [self.dataArray addObject:arraySection4];
     [self.dataArray addObject:arraySection5];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArray[section] count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"keydetailcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row ==6 ){
          cell.detailTextLabel.text = selectedKey.noKeyPwd;
            
        }else if (indexPath.row == 7){
          cell.detailTextLabel.text = selectedKey.deletePwd;
        }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 1) {
        if (![BlueToothHelper getBlueState]) {
            return;
        }
    }
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    [self showHUDToWindow:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper setLockTime:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                        
                    }];

                }break;
                case 1:{
                    [self showHUDToWindow:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper unlock:self.selectedKey unlockBlock:^(id info, BOOL succeed) {
                            if (succeed) {
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                        
                        
                    }];
                    
                }break;
                case 2:{
                    [self showHUDToWindow:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper pullUnlockRecord:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                if ([info[@"LockOpenRecordStr"] length] == 0) {
                                     [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
                                }else{
                                    [self showToast: info[@"LockOpenRecordStr"]];
                                }
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                    }];
                }break;
                case 3:{
                    [self showHUDToWindow:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper getLockTimeWithKey:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                        
                    }];
                }break;
                case 4:{
                  
                    if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                        [self showHUDToWindow:nil];
                    else
                        [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];
                    
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper resetEkey:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                            
                                self.selectedKey.lockFlagPos = self.selectedKey.lockFlagPos + 1;
                                [NetworkHelper resetKey:self.selectedKey.lockFlagPos lockId:self.selectedKey.lockId completion:^(id info, NSError *error) {
                                    if (!error) {
                                        [SSToastHelper showToastWithStatus:LS(@"alter_Succeed")];
                                        return ;
                                    }
                                      [SSToastHelper showToastWithStatus:LS(@"alter_Failed")];
                                }];
                                
                                
                                return ;
                            }
                            [self showLockOperateFailed];
                            
                        }];
                    }];
                        
                }break;
                case 5:{
                    if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                        [self showHUDToWindow:nil];
                    else
                        [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];
                    
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper resetKeyboardPassword:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                self.selectedKey.timestamp =  info[@"timestamp"] ;
                                self.selectedKey.pwdInfo =  info[@"pwdInfo"] ;
                                
                                [NetworkHelper resetKeyboardPwd: self.selectedKey.pwdInfo lockId:self.selectedKey.lockId timestamp: self.selectedKey.timestamp completion:^(id info, NSError *error) {
                                    if (!error) {
                                        
                                       [SSToastHelper showToastWithStatus:LS(@"alter_Succeed") ];
                                    } else {
                                        [SSToastHelper showToastWithStatus:LS(@"alter_Failed")];
                                    }
                                }];
                                
                                return ;
                            }
                            [self showLockOperateFailed];
                            
                        }];
                    }];
                    
                    break;
                }break;
                case 6:{
                    [self presentAlertControllerWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?LS(@"4_9_digits"):LS(@"7_9_digits") message:nil placeholder:nil completion:^(NSString *text) {
                        if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                            [self showHUDToWindow:nil];
                        else
                            [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];
                        
                        [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                            if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                                [self showLockNotNearToast];
                                return;
                            }
                            [TTLockHelper setAdminKeyboardPassword:text key:self.selectedKey complition:^(id info, BOOL succeed) {
                                if (succeed) {
                                    async_main(^{
                                        selectedKey.noKeyPwd = text;
                                        [self.tableView reloadData];
                                    });
                                    return ;
                                }
                                [self showLockOperateFailed];
                            }];
                            
                        }];
                    }];
                    
                }break;
                case 7:{
                    [self presentAlertControllerWithTitle:LS(@"7_9_digits") message:nil placeholder:nil completion:^(NSString *text) {
                        if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                            [self showHUDToWindow:nil];
                        else
                            [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];
                        
                        [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                            if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                                [self showLockNotNearToast];
                                return;
                            }
                            [TTLockHelper setAdminDeleteKeyBoardPassword:text key:self.selectedKey complition:^(id info, BOOL succeed) {
                                if (succeed) {
                                    async_main(^{
                                        selectedKey.deletePwd = text;
                                        
                                        [self.tableView reloadData];
                                    });
                                    return ;
                                }
                                [self showLockOperateFailed];
                            }];
                            
                        }];
                    }];
                    
                }break;
                default:
                    break;
            }
        } break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [self presentAlertControllerWithTitle:LS(@"tint_please_enter_the_receiver's_account") message:nil placeholder:nil completion:^(NSString *text) {
                        [self showHUD:nil];
                        //接收者的唯一name
                        NSString * receiver = text;
                        [NetworkHelper sendKey:selectedKey.lockId receiverUsername:receiver startDate:0 endDate:0 remarks:@"" completion:^(id info, NSError *error) {
                            [self hideHUD];
                            if (!error) {
                                [self showToast:LS(@"words_error_share_key_success")];

                            } else {
                                
                                  [self showToast:LS(@"single_word_fail")];
                                
                            }
                        }];
                    }];
                    
                }break;
                case 1:{
                    if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                        V3SendPwdBaseVC *v3VC = [[V3SendPwdBaseVC alloc]init];
                        v3VC.selectedKey = selectedKey;
                        [self.navigationController pushViewController:v3VC animated:YES];
                    }else if ([selectedKey.lockVersion hasPrefix:@"5.4"]){
                        SendKpsViewController *sendKeyBoard = [[SendKpsViewController alloc] init];
                        sendKeyBoard.selectedKey = selectedKey;
                        [self.navigationController pushViewController:sendKeyBoard animated:YES];
                    }else if ([selectedKey.lockVersion hasPrefix:@"5.1"]){
                        SendKeyBoardPsViewController *sendKeyBoard = [[SendKeyBoardPsViewController alloc] init];
                        sendKeyBoard.selectedKey = selectedKey;
                        [self.navigationController pushViewController:sendKeyBoard animated:YES];
                    }
                    
                }break;
                default:
                    break;
            }
        } break;
        case 2:{
            if (indexPath.row ==  0) {
                TTUpgradeViewController *vc = [TTUpgradeViewController new];
                vc.selectedKey = selectedKey;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }break;
        case 3:{
            if (indexPath.row == 0) {
                if([TTSpecialValueUtil isSupportIC:self.selectedKey.specialValue]){
                    ICAndFingerprintManagerVC *vc = [[ICAndFingerprintManagerVC alloc]init];
                    vc.selectedKey = selectedKey;
                    vc.type =  0;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                [self showToast:LS(@"Operation_not_supported")];
            }
            if (indexPath.row == 1) {
                
                if([TTSpecialValueUtil isSupportIC:self.selectedKey.specialValue]){
                    ICAndFingerprintManagerVC *vc = [[ICAndFingerprintManagerVC alloc]init];
                    vc.selectedKey = selectedKey;
                    vc.type = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                [self showToast:LS(@"Operation_not_supported")];
            }
        }break;
        case 4:{
            if ([TTSpecialValueUtil isSupportWirelessKeyboard:self.selectedKey.specialValue]) {
                
                KeypadTableViewController *vc = [[KeypadTableViewController alloc]init];
                vc.selectedKey = selectedKey;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            [self showToast:LS(@"Operation_not_supported")];
        }break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

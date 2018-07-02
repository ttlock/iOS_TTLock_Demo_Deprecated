//
//  KeyDetailViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "KeyDetailViewController.h"
#import "Key.h"
#import "KeyDetailCell.h"
#import "DBHelper.h"
#import "XYCUtils.h"
#import "AppDelegate.h"
#import "RequestService.h"
#import "Define.h"
#import "UnlockRecordsViewController.h"
#import "UserManageViewController.h"
#import "SendKeyBoardPsViewController.h"
#import "SendKpsViewController.h"
#import "TimePsSendedListVC.h"
#import "V3SendPwdBaseVC.h"
#import "ICAndFingerprintManagerVC.h"
#import "TTUpgradeViewController.h"
@interface KeyDetailViewController ()
{
    UIAlertView * alert4Test;
    UIAlertView *resetAlert;
    IBOutlet UIView * psPoolProgressView;
    IBOutlet UISlider * psPoolSlider;
    UITextField * backUpPs;
    AppDelegate *delegate;
    NSArray *_dataArray;
    UITextField *psField;
    NSString *_keyboardPwdVersion;
}
@property (nonatomic, strong) NSIndexPath *indexpath;
@end


#define TAG_SET_KEYBOARD_PS 1
#define TAG_SEND_EKEY 3
#define TAG_SET_KEYBOARD_PS_DELETE 4
#define TAG_BACK_UP_PS 6
#define TAG_AUTO_UNLOCK 7

#define TAG_SHEET_RESET_900_PS 8
#define TAG_RESET_EKEY 9
#define TAG_CHANGE_NAME 10
#define TAG_ALERT_AUTO_UNLOCK 11
#define TAG_ALERT_BACK_UP_PS 12

@implementation KeyDetailViewController

static KeyDetailViewController *KeyDetailViewInstance=nil;
@synthesize selectedKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
  
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = selectedKey.lockAlias;
    [customTableView reloadData];
    
    [super viewWillAppear:animated];
    
    if (![selectedKey isAdmin]) {
        
        customTableView.tableFooterView = NULL;
        
    }
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self createDataArray];
    [psPoolSlider setHidden:YES];
    [psPoolProgressView setHidden:YES];
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)createDataArray{

    self.title = selectedKey.lockAlias;
    if (selectedKey.isAdmin == YES) {
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            
            _dataArray = @[@[LS(@"resetting_ekey"),LS(@"reset_keyboard_password"),LS(@"words_Adjust_Clock"),LS(@"title_nokeyps_manage")],@[LS(@"send_ekey"),LS(@"change_lock_name"),LS(@"words_common_ekeys_of_lock"),LS(@"words_all_created_passcodes_of_a_lock"),LS(@"words_Get_a_passcode"),LS(@"words_unlock_records")],@[LS(@"words_click_to_unlock"),LS(@"Tint_Reading_operating_logs"),LS(@"words_Get_lock_time")],@[LS(@"Words_Lock_Upgrade"),LS(@"words_IC_card_operation"),LS(@"words_Fingerprint_operation")]];
        }else{
            _dataArray = @[@[LS(@"resetting_ekey"),LS(@"reset_keyboard_password"),LS(@"words_Adjust_Clock"),LS(@"title_nokeyps_manage"),LS(@"alert_set_delete_ps")],@[LS(@"send_ekey"),LS(@"change_lock_name"),LS(@"words_common_ekeys_of_lock"),LS(@"words_all_created_passcodes_of_a_lock"),LS(@"words_Get_a_passcode"),LS(@"words_unlock_records")]];
        }
        
    }else{
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            _dataArray = @[@[LS(@"words_Adjust_Clock")],@[],@[LS(@"words_click_to_unlock"),LS(@"Tint_Reading_operating_logs")]];
        }else{
            _dataArray = @[@[LS(@"words_Adjust_Clock")]];
        }
    }
    
   

}
- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"keydetailcell";
    
    KeyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KeyDetailCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }

    [cell.img_right_top setHidden:YES];
    [cell.slider setHidden:YES];
    [cell.label_right setTag:0];
    [cell.label_right setHidden:YES];
    [cell.switch_right setHidden:YES];
    
    cell.label_left.text = _dataArray[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row ==3 ){
                if (selectedKey.isAdmin) {
                    [cell.label_right setHidden:NO];
                    cell.label_right.text = selectedKey.noKeyPwd;
                }
                    
            }else if (indexPath.row == 4){
                if (selectedKey.isAdmin&&![selectedKey.lockVersion hasPrefix:@"5.3"]){
                    [cell.label_right setHidden:NO];
                    cell.label_right.text = selectedKey.deletePwd;
                }
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == 1) {
                [cell.label_right setHidden:NO];
                cell.label_right.text = _keyboardPwdVersion;
                cell.label_right.font = [UIFont systemFontOfSize:8];
                cell.label_right.numberOfLines = 0;
                    
            }

            break;
        }
    }
   
    return (UITableViewCell *) cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section != 1) {
         if (![BlueToothHelper getBlueState]) {
             return nil;
         }
    }
 
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    
                    if ([selectedKey isAdmin]) {
                      
                        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                      initWithTitle:LS(@"alert_After_resetting_the_ekey_all_the_ekeys_sent_will_be_unable_to_open_the_door")
                                                      delegate:self
                                                      cancelButtonTitle:LS(@"words_cancel")
                                                      destructiveButtonTitle:nil
                                                      otherButtonTitles:LS(@"words_reset"), nil];
                        [actionSheet showInView:self.view];
                        actionSheet.tag=TAG_RESET_EKEY;
                    }else{
                        
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


                    }
                   
                }break;
                case 1:{
       
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:LS(@"alert_After_reset_the_password_that_was_sent_to_the_user_before_that_will_fail")
                                                  delegate:self
                                                  cancelButtonTitle:LS(@"words_cancel")
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:LS(@"words_reset"), nil];
                    [actionSheet showInView:self.view];
                    actionSheet.tag = TAG_SHEET_RESET_900_PS;
                    
                    break;
                }break;
                case 2:{
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
                case 3:{
           
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?LS(@"4_9_digits"):LS(@"7_9_digits")
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                          otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                    alert.tag = TAG_SET_KEYBOARD_PS;
                    [alert show];
                   
  
                }break;
                case 4:{
  
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?LS(@"4_9_digits"):LS(@"7_9_digits")
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                          otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                    alert.tag = TAG_SET_KEYBOARD_PS_DELETE;
                    [alert show];

                }break;
                default:
                    break;
            }
        } break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    if ([selectedKey isAdmin]) {
                  
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LS(@"tint_please_enter_the_receiver's_account")
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:LS(@"words_cancel")
                                                              otherButtonTitles:LS(@"words_sure_ok"),nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        
                        alert.tag = TAG_SEND_EKEY;
                        [alert show];
                    }

                }break;
                
                case 1:{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LS(@"change_lock_name")
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:LS(@"words_cancel")
                                                          otherButtonTitles:LS(@"words_sure_ok"),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    alert.tag = TAG_CHANGE_NAME;
                    [alert show];

                }break;
                case 2:{
               
                    UserManageViewController * unlockRecord = [[UserManageViewController alloc]initWithNibName:@"UserManageViewController" bundle:nil];
                    unlockRecord.currentKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
                }break;
                case 3:{
                    TimePsSendedListVC *sendedList = [[TimePsSendedListVC alloc] initWithNibName:@"TimePsSendedListVC" bundle:nil];
                    sendedList.selectedKey = selectedKey;
                    [self.navigationController pushViewController:sendedList animated:YES];
                  
                }break;
                case 4:{
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
                case 5:{
         
                    UnlockRecordsViewController * unlockRecord = [[UnlockRecordsViewController alloc]initWithNibName:@"UnlockRecordsViewController" bundle:nil];
                    unlockRecord.selectedKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
  
                }break;
                default:
                    break;
            }
        } break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
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
                case 1:{
                          [self showHUDToWindow:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return;
                        }
                        [TTLockHelper pullUnlockRecord:self.selectedKey complition:^(id info, BOOL succeed) {
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
                        [TTLockHelper getLockTimeWithKey:self.selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                       
                    }];
                }break;
                default:
                    break;
            }
        } break;
    
        case 3:{
            if (indexPath.row ==  0) {
                TTUpgradeViewController *vc = [TTUpgradeViewController new];
                vc.selectedKey = selectedKey;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row == 1 || indexPath.row == 2) {
                ICAndFingerprintManagerVC *vc = [[ICAndFingerprintManagerVC alloc]init];
                vc.selectedKey = selectedKey;
                vc.type =(int) indexPath.row - 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }break;
        default:
            break;
    }
    
    return nil;
}

-(void)alertView:(UIAlertView *)alertViewT clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 1) {
        
        switch (alertViewT.tag) {
                
            case TAG_SEND_EKEY:
            {
                [self showHUD:nil];
                //接收者的唯一name
                NSString * receiver = [alertViewT textFieldAtIndex:0].text;

              
                [NetworkHelper sendKey:selectedKey.lockId receiverUsername:receiver startDate:0 endDate:0 remarks:@"" completion:^(id info, NSError *error) {
                    [self hideHUD];
                    if (!error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LS(@"words_error_share_key_success") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LS(@"words_sure_ok"), nil];
                        [alert show];

                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LS(@"single_word_fail") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LS(@"words_sure_ok"), nil];
                        [alert show];

                    }
                }];
                
                break;
            }
            case TAG_SET_KEYBOARD_PS:
            {
    
                NSString * ps = [alertViewT textFieldAtIndex:0].text;
                
                if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                    [self showHUDToWindow:nil];
                else
                    [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];
            
                [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                    if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                         [self showLockNotNearToast];
                        return;
                    }
                    [TTLockHelper setAdminKeyboardPassword:ps key:self.selectedKey complition:^(id info, BOOL succeed) {
                        if (succeed) {
                            async_main(^{
                                selectedKey.noKeyPwd = ps;
                                [[DBHelper sharedInstance] update];
                                
                                [customTableView reloadData];
                            });
                            return ;
                        }
                        [self showLockOperateFailed];
                    }];
                    
                }];

                break;
            }
            case TAG_SET_KEYBOARD_PS_DELETE:
            {
                NSString * ps = [alertViewT textFieldAtIndex:0].text;
            
                if ([selectedKey.lockVersion hasPrefix:@"5.3"])
                    [self showHUDToWindow:nil];
                else
                    [self showHUDToWindow:LS(@"alter_touch_the_number_panel")];

                [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                    if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                        [self showLockNotNearToast];
                        return;
                    }
                    [TTLockHelper setAdminDeleteKeyBoardPassword:ps key:self.selectedKey complition:^(id info, BOOL succeed) {
                        if (succeed) {
                            async_main(^{
                                selectedKey.deletePwd = ps;
                                [[DBHelper sharedInstance] update];
                                
                                [customTableView reloadData];
                            });
                            return ;
                        }
                        [self showLockOperateFailed];
                    }];
                    
                }];
                
                break;
            }
            case TAG_CHANGE_NAME:
            {
  
                if ([alertViewT textFieldAtIndex:0].text.length>0) {

                    if (!psPoolProgressView) {
                        psPoolProgressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
                        psPoolProgressView.alpha = 0.4;
                        psPoolProgressView.backgroundColor = [UIColor grayColor];
                        [self.view addSubview:psPoolProgressView];
                    }
                    
                    [psPoolProgressView setHidden:NO];
                    [self showHUD:nil];
                    [NetworkHelper rename:[alertViewT textFieldAtIndex:0].text lockId:selectedKey.lockId completion:^(id info, NSError *error) {
                        [self hideHUD];
                        if (!error) {
                            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil
                                                                            message:LS(@"words_change_deadline_success")
                                                                           delegate:self
                                                                  cancelButtonTitle:LS(@"words_sure_ok")
                                                                  otherButtonTitles:nil];
                            [alertV show];
                            
                            selectedKey.lockAlias = [alertViewT textFieldAtIndex:0].text;
                            [[DBHelper sharedInstance] update];
                            [customTableView reloadData];

                        } else{
                            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil
                                                                            message:LS(@"words_change_deadline_fail")
                                                                           delegate:self
                                                                  cancelButtonTitle:LS(@"words_sure_ok")
                                                                  otherButtonTitles:nil];
                            [alertV show];

                        }
                    }];
                    
                }
                break;
                
            }
                
            default:
                break;
        }
        
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (actionSheet.tag) {
        case TAG_RESET_EKEY:
        {
            if (!buttonIndex) {
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
                           
                            return ;
                        }
                        [self showLockOperateFailed];
                        
                    }];
                }];
            }
            break;
        }
        case TAG_SHEET_RESET_900_PS:
        {
            if (!buttonIndex) {
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
                            return ;
                        }
                        [self showLockOperateFailed];
                        
                    }];
                }];
            }
            break;

            break;
        }
        default:
            break;
    }
    
}

@end

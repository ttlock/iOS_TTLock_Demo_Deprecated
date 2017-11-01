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
        
        //防止在ios7上出现，tableview被nav遮住的情况
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
    if(selectedKey.lockAlias){
        
        self.title = selectedKey.lockAlias;
    }else{
        
        self.title=@"Key Detail";
    }
    
    if (selectedKey.isAdmin == YES) {
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
           
            //@"IC卡操作",@"指纹操作",@"设置锁里的手环key"] 要根据特征值  TTSpecialValueUtil
            
            _dataArray = @[@[@"重置电子钥匙",@"重置键盘密码",@"校准时钟",@"设置管理员开门密码"],@[@"发送电子钥匙",@"键盘密码版本",@"修改锁名",@"锁的普通钥匙列表",@"获取锁的键盘密码列表",@"生成用户键盘密码",@"读取开锁记录"],@[@"点击开门",@"读取操作记录",@"获取锁时间"],@[@"锁升级",@"IC卡操作",@"指纹操作"]];
        }else{
            _dataArray = @[@[@"重置电子钥匙",@"重置键盘密码",@"校准时钟",@"设置管理员开门密码",@"设置管理员删除密码"],@[@"发送电子钥匙",@"键盘密码版本",@"修改锁名",@"锁的普通钥匙列表",@"获取锁的键盘密码列表",@"生成用户键盘密码",@"读取开锁记录"]];
        }
        
        [NetworkHelper getKeyboardPwdVersion:selectedKey.lockId completion:^(id info, NSError *error) {
            KeyboardPwdVersion *version = [KeyboardPwdVersion mj_objectWithKeyValues:info];
            if (version.keyboardPwdVersion == 0) {
                _keyboardPwdVersion = @"未知";
            }else if (version.keyboardPwdVersion == 1) {
                _keyboardPwdVersion = @"老版900个键盘密码";
            }else if (version.keyboardPwdVersion == 2) {
                _keyboardPwdVersion = @"新版300个键盘密码，最长180天";
            }else if (version.keyboardPwdVersion == 3) {
                _keyboardPwdVersion = @"新版300个键盘密码，支持月份和永久";
            }else if (version.keyboardPwdVersion == 4) {
                _keyboardPwdVersion = @"三代锁的密码版本，支持限时和循环等类型";
            }
            [customTableView reloadData];
        }];
        
        
    }else{
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            _dataArray = @[@[@"校准时钟"],@[@"键盘密码版本"],@[@"点击开门",@"读取操作记录",@"获取锁时间"]];
        }else{
            _dataArray = @[@[@"校准时钟"],@[@"键盘密码版本"]];
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
            if (indexPath.row ==2 ){
                if (selectedKey.isAdmin) {
                    [cell.label_right setHidden:NO];
                    cell.label_right.text = selectedKey.noKeyPwd;
                }
                    
            }else if (indexPath.row == 3){
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
    //判断蓝牙是否打开
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
                        //重置电子钥匙
                        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                      initWithTitle:@"重置电子钥匙，重置电子钥匙之后，所有发送的电子钥匙都将无法开门。是否重置？"
                                                      delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                      destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"重置", nil), nil];
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
                    //初始化900密码
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:@"重置用户密码，选择重置之后，之前发送给用户的密码都将失效。是否重置？"
                                                  delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"重置", nil];
                    [actionSheet showInView:self.view];
                    actionSheet.tag = TAG_SHEET_RESET_900_PS;
                    
                    break;
                }break;
                case 2:{
                    //设置键盘密码
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?@"请输入键盘密码(4到8位数字)":@"请输入键盘密码(7到10位数字)"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                          otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                    alert.tag = TAG_SET_KEYBOARD_PS;
                    [alert show];
 
                }break;
                case 3:{
                    //管理员删除密码
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?@"请输入管理员删除密码(4到8位数字)":@"请输入管理员删除密码(7到10位数字)"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                              otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                        alert.tag = TAG_SET_KEYBOARD_PS_DELETE;
                        [alert show];
  
                }break;
                case 4:{
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
                default:
                    break;
            }
        } break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    if ([selectedKey isAdmin]) {
                        //发送电子钥匙
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入接收方用户名(方便起见，这里默认发送电子钥匙的有效期是从当前时间开始,20分钟内有效)"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                              otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        
                        alert.tag = TAG_SEND_EKEY;
                        [alert show];
                    }

                }break;
                case 1:{
                    if (selectedKey.isAdmin == NO) {
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"修改锁名", nil)
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                              otherButtonTitles:NSLocalizedString(@"确定", nil),nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        
                        alert.tag = TAG_CHANGE_NAME;
                        [alert show];
                    }
                }break;
                case 2:{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"修改锁名", nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                          otherButtonTitles:NSLocalizedString(@"确定", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    alert.tag = TAG_CHANGE_NAME;
                    [alert show];

                }break;
                case 3:{
                    //所用户
                    UserManageViewController * unlockRecord = [[UserManageViewController alloc]initWithNibName:@"UserManageViewController" bundle:nil];
                    unlockRecord.currentKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
                }break;
                case 4:{
                    TimePsSendedListVC *sendedList = [[TimePsSendedListVC alloc] initWithNibName:@"TimePsSendedListVC" bundle:nil];
                    sendedList.selectedKey = selectedKey;
                    [self.navigationController pushViewController:sendedList animated:YES];
                  
                }break;
                case 5:{
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
                case 6:{
                    //读取开锁记录
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
                
                NSString *startDate = [XYCUtils GetCurrentTimeInMillisecond];
                long long startDateInt = startDate.longLongValue;
                NSString * endDate = [NSString stringWithFormat:@"%lli",startDateInt+20*60*60*1000];
                
                [NetworkHelper sendKey:selectedKey.lockId receiverUsername:receiver startDate:startDate endDate:endDate remarks:@"" completion:^(id info, NSError *error) {
                    [self hideHUD];
                    if (!error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送电子钥匙成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];

                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送电子钥匙失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];

                    }
                }];
                
                break;
            }
            case TAG_SET_KEYBOARD_PS:
            {
                //设置管理员密码
                
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
                
                //设置管理员删除密码
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
                //修改锁名
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
                            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                                            message:@"修改成功"
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                                  otherButtonTitles:nil];
                            [alertV show];
                            
                            selectedKey.lockAlias = [alertViewT textFieldAtIndex:0].text;
                            [[DBHelper sharedInstance] update];
                            [customTableView reloadData];

                        } else{
                            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                                            message:@"修改失败，请稍后再试"
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
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

//
//  KeyDetailViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "KeyDetailViewController.h"
#import "Key.h"
#import "MyLog.h"
#import "KeyDetailCell.h"
#import "DBHelper.h"
#import "XYCUtils.h"
#import "AppDelegate.h"
#import "RequestService.h"
#import "Define.h"
#import "UnlockRecordsViewController.h"
#import "UserManageViewController.h"
#import "ProgressHUD.h"
#import "SendKeyBoardPsViewController.h"
#import "SendKpsViewController.h"
#import "TimePsSendedListVC.h"
#import "SVProgressHUD.h"
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

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    extern BOOL keydetailAppear;
    keydetailAppear = YES;
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
            
            _dataArray = @[@[@"重置电子钥匙",@"重置键盘密码",@"设置管理员开门密码",@"校准时钟"],@[@"发送电子钥匙",@"键盘密码版本",@"修改锁名",@"锁的普通钥匙列表",@"获取锁的键盘密码列表",@"生成用户键盘密码",@"读取开锁记录"],@[@"点击开门",@"读取操作记录",@"获取锁时间",@"获取设备特征"],@[@"锁升级",@"IC卡操作",@"指纹操作",@"设置锁里的手环key"]];
        }else{
            _dataArray = @[@[@"重置电子钥匙",@"重置键盘密码",@"设置管理员开门密码",@"设置管理员删除密码",@"校准时钟"],@[@"发送电子钥匙",@"键盘密码版本",@"修改锁名",@"锁的普通钥匙列表",@"获取锁的键盘密码列表",@"生成用户键盘密码",@"读取开锁记录"]];
        }
        
    }else{
        if ([selectedKey.lockVersion hasPrefix:@"5.3"]){
            _dataArray = @[@[@"校准时钟"],@[@"键盘密码版本"],@[@"点击开门",@"读取操作记录",@"获取锁时间"]];
        }else{
            _dataArray = @[@[@"校准时钟"],@[@"键盘密码版本"]];
        }
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
         if (![BLEHelper getBlueState]) {
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
                                                      initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?@"重置电子钥匙，重置电子钥匙之后，所有发送的电子钥匙都将无法开门。是否重置？":NSLocalizedString(@"重置电子钥匙，重置电子钥匙之后，所有发送的电子钥匙都将无法开门。这需要您触摸唤醒锁键盘以完成操作。是否重置？", nil)
                                                      delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                      destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"重置", nil), nil];
                        //展示actionSheet
                        //        [actionSheet showFromTabBar:self.tabBarController.tabBar];
                        [actionSheet showInView:self.view];
                        actionSheet.tag=TAG_RESET_EKEY;
                    }else{
                        
                        extern BOOL calibrationPress;
                        calibrationPress = YES;
                        if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                            [self v3ReadyConnect];
                        }else{
                            [self createTouchPanel];
                        }

                    }
                   
                }break;
                case 1:{
                    //初始化900密码
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?@"重置用户密码，选择重置之后，之前发送给用户的密码都将失效。是否重置？":@"重置用户密码，选择重置之后，之前发送给用户的密码都将失效。这需要您触摸唤醒锁键盘以完成操作。是否重置？"
                                                  delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"重置", nil];
                    //展示actionSheet
                    //        [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
                    if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                        extern BOOL calibrationPress;
                        calibrationPress = YES;
                       
                        [self v3ReadyConnect];

                    }else{
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[selectedKey.lockVersion hasPrefix:@"5.3"]?@"请输入管理员删除密码(4到8位数字)":@"请输入管理员删除密码(7到10位数字)"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                              otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                        alert.tag = TAG_SET_KEYBOARD_PS_DELETE;
                        [alert show];
                    }
                    
                }break;
                case 4:{
                    extern BOOL calibrationPress;
                    calibrationPress = YES;
                   
                    if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                        [self v3ReadyConnect];
                    }else{
                        [self createTouchPanel];
                    }
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
                    [self v3ReadyConnect];
                   
                }break;
                case 1:{
                    extern  BOOL isGetOperator;
                    isGetOperator = YES;
                    [self v3ReadyConnect];
                 
                }break;
                case 2:{
                    extern  BOOL isGetLockTime;
                    isGetLockTime = YES;
                    [self v3ReadyConnect];
                }break;
                case 3:{
                   
                    extern  BOOL isGetCharacteristic;
                    isGetCharacteristic = YES;
                    [self v3ReadyConnect];
              
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
            if (indexPath.row == 3) {
                extern NSString *wristbandKey;
                wristbandKey = @"654321";
                [self v3ReadyConnect];

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
                
                [ProgressHUD show:@"请稍候..."];
                
                //接收者的唯一name
                NSString * receiver = [alertViewT textFieldAtIndex:0].text;
                
                NSString *startDate = [XYCUtils GetCurrentTimeInMillisecond];
                long long startDateInt = startDate.longLongValue;
                NSString * endDate = [NSString stringWithFormat:@"%lli",startDateInt+20*60*60*1000];
                
                [NetworkHelper sendKey:selectedKey.lockId receiverUsername:receiver startDate:startDate endDate:endDate remarks:@"" completion:^(id info, NSError *error) {
                    [ProgressHUD dismiss];
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
                
                    selectedKey.noKeyPwdTmp = ps;
                    selectedKey.noKeyPwd = ps;
                    [[DBHelper sharedInstance] update];
                    
                    [customTableView reloadData];
                extern NSString *v3AllowMac;
                v3AllowMac = selectedKey.lockMac;
                if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                    [SVProgressHUD show];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    if (selectedKey.peripheralUUIDStr.length != 0 ) {
                        [BLEHelper connectLock:selectedKey];
                    }
                }else{
                    [self createTouchPanel];
                }

                    
                
                break;
            }
            case TAG_SET_KEYBOARD_PS_DELETE:
            {
                //设置管理员删除密码
                
                NSString * ps = [alertViewT textFieldAtIndex:0].text;
                
                    selectedKey.deletePwdTmp = ps;
                    selectedKey.deletePwd = ps;
                    [[DBHelper sharedInstance] update];
                    
                    [customTableView reloadData];
                
                extern NSString *v3AllowMac;
                v3AllowMac = selectedKey.lockMac;
                if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                    [SVProgressHUD show];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    if (selectedKey.peripheralUUIDStr.length != 0 ) {
                        [BLEHelper connectLock:selectedKey];
                    }
                }else{
                    [self createTouchPanel];
                }

                
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
                    [ProgressHUD show:NSLocalizedString(@"请稍候", nil)];
                    
                    
                    [NetworkHelper rename:[alertViewT textFieldAtIndex:0].text lockId:selectedKey.lockId completion:^(id info, NSError *error) {
                        [ProgressHUD dismiss];
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

- (void)createTouchPanel{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"请触摸唤醒锁键盘以完成操作"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (actionSheet.tag) {
        case TAG_RESET_EKEY:
        {
            if (!buttonIndex) {
                
                extern BOOL isInvalidFlagUpdated;;
                isInvalidFlagUpdated = YES;
                extern NSString *v3AllowMac;
                v3AllowMac = selectedKey.lockMac;
              
                if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                    [SVProgressHUD show];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    if (selectedKey.peripheralUUIDStr.length != 0 ) {
                        [BLEHelper connectLock:selectedKey];
                    }
                }else{
                    [self createTouchPanel];
                }
                
                
            }
            break;
        }
        case TAG_SHEET_RESET_900_PS:
        {
            if (!buttonIndex) {
                
                extern BOOL isInitPsPool;
                isInitPsPool = YES;
                extern NSString *v3AllowMac;
                v3AllowMac = selectedKey.lockMac;
                if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
                    [SVProgressHUD show];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    if (selectedKey.peripheralUUIDStr.length != 0 ) {
                        [BLEHelper connectLock:selectedKey];
                    }
                }else{
                    [self createTouchPanel];
                }
            }
            break;

            break;
        }
        default:
            break;
    }
    
}


- (void)v3ReadyConnect{
    extern NSString *v3AllowMac;
    v3AllowMac = selectedKey.lockMac;
}

@end

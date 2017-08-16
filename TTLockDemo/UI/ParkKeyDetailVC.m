//
//  ParkKeyDetailVC.m
//
//  Created by wjjxx on 16/8/25.
//  Copyright © 2016年 谢元潮. All rights reserved.
//

#import "ParkKeyDetailVC.h"
#import "UnlockRecordsViewController.h"
#import "UserManageViewController.h"
#import "KeyDetailCell.h"
#import "XYCUtils.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "RequestService.h"
#import "DBHelper.h"

#define TAG_CHANGE_NAME 10
#define TAG_SEND_EKEY 3
#define TAG_BACK_UP_PS 6
#define TAG_ALERT_BACK_UP_PS 12
@interface ParkKeyDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation ParkKeyDetailVC{
    UITableView *_tableView;
    NSArray *_dataArray;
    AppDelegate * delegate;
     UITextField * backUpPs;
}
@synthesize selectedKey;

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = selectedKey.lockAlias;
    self.automaticallyAdjustsScrollViewInsets = NO;
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)createTableView{
    //创建视图的数据源
    if ([selectedKey.userType isEqualToString:@"110301"]) {
      _dataArray = @[@[@"上升", @"下降"],@[@"备份钥匙",@"修改锁名",@"发送电子钥匙",@"锁用户",@"读取开锁记录"]];
    }else{
     _dataArray = @[@[@"上升",@"下降"],@[@"备份钥匙"]];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 20;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.switch_right.hidden = NO;
        [cell.switch_right setTag:TAG_BACK_UP_PS];
    }
    
    return (UITableViewCell *) cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    if ([BLEHelper getBlueState]) {
                        extern NSString *parkAllowMac;
                        parkAllowMac = selectedKey.lockMac;
                        delegate.TTObject.parklockAction = YES;
                        if (selectedKey.peripheralUUIDStr.length != 0 ) {
                            [BLEHelper connectLock:selectedKey];
                        }
                    }
                    
                }break;
                case 1:{
                    if ([BLEHelper getBlueState]) {
                        
                        extern NSString *parkAllowMac;
                        parkAllowMac = selectedKey.lockMac;
                        delegate.TTObject.parklockAction = NO;
                        if (selectedKey.peripheralUUIDStr.length != 0 ) {
                            [BLEHelper connectLock:selectedKey];
                        }
                    }
                }break;
                
                default:
                    break;
            }
        } break;
        case 1:{
            switch (indexPath.row) {
                case 1:{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"修改锁名", nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                          otherButtonTitles:NSLocalizedString(@"确定", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    alert.tag = TAG_CHANGE_NAME;
                    [alert show];
                    
                } break;
                case 2:{
                    //发送电子钥匙
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入接收方用户名(方便起见，这里默认发送电子钥匙的有效期是从当前时间开始,20分钟内有效)"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                          otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    alert.tag = TAG_SEND_EKEY;
                    [alert show];
                } break;
                case 3:{
                    //所用户
                    UserManageViewController * unlockRecord = [[UserManageViewController alloc]initWithNibName:@"UserManageViewController" bundle:nil];
                    unlockRecord.currentKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
                }break;
                case 4:{
                    //读取开锁记录
                    UnlockRecordsViewController * unlockRecord = [[UnlockRecordsViewController alloc]initWithNibName:@"UnlockRecordsViewController" bundle:nil];
                    unlockRecord.selectedKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
                    
                }break;
                    
                default:
                    break;
        }
        }break;
        default:
            break;
    }
    
    
    return nil;
}

- (IBAction)switchChanged:(UISwitch *)sender {
    
    switch (sender.tag) {
        case TAG_BACK_UP_PS:
        {
            if (sender.isOn) {
                //备份钥匙，特出输入密码，这个密码在下载备份钥匙的时候需要输入
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"请输入密码", nil)
                                                                message:NSLocalizedString(@"请输入备份密码。请牢记备份密码，在您下载备份钥匙的时候需要输入该密码", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                backUpPs = [alert textFieldAtIndex:0];
                [backUpPs setSecureTextEntry:YES];
                alert.tag = TAG_ALERT_BACK_UP_PS;
                [alert show];
            }
            else{
                //删除备份
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                
                [ProgressHUD  show:@"请稍候"];
                
                __block int ret ;
                
                dispatch_async(queue, ^(void){
                    
                    dispatch_sync(queue, ^(void){
                        ret = [RequestService deleteBackUpkeyWithLockId:selectedKey.lockId keyId:selectedKey.keyId];
                        NSLog(@"删除备份ret:%d",ret);
                    });
                    dispatch_sync(dispatch_get_main_queue(), ^(void){
                        [ProgressHUD dismiss];
                        if (ret>=0) {
                            //成功
                            [sender setOn:NO];
//                            selectedKey.hasbackup = NO;
                            [[DBHelper sharedInstance] update];
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"删除备份钥匙成功", nil) delegate: self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else{
                            
                            [sender setOn:YES];
                            //失败
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"删除备份钥匙失败", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    });
                });
            }
           
        } break;
       
        default:
            break;
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag) {
            [ProgressHUD show:@"请稍候..."];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            __block int ret;
            dispatch_async(queue, ^(void){
                dispatch_sync(queue, ^(void){
                    ret = [RequestService backUpkeyWithLockId:selectedKey.lockId keyId:selectedKey.keyId adminPs:selectedKey.adminPwd nokeyPs:selectedKey.noKeyPwd deletePs:selectedKey.deletePwd backupPs:[TTUtils md5:backUpPs.text]];
                });
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    [ProgressHUD dismiss];
                    if (ret >= 0) {
//                        selectedKey.hasbackup = YES;
                        [[DBHelper sharedInstance] update];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备份钥匙成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    else {
                        UISwitch *swith = [self.view viewWithTag:TAG_BACK_UP_PS];
                        [swith setOn:NO];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备份钥匙失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                });
            });
        }
    }else{
        if (alertView.tag == TAG_ALERT_BACK_UP_PS) {
            UISwitch *swith = [self.view viewWithTag:TAG_BACK_UP_PS];
            [swith setOn:NO];
        }
    }
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

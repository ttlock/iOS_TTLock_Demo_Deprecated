//
//  FirstViewController.m
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Tab0ViewCell.h"
#import "MyLog.h"
#import "KeyDetailViewController.h"
#import "RequestService.h"
#import "AddLockGuider1ViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "ProgressHUD.h"
#import "ParkKeyDetailVC.h"
#import "LoginViewController.h"
#import "XYCUtils.h"
#import "AccountInfoViewController.h"
#import <MJExtension/MJExtension.h>
#import "KeyTableViewController.h"
#import "LockViewController.h"
#import "PlugListViewController.h"
@interface Tab0ViewController()
{
    
    UIView * loadingView;
    
    Key * selectedKey;
    LockModel *backupKeySelected;
    NSArray *_datas;
    NSMutableArray *keyArray;
    NSMutableArray *ekeyArray;
    NSIndexPath *backupKeyIndexPath;
    
}

@end

#define TAG_DOWNLOAD_BACKUP 13
#define TAG_ALERT_DOWNLOAD_BACKUP 14
#define TAG_ALERT_DELETE 15

BOOL keydetailAppear;
@implementation Tab0ViewController

@synthesize customTableView;


bool DEBUG_TAB0 = true;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"tab0_title", @"sciener");
        
        //左边按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通通锁登录" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLogin:)];
        
        //右边按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
        
        //防止在ios7上出现，tableview被nav遮住的情况
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
    
}

-(void)rightAction:(id)sender
{
   
    if (![SettingHelper getAccessToken]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请先点击左侧‘登录’按钮，获取accesstoken" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.navigationController pushViewController:[[AddLockGuider1ViewController alloc] initWithNibName:@"AddLockGuider1ViewController" bundle:nil] animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidload");

    _datas = @[@"帐号信息",@"已添加锁",@"已添加钥匙",@"网关"];
    
    [self setExtraCellLineHidden:customTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
   [super viewDidAppear:animated];
    [customTableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if ([SettingHelper getAccessToken]) {
        
    }
    
    keyArray = [[DBHelper sharedInstance] fetchKeys];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"tab0 ####didReceiveMemoryWarning####");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        if (indexPath.row<[keyArray count]) {
            Key* key = [keyArray objectAtIndex:indexPath.row];
            selectedKey= key;
            [self unbind];
            
        }
    }
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    if (indexPath.section == 0) {
//        Tab0ViewCell* cell = (Tab0ViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//        BOOL editing = [cell isEditing];
//        return !editing;
//    }
//    
//    return NO;
//    
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        
//        return UITableViewCellEditingStyleDelete;
//    }
//    
//    return UITableViewCellEditingStyleNone;
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"CellDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _datas[indexPath.row];
    
    return cell;
    
//    static NSString *CellIdentifier = @"Cell";
//    Tab0ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"Tab0ViewCell"
//                                              owner:self
//                                            options:nil] lastObject];
//        
//        
//    }
//    switch (indexPath.section) {
//        case 0:
//        {
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//            Key *key = [keyArray objectAtIndex:indexPath.row];
//            cell.label_key_name.text = key.doorName;
//            if([key isAdmin]){
//                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_admin", @"admin")];
//                
//            }else{
//                cell.label_user_type.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"words_shenfen", @"identity"),NSLocalizedString(@"words_user", @"user")];
//            }
//            
//            BOOL outOfDate = YES;
//            NSDate * currentDate = [NSDate date];
//            if ([[currentDate earlierDate:[NSDate dateWithTimeIntervalSince1970:key.endDate]]isEqual:currentDate]) {
//                outOfDate = NO;
//            }
//            
//            break;
//            
//        }

            
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[AccountInfoViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[LockViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[KeyTableViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[PlugListViewController new] animated:YES];
            break;
        default:
            break;
    }
}

-(IBAction)gotoLogin:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
//    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appdelegate.scienerObject authorize];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   

    if (actionSheet.tag == TAG_DOWNLOAD_BACKUP) {
        switch (buttonIndex) {
            case 0:
            {
                //下载
                //备份钥匙，特出输入密码，这个密码在下载备份钥匙的时候需要输入
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"请输入备份密码", nil)
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                       otherButtonTitles:NSLocalizedString(@"words_sure_ok", nil),nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                
                UITextField * text1 = [alert textFieldAtIndex:0];
                [text1 setSecureTextEntry:YES];
                alert.tag = TAG_ALERT_DOWNLOAD_BACKUP;
                [alert show];
                break;
            }
            case 1:
            {
                //删除
                [ProgressHUD show:@"请稍候"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^(void){
                    
                    __block int ret;
                    dispatch_sync(queue, ^(void){
                        
//                   ret = [RequestService deleteBackUpkeyWithLockId:backupKeySelected.lockId keyId:backupKeySelected.keyId];
                        
                    });
                    NSLog(@"删除备份的ret = %d", ret);
                    dispatch_sync(dispatch_get_main_queue(), ^(void){
                        [ProgressHUD dismiss];
                        if (ret==0) {
                            //成功
                            for (Key * key in keyArray) {
                                if ([key.lockName isEqual:backupKeySelected.lockName] || [key.lockMac isEqual:backupKeySelected.lockMac]) {
                                }
                            }
                            [[DBHelper sharedInstance] update];
                            
                            [ekeyArray removeAllObjects];
                            [keyArray removeAllObjects];

//                            [self getData];

                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"删除备份钥匙成功", nil) delegate: self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else{
                            
                            //失败
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"删除备份钥匙失败", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    });
                    
                    
                });
                
                break;
            }
            default:
                break;
        }
        
        [[DBHelper sharedInstance]update];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

        switch (alertView.tag) {
            case TAG_ALERT_DOWNLOAD_BACKUP:
            {
                if (buttonIndex == 1) {
                    [ProgressHUD show:@"请稍候"];
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                    
                    dispatch_async(queue, ^(void){
                        __block id ret;
                        dispatch_sync(queue, ^(void){
//                            ret = [RequestService downloadBackup_keyWithLockId:backupKeySelected.lockId keyId:backupKeySelected.keyid backupPs:[TTUtils md5:[alertView textFieldAtIndex:0].text]];
                        });
                        dispatch_sync(dispatch_get_main_queue(), ^(void){
                            [ProgressHUD dismiss];
                            if ([ret isKindOfClass:[LockModel class]]) {
                                for (Key * key in keyArray) {
                                    if ([((LockModel *)ret).lockMac isEqual:key.lockMac] || [((LockModel *)ret).lockName isEqual:key.lockName]) {
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"您已经有了这把锁的钥匙", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                                        [alert show];
                                        return;
                                    }
                                }
//                                ((LockModel *)ret).ttAccount = [SettingHelper getOpenID];
//                                ((LockModel *)ret).username = [SettingHelper getOpenID];
//                                ((LockModel *)ret).lockId = backupKeySelected.lockId;
//                                ((LockModel *)ret).keyId = backupKeySelected.keyId;
                                [[DBHelper sharedInstance] saveKey:ret];
                                //下载成功
                                
                                [ekeyArray removeAllObjects];
                                [keyArray removeAllObjects];

//                                [self getData];
                            }
                            else {
                                if (((NSString*)ret).intValue == NET_REQUEST_ERROR_wrong_backup_ps) {
                                    
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"备份密码错误", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }else{
                                    
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"下载备份钥匙失败, 请稍后再试", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                                
                            }
                        });
                        
                    });

                }
                break;
            }
            case TAG_ALERT_DELETE:
            {
                if (buttonIndex == 2) {
                   //删除备份
                    [ProgressHUD show:@"请稍候"];
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^(void){
                        __block int ret;
                        dispatch_sync(queue, ^(void){
                            ret = [RequestService deleteBackUpkeyWithLockId:selectedKey.lockId keyId:selectedKey.keyId];
                        });
                        NSLog(@"删除备份的ret = %d", ret);
                        dispatch_sync(dispatch_get_main_queue(), ^(void){
                            [ProgressHUD dismiss];
                            if (ret==0) {

                                [self unbind];
                            }
                            else{
                                //失败
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"删除备份钥匙失败", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles:nil, nil];
                                [alert show];
                            }
                           
                        });
                    });
                }
                else if (buttonIndex == 1) {
                    //删除本地
                    [[DBHelper sharedInstance] deleteKey:selectedKey];
//                    [self getData];
                }
            }
            default:
                break;
        }
}
- (void)unbind{
    if ([selectedKey.lockVersion hasPrefix:@"5.3"] && selectedKey.isAdmin == YES) {
        extern  BOOL isRetLock; //是否恢复出厂设置
        isRetLock = YES;
        [self v3ReadyConnect];
    }else{
        [self deleteSelectKey];
    }
}
- (void)deleteSelectKey{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block int ret;
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            ret = [RequestService unbindLockId:selectedKey.lockId date:[XYCUtils GetCurrentTimeInMillisecond]];
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (ret == 0 || ret == 20002) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                //删除本地
                [[DBHelper sharedInstance] deleteKey:selectedKey];
//                [self getData];
                
            }else{
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:@"解绑失败"];
            }
        });
    });
}
- (void)v3ReadyConnect{
    extern NSString *v3AllowMac;
    v3AllowMac = selectedKey.lockMac;
    if ([selectedKey.lockVersion hasPrefix:@"5.3"]) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        if (selectedKey.peripheralUUIDStr.length != 0 ) {
            [BLEHelper connectLock:selectedKey];
        }
    }
}
@end

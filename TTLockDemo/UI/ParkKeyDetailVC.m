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
#import "RequestService.h"
#import "DBHelper.h"

#define TAG_CHANGE_NAME 10
#define TAG_SEND_EKEY 3

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
      _dataArray = @[@[@"上升", @"下降"],@[@"修改锁名",@"发送电子钥匙",@"锁用户",@"读取开锁记录"]];
    }else{
     _dataArray = @[@[@"上升",@"下降"]];
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
                  if ([BlueToothHelper getBlueState]) {
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            NSLog(@"bu KKBLE_CONNECT_SUCCESS");
                            [self showLockNotNearToast];
                     
                            return ;
                        }
                        [TTLockHelper lock:selectedKey lockBlock:^(id info, BOOL succeed) {
                            if (!succeed) {
                                [self showLockOperateFailed];
                            }
                        }];
                    }];
                  }
                }break;
                case 1:{
                    if ([BlueToothHelper getBlueState]) {
                        [TTLockHelper connectKey:selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                            if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                                [self showLockNotNearToast];
                                return ;
                            }
                            [TTLockHelper unlock:selectedKey unlockBlock:^(id info, BOOL succeed) {
                                if (!succeed) {
                                    [self showLockOperateFailed];
                                }
                            }];
                        }];
                    }
                }break;
                
                default:
                    break;
            }
        } break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"修改锁名", nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                                          otherButtonTitles:NSLocalizedString(@"确定", nil),nil];
                    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    
                    alert.tag = TAG_CHANGE_NAME;
                    [alert show];
                    
                } break;
                case 1:{
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
                case 2:{
                    //所用户
                    UserManageViewController * unlockRecord = [[UserManageViewController alloc]initWithNibName:@"UserManageViewController" bundle:nil];
                    unlockRecord.currentKey = selectedKey;
                    [self.navigationController pushViewController:unlockRecord animated:YES];
                }break;
                case 3:{
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

//
//  KeyViewController.m
//  TTLockDemo
//
//  Created by 刘潇翔 on 17/2/9.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "KeyTableViewController.h"
#import "DBHelper.h"
#import "MyLog.h"
#import "Tab0ViewCell.h"
#import "Key.h"
#import "KeyDetailViewController.h"
@interface KeyTableViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *_keyArray;
    Key *selectedKey;
}
@end

@implementation KeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已添加钥匙";
    
    _keyArray = [[DBHelper sharedInstance] fetchKeys];
    
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onResetLockNot:) name:@"onResetLockNot" object:nil];
}

- (void)onResetLockNot:(NSNotification*)noti{
  
    [self deleteSelectKey];
}

- (void)loadData
{
    
    NSString *lastUpdateDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastUpdateDate"];
    
    [NetworkHelper syncKeyData:lastUpdateDate completion:^(id info, NSError *error) {
        
        if (error) return ;
        
        SyncKeyInfo *syncKeyInfo = [SyncKeyInfo mj_objectWithKeyValues:info];
        
        [[NSUserDefaults standardUserDefaults] setValue:syncKeyInfo.lastUpdateDate forKey:@"lastUpdateDate"];
        
        NSMutableArray *dbKeyList = [[DBHelper sharedInstance] fetchKeys];
        
        for (KeyModel *keyModel in syncKeyInfo.keyList) {//同步钥匙
            
            
            for (Key *dbKey in dbKeyList) {
                if ([keyModel.keyStatus isEqualToString:KeyStatusReceiving]) {
                    keyModel.keyStatus = KeyStatusReceived;
                }else if ([keyModel.keyStatus isEqualToString:KeyStatusDeleting]){
                    [[DBHelper sharedInstance] deleteKey:dbKey];
                    return;
                }else if ([keyModel.keyStatus isEqualToString:KeyStatusFreezing]){
                    
                    keyModel.keyStatus = KeyStatusFreezed;
                    
                }else if ([keyModel.keyStatus isEqualToString:KeyStatusUnFreezing]){
                    
                    keyModel.keyStatus = KeyStatusReceived;
                    
                }else if ([keyModel.keyStatus isEqualToString:KeyStatusChanging]){
                    keyModel.keyStatus = KeyStatusReceived;
                }

                if (keyModel.keyId == dbKey.keyId) {
                    [[DBHelper sharedInstance] deleteKey:dbKey];
                }
            }
            [[DBHelper sharedInstance] saveKey:keyModel];
            
        }
        _keyArray = [[DBHelper sharedInstance] fetchKeys];
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keyArray.count;
}

- (Tab0ViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Key *key = _keyArray[indexPath.row];
    
    NSString *cellId = @"Cell";
    Tab0ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Tab0ViewCell"
                                              owner:self
                                            options:nil] lastObject];
        
    }
    
    cell.leftTopLabel.text = key.lockAlias;
    
    if ([key isAdmin])
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"管理员  电量:%d%%",key.electricQuantity];
    else{
    if (key.startDate==0 && key.endDate==0)
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"永久  电量:%d%%",key.electricQuantity];
    else
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"期限  电量:%d%%",key.electricQuantity];
    }
    
    if (key.electricQuantity==-1) {
        if ([key isAdmin])
            cell.leftBottomLabel.text = @"管理员";
        else{
            if (key.startDate==0 && key.endDate==0)
                cell.leftBottomLabel.text = @"永久";
            else
                cell.leftBottomLabel.text = @"期限";
        }
    }
    
    if ([key.keyStatus isEqualToString:KeyStatusReceived]) {
        cell.rightLabel.text = @"已生效";
    }else if ([key.keyStatus isEqualToString:KeyStatusFreezed]){
        cell.rightLabel.text = @"已冻结";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedKey = _keyArray[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    KeyDetailViewController *uiview = [[KeyDetailViewController alloc]initWithNibName:@"KeyDetailViewController" bundle:nil];
    uiview.selectedKey = selectedKey;
    [self.navigationController pushViewController:uiview animated:YES];

}

- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedKey = _keyArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确定删除钥匙？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
        [alert show];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            if ([selectedKey.lockVersion hasPrefix:@"5.3"] && selectedKey.isAdmin == YES) {
                extern  BOOL isRetLock; //是否恢复出厂设置
                isRetLock = YES;
                [self v3ReadyConnect];
            }else{
                [self deleteSelectKey];
            }

           
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteSelectKey{
     [SVProgressHUD show];
    [NetworkHelper deleteKey:selectedKey.keyId completion:^(id info, NSError *error) {
        if (error) return ;
        
        [[DBHelper sharedInstance] deleteKey:selectedKey];
        
        [_keyArray removeObject:selectedKey];
        
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        
    }];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

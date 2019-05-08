//
//  KeyViewController.m
//  TTLockDemo
//
//  Created by LXX on 17/2/9.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "KeyTableViewController.h"
#import "DBHelper.h"
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
    
    self.title = LS(@"words_Sync_ekey_data");
    
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
        
        for (KeyModel *keyModel in syncKeyInfo.keyList) {
            
            
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
    
    if (key.electricQuantity != -1) {
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@:%d%%",LS(@"words_Battery"),key.electricQuantity];
    }else{
        cell.leftBottomLabel.text = @"";
    }
    
   
    if ([key isAdmin])
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"words_admin"),cell.leftBottomLabel.text];
    else{
        if (key.startDate==0 && key.endDate==0)
            cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"forever_password"),cell.leftBottomLabel.text];
        else
            cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"words_Shared_key"),cell.leftBottomLabel.text]; LS(@"");
    }

    
    if ([key.keyStatus isEqualToString:KeyStatusReceived]) {
        cell.rightLabel.text = LS(@"words_key_state_type_Work");
    }else if ([key.keyStatus isEqualToString:KeyStatusFreezed]){
        cell.rightLabel.text = LS(@"words_key_state_type_Blocked");
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LS(@"alert_msg_delete_sure") message:nil delegate:self cancelButtonTitle:LS(@"words_cancel") otherButtonTitles:LS(@"words_delete"), nil];
    
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
                if ([BlueToothHelper getBlueState]) {
                    [self showHUD:nil];
                    [TTLockHelper connectKey:selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            [self showLockNotNearToast];
                            return ;
                        }
                        [TTLockHelper resetLock:selectedKey complition:^(id info, BOOL succeed) {
                            if (succeed) {
                                [self deleteSelectKey];
                                return ;
                            }
                            [self showLockOperateFailed];
                        }];
                    }];
                }
                
            }else{
                 [self showHUD:nil];
                [self deleteSelectKey];
            }

           
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteSelectKey{
    
    [NetworkHelper deleteKey:selectedKey.keyId completion:^(id info, NSError *error) {
        if (error) return ;
        
        [[DBHelper sharedInstance] deleteKey:selectedKey];

        [_keyArray removeObject:selectedKey];
        
        [self.tableView reloadData];
        [self showToast:LS(@"alter_Succeed")];
        
    }];
}

@end

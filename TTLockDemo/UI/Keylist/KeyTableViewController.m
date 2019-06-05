//
//  KeyViewController.m
//  TTLockDemo
//
//  Created by LXX on 17/2/9.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "KeyTableViewController.h"
#import "KeyDetailViewController.h"
#import "ParkKeyDetailVC.h"

@interface KeyTableViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *_keyArray;
    KeyModel *selectedKey;
}
@end

@implementation KeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LS(@"words_key_list");
   
    
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onResetLockNot:) name:@"onResetLockNot" object:nil];
}

- (void)onResetLockNot:(NSNotification*)noti{
  
    [self deleteSelectKey];
}

- (void)loadData
{
    [self showHUD:nil];
    [NetworkHelper getkeyListWithCompletion:^(id info, NSError *error) {
        
        if (error) return ;
        [self hideHUD];
        _keyArray = [KeyModel mj_objectArrayWithKeyValuesArray:info[@"keyList"]];
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyModel *key = _keyArray[indexPath.row];
    
    NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }

    if ([key.keyStatus isEqualToString:KeyStatusFreezed] || [key.keyStatus isEqualToString:KeyStatusFreezing]){
        cell.textLabel.text =[NSString stringWithFormat:@"%@ (%@)",key.lockAlias,LS(@"words_key_state_type_Blocked")];
    }else  {
        cell.textLabel.text = key.lockAlias;
    }

    if (key.electricQuantity != -1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%d%%",LS(@"words_Battery"),key.electricQuantity];
    }else{
        cell.detailTextLabel.text = @"";
    }
    
    if ([key isAdmin])
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"words_admin"),cell.detailTextLabel.text];
    else{
        if (key.startDate==0 && key.endDate==0)
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"forever_password"),cell.detailTextLabel.text];
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", LS(@"words_Shared_key"),cell.detailTextLabel.text]; LS(@"");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedKey = _keyArray[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([selectedKey.lockVersion hasPrefix:@"5.3.7"] || [selectedKey.lockVersion hasPrefix:@"10"]){
         ParkKeyDetailVC *uiview = [[ParkKeyDetailVC alloc]init];
        uiview.selectedKey = selectedKey;
        [self.navigationController pushViewController:uiview animated:YES];
         return;
    }

    KeyDetailViewController *uiview = [[KeyDetailViewController alloc]init];
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

        [_keyArray removeObject:selectedKey];
        [self.tableView reloadData];
        [self showToast:LS(@"alter_Succeed")];
        
    }];
}

@end

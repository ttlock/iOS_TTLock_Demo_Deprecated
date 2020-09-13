//
//  KeypadAddViewController.m
//  TTLockSourceCodeDemo
//
//  Created by Jinbo Lu on 2019/5/28.
//  Copyright © 2019 Sciener. All rights reserved.
//

#import "KeypadAddViewController.h"
#import "KeypadModel.h"

@interface KeypadAddViewController ()
@property (nonatomic, strong) KeypadModel *keypadModel;

@property (nonatomic, strong) NSMutableArray<TTWirelessKeypadScanModel *> *dataArray;
@end

@implementation KeypadAddViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [TTWirelessKeypad stopScanKeypad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LS(@"words_Add_Keypad");
    self.tableView.tableFooterView = [UIView new];
    
    if ([BlueToothHelper getBlueState] == NO ) {
        [self showToast:LS(@"words_lock_msg_one")];
        return;
    }
    
    _dataArray = @[].mutableCopy;
    [TTWirelessKeypad startScanKeypadWithBlock:^(TTWirelessKeypadScanModel *model) {
        for (TTWirelessKeypadScanModel *containModel in self.dataArray) {
            if ([containModel.keypadMac isEqualToString:model.keypadMac]) {
                [self.dataArray removeObject:containModel];
                break;
            }
        }
        [self.dataArray addObject:model];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    TTWirelessKeypadScanModel *scanModel = _dataArray[indexPath.row];
    cell.textLabel.text = scanModel.keypadName;
    cell.detailTextLabel.text = @"+";
    cell.detailTextLabel.textColor = cell.textLabel.textColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:35];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TTWirelessKeypadScanModel *scanModel = _dataArray[indexPath.row];
    [self showHUDToWindow:nil];
	[TTWirelessKeypad initializeKeypadWithKeypadMac:scanModel.keypadMac lockMac:self.selectedKey.lockMac block:^(NSString *wirelessKeypadFeatureValue, TTKeypadStatus status) {
		if (status != TTKeypadSuccess) {
          
            [self showToast:LS(@"alter_Failed")];
        }else{
            NSString *wirelessKeypadName = [NSString stringWithFormat:@"Keypad-%ld",random()];
            [NetworkHelper addWirelessKeypadName:wirelessKeypadName number:scanModel.keypadName mac:scanModel.keypadMac wirelessKeypadFeatureValue:wirelessKeypadFeatureValue lockId:@(self.selectedKey.lockId) completion:^(id info, NSError *error) {
                if (error)return ;
           
                [SSToastHelper showToastWithStatus:LS(@"words_add_success")];
                   [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
               
               
                
            }];
        }
	}];
}

@end

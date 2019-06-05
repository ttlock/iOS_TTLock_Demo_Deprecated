//
//  KeypadTableViewController.m
//  TTLockSourceCodeDemo
//
//  Created by Jinbo Lu on 2019/5/28.
//  Copyright © 2019 Sciener. All rights reserved.
//

#import "KeypadTableViewController.h"
#import "KeypadAddGuide1ViewController.h"
#import "KeypadModel.h"
#import "KeypadViewController.h"

@interface KeypadTableViewController ()

@property (nonatomic, strong) NSArray<KeypadModel *> *dataArray;
@end

@implementation KeypadTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self showHUDToWindow:nil];
    [self setupData];
    
}

- (void)setupData{
  
    [NetworkHelper getWirelessKeypadListWithLockId:@(self.selectedKey.lockId) completion:^(id info, NSError *error) {
        if (error){
         
            return ;
        }
        [self hideHUD];
        self.dataArray = [KeypadModel mj_objectArrayWithKeyValuesArray:info];
        [self.tableView reloadData];
    }];
}

- (void)setupView{
    
    UIButton *rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItemButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [rightItemButton setTitle:@"+" forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont systemFontOfSize:35];
    [rightItemButton addTarget:self action:@selector(addKeypadClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.rowHeight = 55;
    self.tableView.tableFooterView = [UIView new];
}

- (void)addKeypadClick{
    KeypadAddGuide1ViewController *vc = [[KeypadAddGuide1ViewController alloc] init];
    vc.selectedKey = self.selectedKey;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KeypadModel *keypadModel = self.dataArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = keypadModel.wirelessKeyboardName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KeypadViewController *vc = [[KeypadViewController alloc] initWithKeypadModel:_dataArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

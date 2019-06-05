//
//  GatewayTypeTableViewController.m
//  TTLockSourceCodeDemo
//
//  Created by Jinbo Lu on 2019/4/26.
//  Copyright © 2019 Sciener. All rights reserved.
//

#import "GatewayTypeTableViewController.h"
#import "Gateway1AddViewController.h"
#import "GuideGatewayViewController.h"
#import "Reachability.h"

@interface GatewayTypeTableViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation GatewayTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
}

- (void)setupView{
    self.tableView.rowHeight = 55;
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupData{
    _dataArray = @[@{@"G1":@"G1"},@{@"G2":@"G2"}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.imageView.image = [UIImage imageNamed:[_dataArray[indexPath.row] allValues].firstObject];
    cell.textLabel.text = [_dataArray[indexPath.row] allKeys].firstObject;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([self isWiFiNetReachability]) {
            Gateway1AddViewController *addvc = [[Gateway1AddViewController alloc]init];
            [self.navigationController pushViewController:addvc animated:YES];
            
        }else{
            [self showToast:LS(@"hint_connect_your_phone_to_WiFi")];
        }

    }else{
        GuideGatewayViewController *vc = [GuideGatewayViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)isWiFiNetReachability{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    return NO;
}

@end

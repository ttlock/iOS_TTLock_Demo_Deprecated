//
//  GatewayListLockVC.m
//  TTLockDemo
//
//  Created by wjjxx on 17/3/23.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "GatewayListLockVC.h"
#import "PlugListModel.h"
#import "PlugLockListModel.h"
#import "LockClockVC.h"
@interface GatewayListLockVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *baseWifiTableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GatewayListLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.plugModel.gatewayMac;
    [self createTableview];
    
    // Do any additional setup after loading the view.
}
- (void)initData{
    [NetworkHelper getGatewayListLockWithGatewayId:self.plugModel.gatewayId completion:^(id info, NSError *error) {
        if (!error && [info isKindOfClass:[NSDictionary class]]) {
            self.dataArray = [PlugLockListModel arrayOfModelsFromDictionaries:info[@"list"] error:nil];
            [self.baseWifiTableview reloadData];
            
        }
    }];
}
- (void)createTableview{
    _dataArray = [NSMutableArray array];
    self.baseWifiTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
    self.baseWifiTableview.delegate = self;
    self.baseWifiTableview.dataSource = self;
    [self.view addSubview:self.baseWifiTableview];
    [self initData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    PlugLockListModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.lockName;
    cell.detailTextLabel.text  = [NSString stringWithFormat:@"RSSI:%@",model.rssi];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.baseWifiTableview deselectRowAtIndexPath:indexPath animated:YES];
    LockClockVC *vc = [[LockClockVC alloc]init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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

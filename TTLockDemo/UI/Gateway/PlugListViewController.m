//
//  PlugListViewController.m
//  Sciener
//
//  Created by wjjxx on 17/1/6.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "PlugListViewController.h"
#import "GatewayModel.h"
#import "Gateway1AddViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "GatewayListLockVC.h"
#import "GatewayTypeTableViewController.h"
#import "GateWayDetailViewController.h"

typedef void(^TableViewPullRefrshBlock)();

@interface PlugListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *baseWifiTableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation PlugListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self initData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"words_WiFi_gateway");
    [self createTableview];

    [self showHUD:nil];
    [self initData];

     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightNavigationItemClicked)];
   
    // Do any additional setup after loading the view.
}
- (void)rightNavigationItemClicked{
    
    GatewayTypeTableViewController *addvc = [[GatewayTypeTableViewController alloc]init];
    [self.navigationController pushViewController:addvc animated:YES];

}
- (void)createTableview{
    _dataArray = [NSMutableArray array];
    self.baseWifiTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
    self.baseWifiTableview.delegate = self;
    self.baseWifiTableview.dataSource = self;
    [self.view addSubview:self.baseWifiTableview];
    
}

- (void)initData{
     [NetworkHelper getGatewayListWithCompletion:^(id info, NSError *error) {
         if (!error && [info isKindOfClass:[NSDictionary class]]) {
             self.dataArray = [GatewayModel mj_objectArrayWithKeyValuesArray:info[@"list"]];
             [self hideHUD];
             [self.baseWifiTableview reloadData];
             
         }
     }];

}
#pragma mark ----- UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GatewayModel* plugModel = self.dataArray[indexPath.row];
       [NetworkHelper deleteGatewayWithGatewayId:plugModel.gatewayId completion:^(id info, NSError *error) {
           if (!error && [info isKindOfClass:[NSDictionary class]]) {
               if ([info[@"errcode"] intValue] >= 0) {
                   [self.dataArray removeObject:plugModel];
                     [self.baseWifiTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
               }
           }
       }];
    }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{

    [super setEditing:editing animated:animated];

    [self.baseWifiTableview setEditing:editing animated:YES];
    
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
    GatewayModel *gatewayModel = self.dataArray[indexPath.row];
    NSString *imageName = gatewayModel.gatewayVersion == GatewayG2 ? @"G2" : @"G1";
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = gatewayModel.gatewayName;
    cell.detailTextLabel.text = gatewayModel.isOnline ? LS(@"Online") : LS(@"Offline");
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [self.baseWifiTableview deselectRowAtIndexPath:indexPath animated:YES];
    GateWayDetailViewController *vc = [GateWayDetailViewController new];
    GatewayModel *gatewayModel = _dataArray[indexPath.row];
    vc.gatewayModel = gatewayModel;
    [self.navigationController pushViewController:vc animated:YES];
    
  
}


- (void)setTopRefreshBlock:(TableViewPullRefrshBlock)topRefreshBlock{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (topRefreshBlock) {
            topRefreshBlock();
        }      }];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.backgroundColor = RGB_A(213, 213, 213, 0.5);
    
    self.baseWifiTableview.mj_header = header;
}

- (void)setBottomRefreshBlock:(TableViewPullRefrshBlock)bottomRefreshBlock{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        if (bottomRefreshBlock) {
            bottomRefreshBlock();
        }
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.baseWifiTableview.mj_footer = footer;
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

//
//  PlugListViewController.m
//  Sciener
//
//  Created by wjjxx on 17/1/6.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "PlugListViewController.h"
#import "PlugListModel.h"
#import "AddWifiViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "Reachability.h" 
#import "GatewayListLockVC.h"
typedef void(^TableViewPullRefrshBlock)();

@interface PlugListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *baseWifiTableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)int pageNo;
@end

@implementation PlugListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LS(@"words_WiFi_gateway");
    [self createTableview];
    WS(weakSelf);
    [self setTopRefreshBlock:^{
        weakSelf.pageNo = 1;
        [weakSelf initData];
    }];
    
    [self setBottomRefreshBlock:^{
        weakSelf.pageNo++;
        [weakSelf initData];
    }];
    self.pageNo = 1;
     [self.baseWifiTableview.mj_header beginRefreshing];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightNavigationItemClicked)];
   
    // Do any additional setup after loading the view.
}
- (void)rightNavigationItemClicked{
    
    if ([self isWiFiNetReachability]) {
        AddWifiViewController *addvc = [[AddWifiViewController alloc]init];
        [self.navigationController pushViewController:addvc animated:YES];
        WS(weakSelf);
        addvc.addWifiSuccessBlock = ^{
            [weakSelf.baseWifiTableview.mj_header beginRefreshing];
        };
    }else{
        [self showToast:LS(@"hint_connect_your_phone_to_WiFi")];
    }
}
- (void)createTableview{
    _dataArray = [NSMutableArray array];
    self.baseWifiTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
    self.baseWifiTableview.delegate = self;
    self.baseWifiTableview.dataSource = self;
    [self.view addSubview:self.baseWifiTableview];
    
}

- (void)initData{
     [NetworkHelper getGatewayListWithPageNo:self.pageNo completion:^(id info, NSError *error) {
         if (!error && [info isKindOfClass:[NSDictionary class]]) {
             NSArray *tempArray = [PlugListModel arrayOfModelsFromDictionaries:info[@"list"] error:nil];
             if (self.pageNo == 1) {
                 [self.dataArray removeAllObjects];
             }
             [self.baseWifiTableview.mj_header endRefreshing];
             [self.baseWifiTableview.mj_footer endRefreshing];
             [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 [self.dataArray addObject:obj];
             }];
             [self.baseWifiTableview reloadData];
             
         }else{
             [self.baseWifiTableview.mj_header endRefreshing];
             [self.baseWifiTableview.mj_footer endRefreshing];
         }
     }];

}
#pragma mark ----- UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlugListModel* plugModel = self.dataArray[indexPath.row];
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
    PlugListModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.gatewayMac;
    cell.detailTextLabel.text  = [NSString stringWithFormat:@"Number:%@",model.lockNum];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [self.baseWifiTableview deselectRowAtIndexPath:indexPath animated:YES];
    GatewayListLockVC *vc = [[GatewayListLockVC alloc]init];
    vc.plugModel = self.dataArray[indexPath.row];
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

- (BOOL)isWiFiNetReachability{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];

    if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    return YES;
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

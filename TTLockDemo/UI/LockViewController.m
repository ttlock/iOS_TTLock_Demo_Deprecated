//
//  LockViewController.m
//  TTLockDemo
//
//  Created by 刘潇翔 on 17/2/10.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "LockViewController.h"
#import "MJRefresh.h"
#import "LockModel.h"
#import "Tab0ViewCell.h"


typedef void(^TableViewPullRefrshBlock)();

@interface LockViewController ()
{
    NSMutableArray *_lockArray;
}
@property (nonatomic, assign) BOOL stillHaveData;

@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation LockViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"名下锁列表";
    
    
}

- (void)loadData
{

    __weak __typeof(&*self)weakSelf = self;
    [self setTopRefreshBlock:^{
        [weakSelf loadDataByPage:1];
    }];
        
    [self setBottomRefreshBlock:^{
        [weakSelf loadDataByPage:weakSelf.pageNo];
    }];
        
    [self loadDataByPage:1];
}


- (void)loadDataByPage:(NSInteger)pageNo{
    
    _pageNo = pageNo;
    [NetworkHelper listOfLock:1 completion:^(id info, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (error) return ;
        
        _lockArray = [NSMutableArray array];
        NSMutableArray *datas = [LockModel mj_objectArrayWithKeyValuesArray:info[@"list"]];
        if (pageNo == 1) {
            _lockArray = datas;
        }else{
            [_lockArray addObjectsFromArray:datas];
            self.stillHaveData = datas.count == 20;
        }
        [self.tableView reloadData];
        if (datas.count)
            self.pageNo++;

    }];
    [self.tableView reloadData];

}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _lockArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LockModel *lockModel = _lockArray[indexPath.row];
    NSString *cellId = @"Cell";
    Tab0ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Tab0ViewCell"
                                              owner:self
                                            options:nil] lastObject];
    }
    cell.leftTopLabel.text = lockModel.lockAlias;
    
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"电量：%d%%", lockModel.electricQuantity];

    cell.leftBottomLabel.hidden = lockModel.electricQuantity == -1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PullRefrsh

- (void)setStillHaveData:(BOOL)stillHaveData {
    _stillHaveData = stillHaveData;
    
    MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter*)self.tableView.mj_footer;
    if (stillHaveData)
        [footer resetNoMoreData];
    else
        [footer endRefreshingWithNoMoreData];
}


- (void)setTopRefreshBlock:(TableViewPullRefrshBlock)topRefreshBlock{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (topRefreshBlock) {
            topRefreshBlock();
        }      }];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.backgroundColor = RGB_A(213, 213, 213, 0.5);
    
    self.tableView.mj_header = header;
}

- (void)setBottomRefreshBlock:(TableViewPullRefrshBlock)bottomRefreshBlock{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        if (bottomRefreshBlock) {
            bottomRefreshBlock();
        }
    }];
    footer.automaticallyHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
}

- (void)forceRefresh {
    [self.tableView.mj_header beginRefreshing];
}


- (void)endRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}
- (void)endRefreshWithStillHaveData:(BOOL)stillHaveData{
    [self endRefresh];
    self.stillHaveData = stillHaveData;
}





@end

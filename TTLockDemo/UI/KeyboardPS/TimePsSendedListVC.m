//
//  TimePsSendedListVC.m
//  sciener
//
//  Created by 谢元潮 on 15/1/19.
//
//

#import "TimePsSendedListVC.h"
#import "RequestService.h"
#import "TimePsSendedCell.h"
#import "TimePsRecord.h"
#import "AppDelegate.h"
#import "Define.h"
#import "XYCUtils.h"
#import "MJRefresh.h"
#import "Tab0ViewCell.h"

typedef void(^TableViewPullRefrshBlock)();

@interface TimePsSendedListVC ()
{
    NSMutableArray *keyboardPwds;
    
}

@property (nonatomic, assign) BOOL stillHaveData;

@property (nonatomic, assign) NSInteger pageNo;


@end

@implementation TimePsSendedListVC
@synthesize selectedKey;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"键盘密码列表";
        
        //防止在ios7上出现，tableview被nav遮住的情况
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
}

-(void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [self setExtraCellLineHidden:customTableView];
    
    [aiv startAnimating];
    
    [label_no_data setHidden:YES];
    label_no_data.text = @"暂无记录";
    
    [self loadData];
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    
    [aiv setHidden:NO];
    
    [aiv startAnimating];
    
    _pageNo = pageNo;
    [NetworkHelper keyboardPwdListOfLock:selectedKey.lockId pageNo:1 completion:^(id info, NSError *error) {
        [customTableView.mj_footer endRefreshing];
        [customTableView.mj_header endRefreshing];
        if (error) return ;
        
        keyboardPwds = [NSMutableArray array];
        NSMutableArray *datas = [KeyboardPwd mj_objectArrayWithKeyValuesArray:info[@"list"]];
        if (pageNo == 1) {
            keyboardPwds = datas;
        }else{
            [keyboardPwds addObjectsFromArray:datas];
            self.stillHaveData = datas.count == 20;
        }
        [customTableView reloadData];
        if (datas.count)
            self.pageNo++;
        
    }];
    [customTableView reloadData];
    [aiv setHidden:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return keyboardPwds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"managecell";
    
    Tab0ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Tab0ViewCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    KeyboardPwd *pwd = keyboardPwds[indexPath.row];
    
    cell.leftBottomLabel.numberOfLines = 0;
    
    cell.leftTopLabel.text = pwd.keyboardPwd;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Table view delegate

- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath{
    KeyboardPwd *pwd = keyboardPwds[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [NetworkHelper deleteKeyboardPwd:pwd.keyboardPwdId lockId:pwd.lockId deleteType:2  completion:^(id info, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"删除密码成功"];
                [keyboardPwds removeObject:pwd];
                [customTableView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"删除密码失败"];
                return ;
            }
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - PullRefrsh

- (void)setStillHaveData:(BOOL)stillHaveData {
    _stillHaveData = stillHaveData;
    
    MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter*)customTableView.mj_footer;
    if (stillHaveData)
        [footer resetNoMoreData];
    else
        [footer endRefreshingWithNoMoreData];
}


- (void)setTopRefreshBlock:(TableViewPullRefrshBlock)topRefreshBlock{
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (topRefreshBlock) {
            topRefreshBlock();
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.backgroundColor = RGB_A(213, 213, 213, 0.5);
    
    customTableView.mj_header = header;
}

- (void)setBottomRefreshBlock:(TableViewPullRefrshBlock)bottomRefreshBlock{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        if (bottomRefreshBlock) {
            bottomRefreshBlock();
        }
    }];
    footer.automaticallyHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    customTableView.mj_footer = footer;
}

- (void)forceRefresh {
    [customTableView.mj_header beginRefreshing];
}


- (void)endRefresh{
    [customTableView.mj_footer endRefreshing];
    [customTableView.mj_header endRefreshing];
}
- (void)endRefreshWithStillHaveData:(BOOL)stillHaveData{
    [self endRefresh];
    self.stillHaveData = stillHaveData;
}


@end

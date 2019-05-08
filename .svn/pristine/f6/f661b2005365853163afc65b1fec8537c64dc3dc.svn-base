//
//  UserManageViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-3-6.
//
//

#import "UserManageViewController.h"
#import "RequestService.h"
#import "AppDelegate.h"
#import "Define.h"
#import "UserManageCell.h"
#import "MJRefresh.h"
#import "Tab0ViewCell.h"
#import "KMDatePicker.h"
#import "KMDatePickerDateModel.h"
#import "ChangeKeyDateViewController.h"
#import "XYCUtils.h"
typedef void(^TableViewPullRefrshBlock)();

@interface UserManageViewController ()<KMDatePickerDelegate>
{
    
    KeyModel * selectedKey;
    
}

@property (nonatomic, assign) BOOL stillHaveData;

@property (nonatomic, assign) NSInteger pageNo;

@end


@implementation UserManageViewController

@synthesize currentKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"keydetail_item_title_manage", nil);
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

-(void)gotUsers:(NSMutableArray*)usersGot success:(BOOL)success isFromNet:(BOOL)isFromNet
{
   
    if (usersGot) {
        
        if ([usersGot count]>0) {
            
            [label_no_user setHidden:YES];
        }else{
            
            [label_no_user setHidden:NO];
        }
        keys = usersGot;
        
    }else{
        
        [label_no_user setHidden:NO];
    }

    
    [customTableView reloadData];
    [aiv stopAnimating];
    [aiv setHidden:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LS(@"btn_title_clear") style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllKey)];
    
    [label_no_user setText:LS(@"words_no_user")];
    [label_no_user setHidden:YES];
    
    
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
    
    [aiv setHidden:YES];
    
    [aiv startAnimating];
    
    _pageNo = pageNo;
    [NetworkHelper keyListOfLock:currentKey.lockId pageNo:pageNo completion:^(id info, NSError *error) {
        [customTableView.mj_footer endRefreshing];
        [customTableView.mj_header endRefreshing];
        if (error) return ;
        
        NSMutableArray *datas = [KeyModel mj_objectArrayWithKeyValuesArray:info[@"list"]];
        if (pageNo == 1) {
            keys = [NSMutableArray array];
            keys = datas;
        }else{
            [keys addObjectsFromArray:datas];
            self.stillHaveData = datas.count == 20;
        }
        
        [customTableView reloadData];
        if (datas.count)
            self.pageNo++;
        
    }];
    
    
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keys.count;
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
    

    
    KeyModel *keyModel = keys[indexPath.row];
    
    cell.leftTopLabel.text = [NSString stringWithFormat:@"id:%@",keyModel.username];
    
    if (keyModel.startDate == keyModel.endDate) {
        
        cell.leftBottomLabel.text = NSLocalizedString(@"words_e_key_forever", nil);
        
    }else{
        
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:keyModel.startDate/1000];
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:keyModel.endDate/1000];
        
        cell.leftBottomLabel.numberOfLines = 0;
        cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@--%@",[XYCUtils formateDate:startDate format:@"yyyy/MM/dd HH:mm"],[XYCUtils formateDate:endDate format:@"yyyy/MM/dd HH:mm"]];
        
    }
    if ([keyModel.keyStatus isEqualToString:@"110401"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_Received");
    }else if ([keyModel.keyStatus isEqualToString:@"110402"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_Receiving");
    }else if ([keyModel.keyStatus isEqualToString:@"110404"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_Blocking");
    }else if ([keyModel.keyStatus isEqualToString:@"110405"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_Blocked");
    }else if ([keyModel.keyStatus isEqualToString:@"110406"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_UnBlocking");
    }else if ([keyModel.keyStatus isEqualToString:@"110407"]) {
        cell.rightLabel.text = LS(@"words_key_state_type_deleteing");
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedKey =[keys objectAtIndex:indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:LS(@"words_operate")
                                  delegate:self
                                  cancelButtonTitle:LS(@"words_cancel")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:LS(@"words_delete"),LS(@"words_blocked"),LS(@"words_unblocked"),LS(@"words_Change_Validity"),nil];

    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
    
    NSLog(@"will selected");
}

-(void)cancelAlert
{
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        
    }
    
}

-(void)showAlert
{
    
    if(alertView&&!alertView.isHidden){
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:LS(@"words_wait_please")
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles: nil];
    [alertView show];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 4:
    
            return;
            
            break;
            
            
        case 3:
            
        {
            ChangeKeyDateViewController *changeKeyDateVc = [ChangeKeyDateViewController new];
            
            KeyModel *keyModel = keys[actionSheet.tag];
            changeKeyDateVc.startDate = keyModel.startDate;
            changeKeyDateVc.endDate = keyModel.endDate;
            changeKeyDateVc.keyId = keyModel.keyId;
            
            [self.navigationController pushViewController:changeKeyDateVc animated:YES];
        }
            return;
            
            break;
        case 2:
            
        {

            [NetworkHelper unFreezeKey:selectedKey.keyId completion:^(id info, NSError *error) {
                if (!error) {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_unblock_success", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                    [alertViewtmp show];
                    alertViewtmp.tag = 100;
                    
                    [customTableView.mj_header beginRefreshing];
                }else {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_unblock_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                    alertViewtmp.tag = 100;
                    [alertViewtmp show];

                }
            }];
            
            
            break;
        }
            
        case 1:
        {

            
            [NetworkHelper freezeKey:selectedKey.keyId completion:^(id info, NSError *error) {
                if (!error) {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_block_success", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                    alertViewtmp.tag = 100;
                    [alertViewtmp show];
                    
                    
                    [customTableView.mj_header beginRefreshing];

                }else {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:NSLocalizedString(@"words_block_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                    alertViewtmp.tag = 100;
                    [alertViewtmp show];
                    
                }
            }];

            
            
            break;
        }
        case 0:
        {
            
            [NetworkHelper deleteKey:selectedKey.keyId completion:^(id info, NSError *error) {
                if (!error) {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:LS(@"words_delete_success") delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
                    alertViewtmp.tag = 100;
                    [alertViewtmp show];
                    
                    [customTableView.mj_header beginRefreshing];
                    
                }else {
                    UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:LS(@"alert_title_alert") message:LS(@"words_delete_fail") delegate:self cancelButtonTitle:LS(@"words_sure_ok") otherButtonTitles: nil];
                    alertViewtmp.tag = 100;
                    [alertViewtmp show];
                    
                }

            }];
            
            break;
        }
        default:
            break;
    }
    
}

- (void)deleteAllKey
{
    [NetworkHelper deleteAllKey:selectedKey.lockId completion:^(id info, NSError *error) {
        if (!error) {
            UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:LS(@"alert_request_success") delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
            alertViewtmp.tag = 100;
            [alertViewtmp show];
            
            [customTableView.mj_header beginRefreshing];

        }else {
            UIAlertView* alertViewtmp = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil) message:LS(@"alert_request_error") delegate:self cancelButtonTitle:NSLocalizedString(@"words_sure_ok", nil) otherButtonTitles: nil];
            alertViewtmp.tag = 100;
            [alertViewtmp show];
            
            [customTableView.mj_header beginRefreshing];
        }
    }];
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


#pragma mark - KMDataPicker

- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate
{
    
}

@end

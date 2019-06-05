//
//  ParkKeyDetailVC.m
//
//  Created by wjjxx on 16/8/25.
//  Copyright © 2016年 TTLock. All rights reserved.
//

#import "ParkKeyDetailVC.h"
#import "DateHelper.h"
#import "AppDelegate.h"
#import "RequestService.h"


@interface ParkKeyDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation ParkKeyDetailVC{
    UITableView *_tableView;
    NSArray *_dataArray;
    AppDelegate * delegate;
     UITextField * backUpPs;
}
@synthesize selectedKey;

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = selectedKey.lockAlias;
    self.automaticallyAdjustsScrollViewInsets = NO;
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)createTableView{

     _dataArray = @[@[LS(@"words_rise"),LS(@"words_fall")]];
  
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 20;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"keydetailcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    
    return (UITableViewCell *) cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                  if ([BlueToothHelper getBlueState]) {
                      [self showHUD:nil];
                    [TTLockHelper connectKey:self.selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                        if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                            NSLog(@"bu KKBLE_CONNECT_SUCCESS");
                            [self showLockNotNearToast];
                     
                            return ;
                        }
                        [TTLockHelper lock:selectedKey lockBlock:^(id info, BOOL succeed) {
                            if (!succeed) {
                                [self showLockOperateFailed];
                            }
                        }];
                    }];
                  }
                }break;
                case 1:{
                    if ([BlueToothHelper getBlueState]) {
                         [self showHUD:nil];
                        [TTLockHelper connectKey:selectedKey connectBlock:^(CBPeripheral *peripheral, KKBLE_CONNECT_STATUS connectStatus) {
                            if (connectStatus != KKBLE_CONNECT_SUCCESS) {
                                [self showLockNotNearToast];
                                return ;
                            }
                            [TTLockHelper unlock:selectedKey unlockBlock:^(id info, BOOL succeed) {
                                if (!succeed) {
                                    [self showLockOperateFailed];
                                }
                            }];
                        }];
                    }
                }break;
                
                default:
                    break;
            }
        } break;
        default:
            break;
    }
    
    
    return nil;
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

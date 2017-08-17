//
//  FirstViewController.m
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Tab0ViewCell.h"
#import "MyLog.h"
#import "KeyDetailViewController.h"
#import "RequestService.h"
#import "AddLockGuider1ViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "ProgressHUD.h"
#import "ParkKeyDetailVC.h"
#import "LoginViewController.h"
#import "XYCUtils.h"
#import "AccountInfoViewController.h"
#import <MJExtension/MJExtension.h>
#import "KeyTableViewController.h"
#import "LockViewController.h"
#import "PlugListViewController.h"
@interface Tab0ViewController()
{
    
    UIView * loadingView;
    
    Key * selectedKey;
    LockModel *backupKeySelected;
    NSArray *_datas;
    NSMutableArray *keyArray;
    NSMutableArray *ekeyArray;
    NSIndexPath *backupKeyIndexPath;
    
}

@end

BOOL keydetailAppear;
@implementation Tab0ViewController

@synthesize customTableView;


bool DEBUG_TAB0 = true;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"tab0_title", @"sciener");
        
        //左边按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通通锁登录" style:UIBarButtonItemStylePlain target:self action:@selector(gotoLogin:)];
        
        //右边按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
        
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

-(void)rightAction:(id)sender
{
   
    if (![SettingHelper getAccessToken]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请先点击左侧‘登录’按钮，获取accesstoken" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.navigationController pushViewController:[[AddLockGuider1ViewController alloc] initWithNibName:@"AddLockGuider1ViewController" bundle:nil] animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidload");

    _datas = @[@"帐号信息",@"已添加锁",@"已添加钥匙",@"网关"];
    
    [self setExtraCellLineHidden:customTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
   [super viewDidAppear:animated];
    [customTableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if ([SettingHelper getAccessToken]) {
        
    }
    
    keyArray = [[DBHelper sharedInstance] fetchKeys];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"tab0 ####didReceiveMemoryWarning####");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"CellDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _datas[indexPath.row];
    
    return cell;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[AccountInfoViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[LockViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[KeyTableViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[PlugListViewController new] animated:YES];
            break;
        default:
            break;
    }
}

-(IBAction)gotoLogin:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
//    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appdelegate.scienerObject authorize];
}


@end

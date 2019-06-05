//
//  FirstViewController.m
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import "Tab0ViewController.h"
#import "KeyDetailViewController.h"
#import "RequestService.h"
#import "AddLockViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "LoginViewController.h"
#import "AccountInfoViewController.h"
#import <MJExtension/MJExtension.h>
#import "KeyTableViewController.h"
#import "PlugListViewController.h"
#import "AddLockViewController.h"

@interface Tab0ViewController()
{
    
    UIView * loadingView;
    
    KeyModel * selectedKey;
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
        
        self.title = LS(@"tab0_title");
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:LS(@"words_login") style:UIBarButtonItemStylePlain target:self action:@selector(gotoLogin:)];

        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidload");

    _datas = @[LS(@"words_Account_information"),LS(@"words_Add_Device"),LS(@"words_key_list"),LS(@"words_WiFi_gateway")];
    
    [self setExtraCellLineHidden:customTableView];
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
    if (![SettingHelper getAccessToken]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:LS(@"alert_click_on_the_left_Login_button_first_to_get_accesstoken") message:nil delegate:self cancelButtonTitle:LS(@"words_sure_ok") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[AccountInfoViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[AddLockViewController new] animated:YES];
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
//    [appdelegate.TTObject authorize];
}


@end

//
//  AddLockViewController.m
//  Sciener
//
//  Created by wjjxx on 16/4/28.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "AddLockViewController.h"
#import "AppDelegate.h"
#import "AddLockModel.h"
#import "BlueToothHelper.h"
#import "DiscoverDeviceCell.h"
#import "OnFoundDeviceModel.h"
#import "Key.h"

@interface AddLockViewController ()<TTSDKDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddLockViewController{
    AppDelegate *_delegate;
    NSMutableArray * _peripherals;
    NSMutableArray *_tempPeripheralsArray;
    UITableView *_tableView;
    //选中蓝牙的广播数据
    NSDictionary* _currentAdvData;
    //添加的门锁
    KeyModel *_keyAdded;
    CBPeripheral * currentPeripheral;

    //判断断开蓝牙时 判断是否把hud取消
    BOOL isAddSuccess;
    BOOL isError;
    NSDate *_bindDate;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TTObjectTTLockHelper.delegate = self;
    //为了兼容二代锁 才设为YES
    [TTObjectTTLockHelper startBTDeviceScan:YES];
    [self createTableView];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     TTObjectTTLockHelper.delegate = TTLockHelperClass;
    [TTObjectTTLockHelper startBTDeviceScan:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //连接设备
    self.title = LS(@"附近的锁"); ;
    self.view.backgroundColor = [UIColor whiteColor];

    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:indicatorView];
    // Do any additional setup after loading the view.
}


- (void)createTableView{
    _peripherals = [NSMutableArray array];
    _tempPeripheralsArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BAR_TOTAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-BAR_TOTAL_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}
#pragma mark ---- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _peripherals.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"Cell2";
    DiscoverDeviceCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DiscoverDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    AddLockModel *model = _peripherals[indexPath.row];
    
    
    Key *dbKey;
    if (model.lockMac && model.lockMac.length > 0) {
        dbKey = [[DBHelper sharedInstance]fetchKeyWithLockMac:model.lockMac];
    }else{
        dbKey = [[DBHelper sharedInstance]fetchKeyWithDoorName:model.peripheral.name];
    }
   
    if (dbKey) {
        cell.label_left.text = [NSString stringWithFormat:@"%@(%@)",model.peripheral.name,LS(@"words_exist")];
        cell.label_left.textColor = COMMON_FONT_GRAY_COLOR;
        cell.image_right.hidden = YES;
        
    }
    else if (model.isContainAdmin) {
        cell.label_left.text =model.peripheral.name;
        cell.label_left.textColor = COMMON_FONT_GRAY_COLOR;
        cell.image_right.hidden = YES;
    }else{
        cell.label_left.text = model.peripheral.name;
        cell.label_left.textColor = COMMON_FONT_BLACK_COLOR;
        cell.image_right.image = [UIImage imageNamed:@"add"];
        cell.image_right.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AddLockModel *model = _peripherals[indexPath.row];
    Key *dbKey;
    if (model.lockMac && model.lockMac.length > 0) {
        dbKey = [[DBHelper sharedInstance]fetchKeyWithLockMac:model.lockMac];
    }else{
        dbKey = [[DBHelper sharedInstance]fetchKeyWithDoorName:model.peripheral.name];
    }
    //如果本地的锁不存在 并且没有管理员才能添加
    if (!dbKey && model.isContainAdmin == NO) {
        //进行连接
   
        [TTObjectTTLockHelper connect:model.peripheral];
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:DEFAULT_CONNECT_TIMEOUT];
        _currentAdvData = model.advertisementData;
        //    覆盖全局 可以防止误点
        [SSToastHelper showHUDToWindow:nil];
        
    }
}
#pragma mark ---- 蓝牙搜索，连接相关回调
- (void)onFoundDevice_peripheralWithInfoDic:(NSDictionary *)infoDic{
    OnFoundDeviceModel *onFoundModel = [[OnFoundDeviceModel alloc]initOnFoundDeviceModelWithDic:infoDic];
    
    NSString *advName = [onFoundModel.advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (!(advName && advName.length>0)) {
        return;
    }
    //以lock开头的老一代锁 没有mac地址
    if ([onFoundModel.mac isEqualToString: @""]) {
        onFoundModel.protocolCategory = 5;
    }
    //通过版本号 判断是什么类型的锁 如果是carLock车位锁 分二代车位锁和三代车位锁

        if (onFoundModel.peripheral.name && onFoundModel.peripheral.name.length>0) {
            
            int count = 0;
            for (AddLockModel *model in _peripherals) {
                if (model.isContainAdmin == NO) {
                    count++;
                }
            }
            BOOL contain = NO;
            BOOL isExchangePosition = YES;
            int i = 0;
            for (AddLockModel *model in _peripherals) {
                if ([model.peripheral.name isEqual:onFoundModel.peripheral.name]) {
                    if (model.isContainAdmin == onFoundModel.isContainAdmin) {
                        isExchangePosition = NO;
                    }else{
                        isExchangePosition = YES;
                        if (onFoundModel.isContainAdmin == NO) {
                            if (_peripherals.count > count) {
                                [_peripherals exchangeObjectAtIndex:i withObjectAtIndex:count];
                            }
                            
                        }else{
                            [_peripherals exchangeObjectAtIndex:i withObjectAtIndex:count-1];
                        }
                        
                    }
                    contain = YES;
                    model.isContainAdmin = onFoundModel.isContainAdmin;
                    model.searchTime = [NSDate date];
                    break;
                }
                
                i++;
            }
            if (!contain) {
                AddLockModel *model = [[AddLockModel alloc]init];
                model.peripheral = onFoundModel.peripheral;
                model.isContainAdmin = onFoundModel.isContainAdmin;
                model.advertisementData = onFoundModel.advertisementData;
                model.lockMac = onFoundModel.mac;
                model.searchTime = [NSDate date];
                if (onFoundModel.isContainAdmin == NO) {
                    isExchangePosition = YES;
                    [_peripherals insertObject:model atIndex:0];
                }else{
                    isExchangePosition = YES;
                    [_peripherals insertObject:model atIndex:_peripherals.count];
                }
            }
             //超过5秒钟没有被搜索到 状态就要改变
            for (AddLockModel *model in _peripherals) {
                if (model.searchTime.timeIntervalSinceNow < - 5) {
                    if (model.isContainAdmin == NO) {
                        model.isContainAdmin  = YES;
                        isExchangePosition = YES;
                    }
                }
            }
            if (isExchangePosition == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
       }
}


-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{
    
    [TTObjectTTLockHelper stopBTDeviceScan];
    sync_main(^{
         [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    
    NSLog(@"连接上lock:%@ , lockname:%@ ",peripheral.name,lockName);
    _keyAdded = [[KeyModel alloc]init];
    _keyAdded.lockName = lockName;
    //添加的时候别名
    _keyAdded.lockAlias = lockName;
    _keyAdded.peripheralUUIDStr = peripheral.identifier.UUIDString;
    currentPeripheral = peripheral;
    [TTObjectTTLockHelper addAdministrator_advertisementData:_currentAdvData adminPassword:nil deletePassword:nil];
}
- (void)onAddAdministrator_addAdminInfoDic:(NSDictionary *)addAdminInfoDic{
    
    LockVersion *version = [LockVersion new];
    
    NSArray *versionArr = [addAdminInfoDic[@"version"] componentsSeparatedByString:@"."];
    version.protocolType = [[versionArr objectAtIndex:0] integerValue];
    version.protocolVersion = [[versionArr objectAtIndex:1] integerValue];
    version.scene = [[versionArr objectAtIndex:2] integerValue];
    version.groupId = [[versionArr objectAtIndex:3] integerValue];
    version.orgId = [[versionArr objectAtIndex:4] integerValue];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval timeValue = [timeZone secondsFromGMTForDate:[NSDate date]];
    
    _keyAdded.lockVersion = version;
    _keyAdded.lockMac = addAdminInfoDic[@"mac"];
    _keyAdded.adminPwd = addAdminInfoDic[@"adminPS"];
    _keyAdded.lockKey = addAdminInfoDic[@"lockKey"];
    _keyAdded.aesKeyStr = addAdminInfoDic[@"aesKey"];
    //第一次时 标志位默认为0
    _keyAdded.lockFlagPos = 0;
    //永久的时间 都设为0
    _keyAdded.noKeyPwd = addAdminInfoDic[@"adminPassword"];
    _keyAdded.deletePwd = addAdminInfoDic[@"deletePassword"];
    _keyAdded.timezoneRawOffset = timeValue * 1000;
    _keyAdded.timestamp = addAdminInfoDic[@"timestamp"];
    _keyAdded.pwdInfo = addAdminInfoDic[@"pwdInfo"];
    
    [self addAdminSuccess];
    
    
}

- (void)addAdminSuccess{
    
    [NetworkHelper initLock:_keyAdded completion:^(id info, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            [self hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"门锁添加成功" message:nil  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            return ;
        }
        NSLog(@"绑定失败");
    }];

}


- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    
    if (error == TTErrorInvalidClientPara) {
        [self showToast:LS(@"tint_add_Unsupported_lock")];
    }else{
        [self showToast:LS(@"tint_add_lock_Failed")];
    }
    
       isError = YES;
       [TTObjectTTLockHelper disconnect:currentPeripheral];
    
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
}

- (void)onBTDisconnect_peripheral:(CBPeripheral *)periphera{
    
    NSLog(@"%@ onBTDisconnect_peripheral",NSStringFromClass([self class]));
    currentPeripheral = nil;
    
    if (isAddSuccess == NO && isError == NO) {
        [SSToastHelper hideHUD];
    }
    isError = NO ;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [TTObjectTTLockHelper startBTDeviceScan:YES];//重新开始搜索蓝牙
        [_tableView reloadData];
        
    });
}
-(void)connectTimeOut{
     [SSToastHelper hideHUD];
    if (currentPeripheral) {
         [TTObjectTTLockHelper disconnect:currentPeripheral];
         return;
    }
}
- (void)onSetLockTime{
    NSLog(@"onSetLockTime");
    isAddSuccess = YES;
    if (currentPeripheral) {
        //绑定成功后 就断开蓝牙
        [TTObjectTTLockHelper disconnect:currentPeripheral];
        
    }

    [self addAdminSuccess];
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

//
//  AddLockGuider1ViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-2-21.
//
//

#import "AddLockGuider1ViewController.h"
#import "MyLog.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "RequestService.h"
#import "Define.h"
#import "XYCUtils.h"
#import "AddLockModel.h"
#import <MJExtension/MJExtension.h>
#import "SettingHelper.h"
#import "OnFoundDeviceModel.h"

@interface AddLockGuider1ViewController ()
{
    
    CBPeripheral * currentPeripheral;
    
    AppDelegate * delegate;
    //选中蓝牙的广播数据
    NSDictionary* _currentAdvData;
    Key *keyExistNeedToDelete;
    NSMutableArray * _peripherals;
    //添加的门锁
    LockModel *_lockAdded;
    KeyModel *_key;
    //管理员密码
    NSString *_keyBoardPassword;
    //管理员删除密码
    NSString *_deletePassword;
    //当前操作的蓝牙
    CBPeripheral *_currentPeripherals;
    //    NSDictionary * advDataDictionary;
    
}

@end

@implementation AddLockGuider1ViewController

@synthesize showIcons;
@synthesize delegate = _delegate;
@synthesize customActivityText;


static AddLockGuider1ViewController *addLockGuider1Instance=nil;


+(AddLockGuider1ViewController*)sharedInstance
{
    
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!addLockGuider1Instance) {
            
            addLockGuider1Instance = [[self alloc] init]; //该方法会调用 allocWithZone
            
        }
        
    }
    
    return addLockGuider1Instance;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
    if (addLockGuider1Instance) {
        
        addLockGuider1Instance = nil;
    }
    
    [super viewDidDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // init
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.TTObject.delegate = self;
        [delegate.TTObject scanAllBluetoothDeviceNearby];
        _peripherals = [[NSMutableArray alloc]init];
    }
    
    
    return self;
}


-(void)showAlert
{
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;//这句很重要，去掉的话，alertview不为null，即使已经dealloc
        
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:@"请稍候..."
                                          message:nil
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
    [alertView show];
    
}

-(void)cancelAlert
{
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;//这句很重要，去掉的话，alertview不为null，即使已经dealloc
        
    }
    
    [tableViewCustom reloadData];
    
    
}

-(void)nextAction:(id)sender
{
    
    
}

-(void)finishAction:(id)sender
{
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BLEHelper getBlueState];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    addLockGuider1Instance = self;
    
    [tableViewCustom reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    delegate.TTObject.delegate = delegate;
    
   
}
- (void)didReceiveMemoryWarning
{
    NSLog(@"addlock guider 1 ##############didReceiveMemoryWarning###################");
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_peripherals) {
        
        return  _peripherals.count;
    }else{
        
        return 0;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
    }
    
    AddLockModel *model = _peripherals[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(mac:%@)",model.peripheral.name,model.lockMac];
    
    Key *dbKey ;
    if (dbKey.lockMac.length > 0) {
        dbKey = [[DBHelper sharedInstance]fetchKeyWithLockMac:model.lockMac];
    }else{
        dbKey = [[DBHelper sharedInstance]fetchKeyWithDoorName:model.peripheral.name];
    }
    if (dbKey) {
        cell.detailTextLabel.text = @"钥匙已经存在";
    }
    else if (model.isContainAdmin) {
        cell.detailTextLabel.text = @"处于非设置模式，不可添加";
    }else{
        cell.detailTextLabel.text = @"新";
    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
    
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddLockModel *model = _peripherals[indexPath.row];
    
    
    Key *dbKey = [[DBHelper sharedInstance] fetchKeyWithDoorName:model.peripheral.name];
    
    if ([SettingHelper getOpenID].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先登录, 才能添加管理员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else
        if (dbKey) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"已存在一把对应的钥匙,请删除后重新添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    else if (model.isContainAdmin == NO) {
        //进行连接
        [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:20];
        _currentAdvData = model.advertisementData;
        [self showAlert];
        NSLog(@"去连接%@",model.peripheral.name);
        _currentPeripherals = model.peripheral;
        [delegate.TTObject connect:model.peripheral];
        
    }else{
        //        [UIView showAlertView:NSLocalizedString(@"alert_title_alert", nil) andMessage:NSLocalizedString(@"alert_msg_admin_has_exist", nil)];
        //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"alert_msg_admin_has_exist", nil)];
        
    }
    
    return indexPath;
}

-(void)connectTimeOut{
    
    [self cancelAlert];
    
}
#pragma mark ---- 蓝牙搜索，连接相关回调
-(void)onFoundDevice_peripheralWithInfoDic:(NSDictionary*)infoDic
{
    OnFoundDeviceModel *deviceModel = [[OnFoundDeviceModel alloc] initOnFoundDeviceModelWithDic:infoDic];
    
    NSLog(@"%@ %@ %d",deviceModel.peripheral.name,deviceModel.mac,deviceModel.protocolCategory);
    NSString *advName = [deviceModel.advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (!(advName && advName.length>0)) {
        return;
    }
    //以lock开头的老一代锁 没有mac地址
    if ([deviceModel.mac isEqualToString: @""]) {
        deviceModel.protocolCategory = 5;
    }
    //通过版本号 判断是什么类型的锁
    if (deviceModel.peripheral.name && deviceModel.peripheral.name.length>0) {
        
        BOOL contain = NO;
        
        for (AddLockModel *model in _peripherals) {
            //名字和mac都相同 那说明是同一把
            if ([model.peripheral.name isEqual:deviceModel.peripheral.name] && [model.lockMac isEqual:deviceModel.mac]) {
                contain = YES;
                model.isContainAdmin = deviceModel.isContainAdmin;
                break;
            }
        }
        if (!contain) {
            AddLockModel *model = [[AddLockModel alloc]init];
            model.peripheral = deviceModel.peripheral;
            model.isContainAdmin = deviceModel.isContainAdmin;
            model.advertisementData = deviceModel.advertisementData;
            model.lockMac = deviceModel.mac;
            model.protocolCategory = deviceModel.protocolCategory;
            [_peripherals addObject:model];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableViewCustom reloadData];
        });
    }

}

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{
    //扫描先停止 防止数据错乱
     [delegate.TTObject stopBTDeviceScan];
    
    AddLockModel *lockModel = [AddLockModel new];
    for (AddLockModel *addLockModel in _peripherals) {
        if (peripheral == addLockModel.peripheral) {
            lockModel = addLockModel;
        }
    }
    
    if (lockModel.protocolCategory == 0x3412) {
        [delegate.TTObject setWristbandKey:@"654321" isOpen:YES];
    }
    
    else{
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
        NSLog(@"连接上lock:%@ , lockname:%@",peripheral.name,lockName);
        _lockAdded = [[LockModel alloc]init];
        _key = [[KeyModel alloc] init];
        _lockAdded.lockAlias = lockName;
        //添加的时候别名和管理员一样
        _lockAdded.lockName = lockName;
        _lockAdded.peripheralUUIDStr = peripheral.identifier.UUIDString;
        
        _key.lockName = lockName;
        _key.lockAlias = lockName;
        _key.peripheralUUIDStr = peripheral.identifier.UUIDString;
        
        currentPeripheral = peripheral;

        [delegate.TTObject addAdministrator_advertisementData:_currentAdvData adminPassword:nil deletePassword:nil];
    
    //    [delegate.TTObject getProtocolVersion];
        
        
    }
    
}
- (void)onGetProtocolVersion:(NSString *)versionStr{
//    if ([versionStr hasSuffix:@"11.1"]) {
//         delegate.TTObject.setClientPara = @"IGLOOHOME";
//    }
     [delegate.TTObject addAdministrator_advertisementData:_currentAdvData adminPassword:_keyBoardPassword deletePassword:_deletePassword];
}

- (void)onAddAdministrator_adminPS:(NSString *)adminPS lockKey:(NSString *)lockkey aesKey:(NSString *)aesKey version:(NSString *)versionStr mac:(NSString *)mac timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo electricQuantity:(int)electricQuantity adminPassword:(NSString *)adminPassward deletePassword:(NSString *)deletePassward Characteristic:(int)characteristic{
    
    LockVersion *version = [LockVersion new];

    NSArray *versionArr = [versionStr componentsSeparatedByString:@"."];
    version.protocolType = [[versionArr objectAtIndex:0] integerValue];
    version.protocolVersion = [[versionArr objectAtIndex:1] integerValue];
    version.scene = [[versionArr objectAtIndex:2] integerValue];
    version.groupId = [[versionArr objectAtIndex:3] integerValue];
    version.orgId = [[versionArr objectAtIndex:4] integerValue];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval timeValue = [timeZone secondsFromGMTForDate:[NSDate date]];

    _lockAdded.lockVersion = version;
    _lockAdded.lockMac = mac;
    _lockAdded.adminPwd = adminPS;
    _lockAdded.lockKey = lockkey;
    _lockAdded.aesKeyStr = aesKey;
    //第一次时 标志位默认为0
    _lockAdded.lockFlagPos = 0;
    //永久的时间 都设为0
    _lockAdded.noKeyPwd = adminPassward;
    _lockAdded.deletePwd = deletePassward;
    _lockAdded.timezoneRawOffset = timeValue * 1000;
    _lockAdded.timestamp = timestamp;
    _lockAdded.pwdInfo = pwdInfo;
    _lockAdded.specialValue = characteristic;
    
    
    _key.startDate = 0;
    _key.aesKeyStr = aesKey;
    _key.lockKey = lockkey;
    _key.keyStatus = KeyStatusReceived;
    _key.endDate = 0;
    _key.lockMac = mac;
    _key.userType = @"110301";
    _key.lockFlagPos = 0;
    _key.adminPwd = adminPS;
    _key.noKeyPwd = adminPassward;
    _key.deletePwd = deletePassward;
    _key.electricQuantity = electricQuantity;
    _key.lockVersion = version;
    _key.username = [SettingHelper getOpenID];
    _key.timezoneRawOffset = timeValue * 1000;

    
    [self addAdminSuccess];
    
}
- (void)addAdminSuccess{
    
    
    extern BOOL calibrationPress;
    calibrationPress = YES;
    
    if (_lockAdded.lockVersion.protocolType == 5 && _lockAdded.lockVersion.protocolVersion == 3) {
        extern NSString *v3AllowMac;
        v3AllowMac = _lockAdded.lockMac;
    }else{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"请触摸唤醒锁键盘以完成操作"];
    }

    
    [NetworkHelper initLock:_lockAdded completion:^(id info, NSError *error) {
        if (!error) {
            
            _key.keyId = ((NSString *)info[@"keyId"]).intValue;
            _key.lockId = ((NSString *)info[@"lockId"]).intValue;
            
            [[DBHelper sharedInstance]saveKey:_key];
            [self cancelAlert];
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"门锁添加成功" message:[NSString stringWithFormat:@"电量值:%d", [delegate.TTObject getPower]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

            return ;
        }
        NSLog(@"绑定失败");
    }];
    
    
}

- (void)uploadKeyboardPS{
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue1, ^(void){
        __block int ret;
        dispatch_sync(queue1, ^(void){
            ret = [RequestService resetKeyboardPasswordWithLockId:_lockAdded.lockId pwdInfo:_lockAdded.pwdInfo timestamp:_lockAdded.timestamp];
        });
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            if (ret == 0) {
                NSLog(@"重置键盘密码上传成功");
                
            }else{
                NSLog(@"重置键盘密码上传失败");
            }
            
        });
    });
}

- (void)onSetWristbandKey
{
    [self cancelAlert];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"onSetWristbandKey"];
    [delegate.TTObject disconnect:_currentPeripherals];
}

- (void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
}
- (void)onSetLockTime
{
    NSLog(@"校验时间成功");
}
-(void)onBTDisconnect_peripheral:(CBPeripheral *)periphera
{
    [delegate.TTObject scanAllBluetoothDeviceNearby];
    NSLog(@"断开蓝牙 disconnect");
}

@end

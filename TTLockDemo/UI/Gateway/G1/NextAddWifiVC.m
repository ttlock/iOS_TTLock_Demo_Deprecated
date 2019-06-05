//
//  NextAddWifiVC.m
//  TTLockDemo
//
//  Created by 王娟娟 on 2019/6/4.
//  Copyright © 2019 wjj. All rights reserved.
//

#import "NextAddWifiVC.h"
#import "RoundCornerButton.h"
#import "MBProgressHUD.h"

@interface NextAddWifiVC ()
@property (nonatomic,strong)NSString* wifiMac;
@end

@implementation NextAddWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeaderView];
    // Do any additional setup after loading the view.
}
- (void)createHeaderView{
    
    UIView *bgHeaderView = [UIView new];
    //这里如果不固定frame 在iOS8上适配有问题
    bgHeaderView.frame = CGRectMake(0, BAR_TOTAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - BAR_TOTAL_HEIGHT);
    bgHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgHeaderView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = LS(@"words_long_press_the_setting_key");
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [bgHeaderView addSubview:titleLabel];

    
    UIImageView *wifiImgview = [UIImageView new];
    wifiImgview.image = IMG(@"G1Introduce");
    [bgHeaderView addSubview:wifiImgview];
    
    UILabel *tintLbabel = [UILabel new];
    tintLbabel.text = LS(@"words_Long_press_the_setting_key_And_then_press_the_Next_button");
    tintLbabel.font = [UIFont systemFontOfSize:14];
    tintLbabel.numberOfLines = 0 ;
    tintLbabel.lineBreakMode = NSLineBreakByWordWrapping;
    tintLbabel.textAlignment = NSTextAlignmentCenter;
    tintLbabel.textColor = RGBFromHexadecimal(0x333333);
    [bgHeaderView addSubview:tintLbabel];
    
    UILabel *settingKeyLabel = [UILabel new];
    settingKeyLabel.textColor = RGBFromHexadecimal(0x999999);
    settingKeyLabel.font = [UIFont systemFontOfSize:13];
    settingKeyLabel.text = LS(@"words_Setting_key");
    settingKeyLabel.numberOfLines = 0;
    settingKeyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgHeaderView addSubview:settingKeyLabel];
    
    UILabel *indicatorLabel = [UILabel new];
    indicatorLabel.textColor = RGBFromHexadecimal(0x999999);
    indicatorLabel.font = [UIFont systemFontOfSize:13];
    indicatorLabel.text = LS(@"words_Green_LED_Indicator");
    indicatorLabel.textAlignment = NSTextAlignmentRight;
    indicatorLabel.numberOfLines = 0;
    indicatorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgHeaderView addSubview:indicatorLabel];
    
    //有效期
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bgHeaderView).offset(25);
        make.centerX.equalTo(bgHeaderView);
        make.width.equalTo(300);
    }];
    
    [wifiImgview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.bottom).offset(50);
        make.centerX.equalTo(titleLabel);
        make.width.equalTo(130);
        make.height.equalTo(200);
    }];
    
    
    [tintLbabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wifiImgview.bottom).offset(30);
        make.width.equalTo(300);
        make.centerX.equalTo(titleLabel);
    }];
    
    [settingKeyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiImgview).offset(45);
        make.left.equalTo(wifiImgview.right);
        make.right.equalTo(bgHeaderView).offset(-10);
    }];
    [indicatorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wifiImgview).offset(-28);
        make.right.equalTo(wifiImgview.left);
        make.left.equalTo(bgHeaderView).offset(10);;
        
    }];
    
    RoundCornerButton *addButton = [RoundCornerButton buttonWithTitle:LS(@"words_next") cornerRadius:4 borderWidth:0.5];
    [addButton addTarget:self action:@selector(gatewayAddButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(tintLbabel);
        make.height.mas_equalTo(50);
        make.top.equalTo(tintLbabel.mas_bottom).offset(20);
    }];
    
}
- (void)gatewayAddButtonClick{
    WS(weakSelf);
    NSMutableDictionary *ginfoDic = [NSMutableDictionary new];
    ginfoDic[@"SSID"] = self.SSID;
    ginfoDic[@"wifiPwd"] = self.wifiPwd;
    ginfoDic[@"uid"] = self.uid;
    ginfoDic[@"userPwd"] = self.userPwd;
    
     MBProgressHUD *hud = [self showProgress:@"0%"];
    [TTLockGateway startWithInfoDic:ginfoDic  processblock:^(NSInteger process) {
        hud.progress = process/100.0;
        hud.label.text  = [NSString stringWithFormat:@"%ld%%",(long)process];
        
    } successBlock:^(NSString *ip, NSString *mac) {
        weakSelf.wifiMac = mac;
        [weakSelf isUploadSuccess];
        [hud hideAnimated:NO];
    } failBlock:^ {
        [hud hideAnimated:NO];
        [weakSelf showToast :LS(@"hint_make_sure_the_gateway_is_in_adding_status")];
        
    }];
}
- (void)isUploadSuccess{
    
    [self showHUD:nil];
    [NetworkHelper isInitSuccessWithGatewayNetMac:self.wifiMac completion:^(id info, NSError *error) {
        if (error== nil) {
            //成功
            [self showHUD:LS(@"alter_Succeed")];
         
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        }
    }];
}
- (MBProgressHUD *)showProgress:(NSString *)text{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text ?: @"";
    return hud;
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

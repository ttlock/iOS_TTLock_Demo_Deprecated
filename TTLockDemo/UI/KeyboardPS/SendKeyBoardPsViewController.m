//
//  SendKeyBoardPsViewController.m
//  Sciener
//
//  Created by wjjxx on 16/10/10.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "SendKeyBoardPsViewController.h"
#import "CopyableLabel.h"
#import "ProgressHUD.h"
#import "RequestService.h"
@interface SendKeyBoardPsViewController ()

@end

@implementation SendKeyBoardPsViewController{
    UIButton * mBtn10m;
    UIButton * mBtn1d;
    UIButton * mBtn2d;
    UIButton * mBtn3d;
    UIButton * mBtn4d;
    UIButton * mBtn5d;
    UIButton * mBtn6d;
    UIButton * mBtn7d;
    NSArray *_dataArray;
    NSArray *_titleArray;
    TimePsGroup mCurTimePsGroup;
    UILabel *_desLabel;
    //放生成密码的label
    CopyableLabel *_generatePwdLabel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"send_keyboard_password", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArray =@[LS(@"words_min"),LS(@"words_Lock_1day"),LS(@"words_Lock_2days"),LS(@"words_Lock_3days"),LS(@"words_Lock_4days"),LS(@"words_Lock_5days"),LS(@"words_Lock_6days"),LS(@"words_Lock_7days")];
    _dataArray = @[LS(@"words_Lock_1day"),LS(@"words_Lock_2days"),LS(@"words_Lock_3days"),LS(@"words_Lock_4days"),LS(@"words_Lock_5days"),LS(@"words_Lock_6days"),LS(@"words_Lock_7days"),LS(@"words_min")];
    [self createHeaderView];
    // Do any additional setup after loading the view.
}

- (void)createHeaderView{
    float width = SCREEN_WIDTH/4;
    for (int i = 0;  i < 8; i ++) {
        UIButton *button = [self createBtn];
        if(i== 0)button.selected = YES;
        if (i < 4) {
             button.frame = CGRectMake( width *i, 15 + 60, width, 25);
        }else{
            button.frame = CGRectMake( width * (i-4), 15 + 25+15 + 60, width, 25);
        }
        button.tag =10+ i;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
     mCurTimePsGroup = TIME_PS_GROUP_DAY_10M;
    [self createMiddleView];
}
- (void)createMiddleView{
    
    UIButton  *generateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [generateButton setTitle:LS(@"word_generate_passcode") forState:UIControlStateNormal];
    [generateButton setBackgroundColor:COMMON_BLUE_COLOR];
    [generateButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:generateButton];
    [generateButton addTarget:self action:@selector(generateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _generatePwdLabel = [[CopyableLabel alloc]init];
    _generatePwdLabel.font = [UIFont systemFontOfSize:16];
    _generatePwdLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _generatePwdLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_generatePwdLabel];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = COMMON_FONT_BLACK_COLOR;
    [self.view addSubview:lineLabel];
    
    [generateButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(40);
        make.width.equalTo(150);
        make.top.equalTo(self.view.mas_top).offset(60+15 + 25+15 +25+15 + 10 + 10);
    }];
    [_generatePwdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(40);
        make.right.equalTo(generateButton.mas_left).offset(0);
        make.centerY.equalTo(generateButton.centerY);
    }];
    
    [lineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_generatePwdLabel);
        make.top.equalTo(_generatePwdLabel.mas_bottom).offset(-1);
        make.height.equalTo(1);
    }];

//     CGSize size = [self sizeWithString:desLabel.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT)];
    
    _desLabel = [[UILabel alloc]init];
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.numberOfLines = 0;
    _desLabel.textColor = COMMON_FONT_GRAY_COLOR;
    _desLabel.font = [UIFont systemFontOfSize:15];
    _desLabel.text = [NSString stringWithFormat:@"%@:\n1 %@\n2 %@",LS(@"words_Notes"),LS(@"words_Lock_first_tips"),LS(@"words_Lock_second_tips")];
    [self.view addSubview:_desLabel];
    [_desLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(generateButton.mas_bottom).offset(15+10);
        make.width.equalTo(SCREEN_WIDTH - 20);
    }];
}
//生成密码
- (void)generateButtonClick{
    [ProgressHUD show:NSLocalizedString(@"words_wait_please", nil)];

    
    [NetworkHelper getKeyboardPwd:_selectedKey.lockId keyboardPwdVersion:1 keyboardPwdType:mCurTimePsGroup startDate:@"" endDate:@"" completion:^(id info, NSError *error) {
        [ProgressHUD dismiss];
        if (!error) {
            _generatePwdLabel.text = @"成功";
        }else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert_title_alert", nil)
                                                            message:NSLocalizedString(@"alert_msg_title_request_error", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"words_cancel", nil)
                                                  otherButtonTitles:nil];
            [alert show];

        }
    }];
    
}


- (void)buttonClick:(UIButton*)button{
    for (int i = 0 ; i < 8; i++) {
        if (button.tag != i +10) {
            UIButton *inbutton =(UIButton*)[self.view viewWithTag:i+10];
            [inbutton setSelected:NO];
        }else{
            button.selected = YES;
        }
    }
   
    if (button.tag == 10) {
        mCurTimePsGroup = TIME_PS_GROUP_DAY_10M;
    }else{
        mCurTimePsGroup = (int)button.tag - 10;
    }
}
- (UIButton*)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radio_btn_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radio_btn_checked"] forState:UIControlStateSelected];
    [self.view addSubview:button];
    return button;
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

//
//  SendKpsViewController.m
//  Sciener
//
//  Created by wjjxx on 16/10/10.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "SendKpsViewController.h"
#import "CopyableLabel.h"
#import "RequestService.h"
@interface SendKpsViewController ()<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) int keyboardPwdVersion;
@property (nonatomic, assign) int keyboardPwdType;
@property (nonatomic, assign) int lastKeyboardPwdType;
@property (nonatomic, assign) int flag;
@property (nonatomic, retain)NSMutableArray *mPickerArray;
@property (nonatomic, retain)NSMutableArray *mPickerNumberArray;

@end

@implementation SendKpsViewController{
    UIPickerView * mPickerViewNumber;
    UIPickerView * mPickerView;
    NSInteger mPickerViewRow;
    NSInteger mPickerViewNumberRow;
    CopyableLabel *_generatePwdLabel;
    UILabel *_desLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"send_keyboard_password", nil);
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView{
 
    mPickerViewNumber = [[UIPickerView alloc]initWithFrame:CGRectMake(8, -40 + 60, (SCREEN_WIDTH - 8*2 - 10 )/2, 160)];
    mPickerViewNumber.delegate = self;
    mPickerViewNumber.dataSource = self;
    [self.view addSubview:mPickerViewNumber];
    mPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (SCREEN_WIDTH - 8*2 - 10 )/2 - 8, -40 + 60, (SCREEN_WIDTH - 8*2 - 10 )/2, 160)];
    mPickerView.delegate = self;
    mPickerView.dataSource = self;
    [self.view addSubview:mPickerView];
    [self createPickerArray];
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
        make.top.equalTo(self.view.mas_top).offset(60+100 +35+10);
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
    _desLabel.text = LS(@"words_Lock_first_tips");
    [self.view addSubview:_desLabel];
    [_desLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(generateButton.mas_bottom).offset(15+10);
        make.width.equalTo(SCREEN_WIDTH - 20);
    }];
}
- (void)createPickerArray{
    /**
     *  2+ Scene one is different from the keyboard code of scene two
     */
    if ([_selectedKey.lockVersion hasPrefix:@"5.4.1"]) {
        self.mPickerArray = [NSMutableArray arrayWithObjects: NSLocalizedString(@"single_password", nil),NSLocalizedString(@"min_password", nil),NSLocalizedString(@"hour_password", nil),NSLocalizedString(@"day_password", nil),NSLocalizedString(@"month_password_one", nil), nil];
        _keyboardPwdVersion = 2;
        
    } else if ([_selectedKey.lockVersion hasPrefix:@"5.4.2"]) {
        self.mPickerArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"single_password", nil),NSLocalizedString(@"min_password", nil),NSLocalizedString(@"hour_password", nil),NSLocalizedString(@"day_password", nil),NSLocalizedString(@"month_password", nil),NSLocalizedString(@"forever_password", nil), nil];
        _keyboardPwdVersion = 3;
    }
    self.keyboardPwdType = 0;
    self.mPickerNumberArray = [NSMutableArray arrayWithObjects:@"1", nil];
}

#pragma mark ----- UIPickerViewDelegate UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([pickerView isEqual:mPickerViewNumber]) {
        
        return [self.mPickerNumberArray count];
    }
    return [self.mPickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if ([pickerView isEqual:mPickerViewNumber]) {
        
        return [self.mPickerNumberArray objectAtIndex:row];
    }
    return [self.mPickerArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:mPickerView]) {
        if (mPickerViewRow != row) {
            mPickerViewRow = row;
 
            [mPickerViewNumber selectRow:0 inComponent:component animated:NO];
            mPickerViewNumberRow = 0 ;
            
        }
        switch (row) {
                
            case 0:
           
                self.flag=0;
                self.keyboardPwdType = 0;
                self.mPickerNumberArray = [NSMutableArray arrayWithObjects:@"1", nil];
                [mPickerViewNumber reloadAllComponents];
                break;
            case 1:
              
                self.flag=1;
                self.mPickerNumberArray = [NSMutableArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50", nil];
                //重新加载所有组件
                [mPickerViewNumber reloadAllComponents];
                self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue]/10;
                break;
            case 2:
           
                self.flag=2;
                self.mPickerNumberArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
                [mPickerViewNumber reloadAllComponents];
                self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] + 5;
                break;
            case 3:
               
                self.flag=3;
                if ([_selectedKey.lockVersion hasPrefix:@"5.4.1"]) {
                    
                    self.mPickerNumberArray = [NSMutableArray arrayWithObjects:
                                               @"1",@"2",@"3",@"4",@"5",
                                               @"6",@"7",@"8",@"9",@"10",
                                               @"11",@"12",@"13",@"14",@"15",
                                               @"16",@"17",@"18",@"19",@"20",
                                               @"21",@"22",@"23",@"24",@"25",
                                               @"26",@"27",@"28",@"29",@"30",
                                               @"31",@"32",@"33",@"34",@"35",
                                               @"36",@"37",@"38",@"39",@"40",
                                               @"41",@"42",@"43",@"44",@"45",
                                               @"46",@"47",@"48",@"49",@"50",
                                               @"51",@"52",@"53",@"54",@"55",
                                               @"56",@"57",@"58",@"59",@"60",
                                               @"61",@"62",@"63",@"64",@"65",
                                               @"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100", nil];
                    [mPickerViewNumber reloadAllComponents];
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] + 28;
                }
                else if ([_selectedKey.lockVersion hasPrefix:@"5.4.2"]) {
                    self.mPickerNumberArray = [NSMutableArray arrayWithObjects:
                                               @"1",@"2",@"3",@"4",@"5",
                                               @"6",@"7",@"8",@"9",@"10",
                                               @"11",@"12",@"13",@"14",@"15",
                                               @"16",@"17",@"18",@"19",@"20",
                                               @"21",@"22",@"23",@"24",@"25",
                                               @"26",@"27",@"28",@"29",@"30",
                                               @"31",@"32",@"33",@"34",@"35",
                                               @"36",@"37",@"38",@"39",@"40",
                                               @"41",@"42",@"43",@"44",@"45",
                                               @"46",@"47",@"48",@"49",@"50",
                                               @"51",@"52",@"53",@"54",@"55",
                                               @"56",@"57",@"58",@"59",@"60",
                                               @"61",@"62",@"63",@"64",@"65",
                                               @"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",nil];
                    [mPickerViewNumber reloadAllComponents];
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] + 28;
                    
                }
                break;
                
            case 4:
               
                self.flag=4;
                if ([_selectedKey.lockVersion hasPrefix:@"5.4.1"]) {
                    self.mPickerNumberArray = [NSMutableArray arrayWithObjects:
                                               @"1",@"2",@"3",@"4",@"5",
                                               @"6", nil];
                    [mPickerViewNumber reloadAllComponents];
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] * 30+28;
                }
                else if ([_selectedKey.lockVersion hasPrefix:@"5.4.2"]) {
                    self.mPickerNumberArray = [NSMutableArray arrayWithObjects:
                                               @"1",@"2",@"3",@"4",@"5",
                                               @"6",@"7",@"8",@"9",@"10",
                                               @"11",@"12",@"13",@"14",@"15",
                                               @"16",@"17",@"18", @"19",@"20",@"21",@"22",@"23",@"24",nil];
                    [mPickerViewNumber reloadAllComponents];
                    
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue]+208;
                }
                
                break;
            case 5:
                self.flag=5;
                self.keyboardPwdType =   254 ;
                self.mPickerNumberArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"permanent_password", nil) , nil];
                [mPickerViewNumber reloadAllComponents];
                break;
            default:
                break;
        }
        [mPickerViewNumber reloadComponent:0];
    }
    else {
        mPickerViewNumberRow = row;
        switch (self.flag) {
            case 0:
                self.keyboardPwdType = 0;
                break;
            case 1:
                self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue]/10;
                break;
            case 2:
                self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] + 5;
                break;
            case 3:
                self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] + 28;
                break;
            case 4:
                if ([_selectedKey.lockVersion hasPrefix:@"5.4.1"]) {
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue] * 30+28;
                }
                else if ([_selectedKey.lockVersion hasPrefix:@"5.4.2"]) {
                    self.keyboardPwdType =   [[self.mPickerNumberArray objectAtIndex:[mPickerViewNumber selectedRowInComponent:0]] intValue]+208;
                }
                break;
            case 5:
                self.keyboardPwdType =   254 ;
                break;
            default:
                break;
        }
    }
    
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)generateButtonClick{
    [self showHUD:nil];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void){
        __block id pw;
        dispatch_sync(queue, ^(void){
            
            pw = [RequestService UseKPSWithLockId:_selectedKey.lockId keyboardPwdVersion:2 keyboardPwdType:self.keyboardPwdType  receiverUsername:@"" startDate:@"" endDate:@""];
        });
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [SSToastHelper hideHUD];
            
            if ([pw isKindOfClass:[NSString class]]) {
                _generatePwdLabel.text = pw;
                UIPasteboard *board = [UIPasteboard generalPasteboard];
                board.string = _generatePwdLabel.text;
            }
            else{
                [SSToastHelper showHUDToWindow:LS(@"alert_request_error")];
            }
        });
    });
    
   
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

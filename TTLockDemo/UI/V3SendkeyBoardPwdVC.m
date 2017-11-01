//
//  V3SendkeyBoardPwdVCViewController.m
//  Sciener
//
//  Created by wjjxx on 16/7/6.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "V3SendkeyBoardPwdVC.h"
#import "KMDatePicker.h"
#import "MMChoiceOneView.h"
#import "DateHelper.h"
#import "NSDate+CalculateDay.h"
#import "AppDelegate.h"
#import "RequestService.h"
@interface V3SendkeyBoardPwdVC ()<KMDatePickerDelegate,UITextFieldDelegate,MMChoiceViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UITextField *txtFCurrent;
//键盘密码类型
@property (nonatomic, assign) int keyboardPwdType;

@end

@implementation V3SendkeyBoardPwdVC{

    UITextField * _startTextField;
      UITextField * _endTextField;
    UIButton * _recycleBtn;
    NSArray *_recycleWayArray;
    int pickRow;
    KMDatePicker *_startDatePicker;
    KMDatePicker *_endDatePicker;
    NSString *_keyboardPwd;
    UIButton *_usePSBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{
  
    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.973 alpha:1.000];
    [self.view addSubview:bgview];
    UILabel * startLabel = [self createLabelWithFont:15 text:NSLocalizedString(@"start_time", nil)];
    startLabel.backgroundColor =[UIColor clearColor];
        CGRect rect = [[UIScreen mainScreen] bounds];
    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
    // 年月日时分
    _startDatePicker= [[KMDatePicker alloc]
                                initWithFrame:rect
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDayHour];
    _startDatePicker.minLimitedDate = [[DateHelper localeDate] addMonthAndDay:0 days:0];
    
    // 年月日时分
    _endDatePicker = [[KMDatePicker alloc]
                      initWithFrame:rect
                      delegate:self
                      datePickerStyle:KMDatePickerStyleYearMonthDayHour];
    _endDatePicker.minLimitedDate = [[DateHelper localeDate] addMonthAndDay:0 days:0];
    _endDatePicker.defaultLimitedDate = _endDatePicker.minLimitedDate;
    _endDatePicker.maxLimitedDate = [_endDatePicker.minLimitedDate addMonthAndDay:12 days:0];
    _endTextField.inputView = _endDatePicker;
    _endTextField.delegate = self;
    
    //时
    KMDatePicker *hourMinuteDatePicker = [[KMDatePicker alloc]
                                          initWithFrame:rect
                                          delegate:self
                                          datePickerStyle:KMDatePickerStyleHour];
    
    _startTextField = [self createTextField];
    _startTextField.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.973 alpha:1.000];
    _startTextField.tintColor = [UIColor clearColor];
    _startTextField.delegate = self;
    _startTextField.textAlignment = NSTextAlignmentCenter;
    UILabel *startline = [UILabel new];
    startline.backgroundColor = COMMON_BLUE_COLOR;
    [self.view addSubview:startline];
    
   
    float headerHeight = 10;
    if (_type == 2) {
        _recycleWayArray = @[NSLocalizedString(@"words_Weekend", nil),NSLocalizedString(@"words_Daily", nil),NSLocalizedString(@"words_Workday", nil),NSLocalizedString(@"words_Monday", nil),NSLocalizedString(@"words_Tuesday", nil),NSLocalizedString(@"words_Wednesday", nil),NSLocalizedString(@"words_Thuesday", nil),NSLocalizedString(@"words_Friday", nil),NSLocalizedString(@"words_Saturday", nil),NSLocalizedString(@"words_Sunday", nil)];
        UILabel * recycleLabel = [self createLabelWithFont:15 text:NSLocalizedString(@"words_type_of_repeat", nil)];
        recycleLabel.backgroundColor =[UIColor clearColor];
       
        _recycleBtn = [[UIButton alloc]init];
         _recycleBtn.backgroundColor = [UIColor clearColor];
        [_recycleBtn setTitle:NSLocalizedString(@"words_Weekend", nil) forState:UIControlStateNormal];
        [_recycleBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_recycleBtn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
        [self.view addSubview:_recycleBtn];
        [_recycleBtn addTarget:self action:@selector(recycleBtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *recycleline = [UILabel new];
        recycleline.backgroundColor = COMMON_BLUE_COLOR;
        [self.view addSubview:recycleline];
        
        [recycleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@120);
            make.height.equalTo(@50);
        }];
        [_recycleBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.height.equalTo(@50);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];

        [recycleline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_recycleBtn.mas_bottom).offset(-5);
            make.height.equalTo(@1);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];
        
        [startLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_recycleBtn.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@120);
            make.height.equalTo(@50);
        }];
        [_startTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_recycleBtn.mas_bottom).offset(10);
            make.height.equalTo(@50);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];
        
        [startline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_startTextField.mas_bottom).offset(-5);
            make.height.equalTo(@1);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];

        
    }else{
        [startLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@120);
            make.height.equalTo(@50);
        }];
        [_startTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.height.equalTo(@50);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];
        [startline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_startTextField.mas_bottom).offset(-5);
            make.height.equalTo(@1);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];

    }
    
    if (_type ==1 || _type == 2) {
        UILabel * endLabel = [self createLabelWithFont:15 text:NSLocalizedString(@"end_time", nil)];
        endLabel.backgroundColor =[UIColor clearColor];
        
        _endTextField = [self createTextField];
        _endTextField.textAlignment = NSTextAlignmentCenter;
        _endTextField.tintColor = [UIColor clearColor];
        _endTextField.tag = 10;
        _endTextField.backgroundColor =[UIColor colorWithRed:0.961 green:0.965 blue:0.973 alpha:1.000];
        _endTextField.delegate = self;
        UILabel *endline = [UILabel new];
        endline.backgroundColor = COMMON_BLUE_COLOR;
        [self.view addSubview:endline];
        
        [endLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(startLabel.bottom).offset(10);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@120);
            make.height.equalTo(@50);
        }];
        [_endTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(startLabel.bottom).offset(10);
            make.height.equalTo(@50);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];
        [endline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_endTextField.bottom).offset(-5);
            make.height.equalTo(1);
            make.right.equalTo(self.view).offset(-20);
            make.width.equalTo(SCREEN_WIDTH - 120);
            
        }];

        [bgview makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.left.equalTo(self.view).offset(0);
            make.width.equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(endLabel);
        }];

    }else{
        [bgview makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(headerHeight);
            make.left.equalTo(self.view).offset(0);
            make.width.equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(startLabel);
        }];
    }
    if (_type == 2) {
        _startTextField.inputView = hourMinuteDatePicker;
         _endTextField.inputView = hourMinuteDatePicker;
        NSString *todayStr = [TTUtils formateDate:[NSDate date] format:@"HH" timezoneRawOffset:_selectedKey.timezoneRawOffset];
        _startTextField.text =[NSString stringWithFormat:@"%@:00",todayStr];
         NSString *endTextFieldStr =  [TTUtils formateDate:[NSDate dateWithTimeInterval:60*60 sinceDate:[NSDate date]] format:@"HH" timezoneRawOffset:_selectedKey.timezoneRawOffset];
        _endTextField.text = [NSString stringWithFormat:@"%@:00",endTextFieldStr];
        
    }else{
        NSString *todayStr = [TTUtils formateDate:[NSDate date] format:@"yyyy-MM-dd HH" timezoneRawOffset:_selectedKey.timezoneRawOffset];
        _startTextField.text = [NSString stringWithFormat:@"%@%@",todayStr,@":00"];
        
       NSString *endTextFieldStr =  [TTUtils formateDate:[NSDate dateWithTimeInterval:60*60 sinceDate:[NSDate date]] format:@"yyyy-MM-dd HH" timezoneRawOffset:_selectedKey.timezoneRawOffset];
        _endTextField.text = [NSString stringWithFormat:@"%@%@",endTextFieldStr,@":00"];
        _startTextField.inputView = _startDatePicker;
        _endTextField.inputView =_endDatePicker; //_type == 1?_endDatePicker:datePicker;
      
    }
    [self createBottomView];

}
- (void)recycleBtn:(UIButton*)button{
     [self.view endEditing:YES];
    MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
    choiceView.pickerView.tag = 6;
    choiceView.pickerView.delegate = self;
    choiceView.pickerView.dataSource = self;
    choiceView.delegate = self;
    [choiceView showWithBlock:nil];
}
#pragma mark --- UIPickerView
-(void)MMChoiceViewChoiced:(UIPickerView*)picker{
    
    int row =(int) [picker selectedRowInComponent:0];
    pickRow = row;
    [_recycleBtn setTitle:_recycleWayArray[row] forState:UIControlStateNormal];
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return _recycleWayArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _recycleWayArray[row];
    
}


#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    NSString *dateStr;
    if (_type == 2) {
        dateStr = [NSString stringWithFormat:@"%@:00",
                   datePickerDate.hour];
        
    }else if (_txtFCurrent.tag == 10) {
        dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:00",
                   datePickerDate.year,
                   datePickerDate.month,
                   datePickerDate.day,
                   datePickerDate.hour
                   ];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
        [_endDatePicker removeFromSuperview];
        _endDatePicker = [[KMDatePicker alloc]
                                    initWithFrame:rect
                                    delegate:self
                                    datePickerStyle:KMDatePickerStyleYearMonthDayHour];
        _endDatePicker.minLimitedDate = [[DateHelper dateFromString:_startTextField.text withFormat:@"yyyy-MM-dd HH:mm"] addMonthAndDay:0 days:0];
        _endDatePicker.defaultLimitedDate = _endDatePicker.minLimitedDate;
         _endDatePicker.maxLimitedDate = [_endDatePicker.minLimitedDate addMonthAndDay:12 days:0];
        _endTextField.inputView = _endDatePicker;
        _endTextField.delegate = self;
    }else{
        dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:00",
                   datePickerDate.year,
                   datePickerDate.month,
                   datePickerDate.day,
                   datePickerDate.hour
                   ];
    }
       _txtFCurrent.text = dateStr;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    _txtFCurrent = textField;
}

- (void)createBottomView{
    
    _usePSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _usePSBtn.backgroundColor = COMMON_BLUE_COLOR;
    [_usePSBtn setTitle:@"获取密码" forState:UIControlStateNormal];
    [_usePSBtn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    [self.view addSubview:_usePSBtn];
    [_usePSBtn addTarget:self action:@selector(usePS) forControlEvents:UIControlEventTouchUpInside];
    [_usePSBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(150);
        make.height.equalTo(_startTextField);
        if (_type == 0 || _type == 3) {
         make.top.equalTo(_startTextField.mas_bottom).offset(10);
        }else{
             make.top.equalTo(_endTextField.mas_bottom).offset(10);
        }
    }];

    
    UILabel *desLabel = [self createLabelWithFont:15 text:@""];
    if (_type == 0 || _type ==1) {
        
        desLabel.text = [NSString stringWithFormat:@"%@:\n1.%@\n2.%@",LS(@"word_note"),LS(@"alter_the_checkbox_is_checked"),LS(@"used_at_least_once_within_24_hours")];
    }else if (_type == 2){
         desLabel.text = [NSString stringWithFormat:@"%@:\n1.%@",LS(@"word_note"),LS(@"used_at_least_once_within_24_hours")];
    }else if (_type == 3){
         desLabel.text = [NSString stringWithFormat:@"%@:\n1.%@\n",LS(@"word_note"),LS(@"valid_within_6_hours")];
    }
    desLabel.lineBreakMode = NSLineBreakByCharWrapping;
    desLabel.numberOfLines = 0;
    desLabel.textColor = COMMON_FONT_GRAY_COLOR;
    //动态求高度
    CGSize size = [self sizeWithString:desLabel.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT)];
    [self.view addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(SCREEN_WIDTH-20);
        make.height.equalTo(size.height + 3);
        make.top.equalTo(_usePSBtn.mas_bottom).offset(20);
    }];

}


- (NSString *)getRecycleDate{
    
    NSTimeInterval total;
    
    //选择结束时间
    NSString *todayStr = [TTUtils formateDate:[NSDate date] format:@"yyyy-MM-dd" timezoneRawOffset:_selectedKey.timezoneRawOffset];
    
    
    NSString *endTime = [NSString stringWithFormat:@"%@ %@",todayStr,_endTextField.text];
    NSTimeInterval todayTimeInterval = [TTUtils formateDateFromStringToDate:endTime format:@"yyyy-MM-dd HH:mm" timezoneRawOffset:_selectedKey.timezoneRawOffset].timeIntervalSince1970;
   
    
    //当天时间 周日 是1 周一是2 依次
    NSInteger orderWeekday =  [self orderDayFromDate:[NSDate date]];
    //选择pickRow 3-8 指的是周一到周六
    if (pickRow >= 3 && pickRow <= 8) {
        //如果今天是周日 选的周几就加几天
        if (orderWeekday == 1) {
           total = [NSDate date].timeIntervalSince1970 + (pickRow-2)*24*60*60;
        }
        //如果选择的日期 大于今天
        else if (orderWeekday < pickRow - 1) {
           total = [NSDate date].timeIntervalSince1970 + (pickRow-1-orderWeekday)*24*60*60;
        }
        //等于今天
        else if (orderWeekday == pickRow - 1){
            if (todayTimeInterval <= [NSDate date].timeIntervalSince1970) {
                total = [NSDate date].timeIntervalSince1970 + 7*24 * 60* 60;
            }else{
                total = [NSDate date].timeIntervalSince1970;
            }
            
        }
        else{
           total = [NSDate date].timeIntervalSince1970 + (7-orderWeekday-1+pickRow-2)*24*60*60;
        }
    }
    //选择是周日
    else if (pickRow == 9){
     if (orderWeekday == 1) {
         if (todayTimeInterval <= [NSDate date].timeIntervalSince1970) {
             total = [NSDate date].timeIntervalSince1970 + 7*24 * 60* 60;
         }else{
             total = [NSDate date].timeIntervalSince1970;
         }
        }else{
          total = [NSDate date].timeIntervalSince1970 + (7-orderWeekday-1)*24*60*60;
        }
    }
    //周末
    else if (pickRow == 0){
        if (orderWeekday == 1 || orderWeekday == 7) {
            if (todayTimeInterval <= [NSDate date].timeIntervalSince1970 && orderWeekday == 1) {
                total = [NSDate date].timeIntervalSince1970 + 6 *24* 60* 60;
            }else{
                total = [NSDate date].timeIntervalSince1970;
            }
         
        }else{
           total = [NSDate date].timeIntervalSince1970 + (7-orderWeekday-2)*24*60*60;
        }
    }
    //工作日
    else if (pickRow == 2){
        if (orderWeekday == 1) {
            total = [NSDate date].timeIntervalSince1970 + 24 * 60 *60;
        }else if (orderWeekday == 7){
           total = [NSDate date].timeIntervalSince1970 +24 * 60 *60*2;
        }
        else{
            if (todayTimeInterval <= [NSDate date].timeIntervalSince1970 && orderWeekday == 6) {
                total = [NSDate date].timeIntervalSince1970 + 3 *24* 60* 60;
            }else{
                total = [NSDate date].timeIntervalSince1970;
            }
        }
    }
    //每天
    else{
        if (todayTimeInterval <= [NSDate date].timeIntervalSince1970) {
            total = [NSDate date].timeIntervalSince1970 + 24* 60* 60;
        }else{
            total = [NSDate date].timeIntervalSince1970;
        }
    }
    NSString *recycleDatStr = [TTUtils formateDate:[NSDate dateWithTimeIntervalSince1970:total] format:@"yyyy-MM-dd" timezoneRawOffset:_selectedKey.timezoneRawOffset];
    return  recycleDatStr;
}


- (int)getKeyboardPwd{
     //键盘密码类型
    if (_type == 0) {
        _keyboardPwdType = 2;
    }else if (_type == 1){
         _keyboardPwdType = 3;
    }else if (_type == 2){
        _keyboardPwdType = pickRow + 5;
        
    }else{
        _keyboardPwdType = 1;
    }
    return _keyboardPwdType;
   
}

-(void)usePS
{
    NSString * sdatetime= [NSString stringWithFormat:@"%.0f000",[TTUtils formateDateFromStringToDate:_startTextField.text format:@"yyyy-MM-dd HH:mm" timezoneRawOffset:_selectedKey.timezoneRawOffset].timeIntervalSince1970];
    NSString * edatetime= [NSString stringWithFormat:@"%.0f000",[TTUtils formateDateFromStringToDate:_endTextField.text format:@"yyyy-MM-dd HH:mm" timezoneRawOffset:_selectedKey.timezoneRawOffset].timeIntervalSince1970];
    if (_type == 2) {
        
        NSString *todayStr =  [self getRecycleDate];
        NSString *startTime = [NSString stringWithFormat:@"%@ %@",todayStr,_startTextField.text];
        NSString *endTime = [NSString stringWithFormat:@"%@ %@",todayStr,_endTextField.text];
        sdatetime= [NSString stringWithFormat:@"%.0f000",[TTUtils formateDateFromStringToDate:startTime format:@"yyyy-MM-dd HH:mm" timezoneRawOffset:_selectedKey.timezoneRawOffset].timeIntervalSince1970];
        edatetime= [NSString stringWithFormat:@"%.0f000",[TTUtils formateDateFromStringToDate:endTime format:@"yyyy-MM-dd HH:mm" timezoneRawOffset:_selectedKey.timezoneRawOffset].timeIntervalSince1970];
    }else if (_type == 0 || _type == 3){
        edatetime = @"0";
    }

    
    [self showHUD:nil];
    //连接的不是同一个lock
    [NetworkHelper getKeyboardPwd:_selectedKey.lockId keyboardPwdVersion:4 keyboardPwdType:[self getKeyboardPwd] startDate:sdatetime endDate:edatetime completion:^(id info, NSError *error) {
        [self hideHUD];
        if (!error) {
            if (_selectedKey) {
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                KeyboardPwd *pwd = [KeyboardPwd mj_objectWithKeyValues:info];
                pboard.string = pwd.keyboardPwd;
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                 message:[NSString stringWithFormat:@"密码%@已复制到剪贴板",pboard.string]
                                                                delegate:self
                                                       cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alert show];
            }

        }else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                            message:@"请求失败"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];

            
        }
    }];

}
- (UILabel*)createLabelWithFont:(float)font text:(NSString*)text{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    [self.view addSubview:label];
    return label;
}
- (UITextField*)createTextField{
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:15];
    textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textField];
    return textField;
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

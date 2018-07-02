//
//  ChangeKeyDateViewController.m
//  TTLockDemo
//
//  Created by LXX on 17/2/15.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "ChangeKeyDateViewController.h"
#import "KMDatePicker.h"
#import "NSDate+CalculateDay.h"
#import "DateHelper.h"

@interface ChangeKeyDateViewController ()<KMDatePickerDelegate,UITextFieldDelegate>

{
    NSString *_dateStr;
}

@end

@implementation ChangeKeyDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}


- (void)layoutUI {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);

    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:rect
                                     delegate:self
                              datePickerStyle:KMDatePickerStyleYearMonthDayHourMinute];
    _beginTextField.inputView = datePicker;
    _beginTextField.delegate = self;
    
    _endTextField.inputView = datePicker;
    _endTextField.delegate = self;
    
    

    datePicker.minLimitedDate = [[DateHelper localeDate] addMonthAndDay:-24 days:0];
    datePicker.maxLimitedDate = [datePicker.minLimitedDate addMonthAndDay:48 days:0];
   
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
         [self.view endEditing:YES];
}

 #pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = _dateStr;
}

 #pragma mark - KMDatePickerDelegate
 - (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
         NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",
                                                          datePickerDate.year,
                                                          datePickerDate.month,
                                                          datePickerDate.day,
                                                          datePickerDate.hour,
                                                          datePickerDate.minute
                              
                                                          ];
     _dateStr = dateStr;
}
- (IBAction)sureBtnClick:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *begin = [formatter dateFromString:_beginTextField.text];
    NSDate *end = [formatter dateFromString:_endTextField.text];
    
    NSString *startDate = [NSString stringWithFormat:@"%lld",(long long)[begin timeIntervalSince1970]*1000];
    ;
    NSString *endDate = [NSString stringWithFormat:@"%lld",(long long)[end timeIntervalSince1970]*1000];
    ;
    
    [NetworkHelper changeKeyPeriod:self.keyId startDate:startDate endDate:endDate completion:^(id info, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end

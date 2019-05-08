//
//  KMDatePicker.h
//  KMDatePicker
//
//  Created by KenmuHuang on 15/10/6.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDatePickerDateModel.h"

typedef NS_ENUM(NSUInteger, KMDatePickerStyle) {
    KMDatePickerStyleYearMonthDayHourMinute,
    KMDatePickerStyleYearMonthDayHour,
    KMDatePickerStyleYearMonthDay,
    KMDatePickerStyleMonthDayHourMinute,
    KMDatePickerStyleHourMinute,
    KMDatePickerStyleHour
};

@protocol KMDatePickerDelegate;
@interface KMDatePicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id<KMDatePickerDelegate> delegate;
@property (nonatomic, assign) KMDatePickerStyle datePickerStyle;
@property (nonatomic, strong) NSDate *minLimitedDate; ///< Minimum limit time; default value:1970-01-01 00:00
@property (nonatomic, strong) NSDate *maxLimitedDate; ///< Maximum limit time; default value:2060-12-31 23:59
@property (nonatomic, strong) NSDate *defaultLimitedDate; ///< Default limit time; the default value is the minimum time limit; when the selection time is not within the specified range, scroll to this default time limit.
@property (nonatomic, strong) NSDate *scrollToDate; ///< Scroll to the specified time; the default value is the current time

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<KMDatePickerDelegate>)delegate datePickerStyle:(KMDatePickerStyle)datePickerStyle;

@end

@protocol KMDatePickerDelegate <NSObject>
@required
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate;

@end

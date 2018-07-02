//
//  KMDatePicker.m
//  KMDatePicker
//
//  Created by KenmuHuang on 15/10/6.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "KMDatePicker.h"
#import "NSDate+CalculateDay.h"
#import "DateHelper.h"

#define kDefaultMinLimitedDate @"1970-01-01 00:00"
#define kDefaultMaxLimitedDate @"2060-12-31 23:59"
#define kMonthCountOfEveryYear 12
#define kHourCountOfEveryDay 24
#define kMinuteCountOfEveryHour 60
#define kRowDisabledStatusColor [UIColor redColor]
#define kRowNormalStatusColor [UIColor blackColor]
#define kWidthOfTotal self.frame.size.width
#define kHeightOfButtonContentView 35.0
#define kButtonNormalStatusColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]

@interface KMDatePicker () {
    UIPickerView *_pikV;
    

    KMDatePickerDateModel *_datePickerDateMinLimited;
    KMDatePickerDateModel *_datePickerDateMaxLimited;
    KMDatePickerDateModel *_datePickerDateScrollTo;

    NSMutableArray *_mArrYear;
    NSMutableArray *_mArrMonth;
    NSMutableArray *_mArrDay;
    NSMutableArray *_mArrHour;
    NSMutableArray *_mArrMinute;
    
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
}

@end

@implementation KMDatePicker

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<KMDatePickerDelegate>)delegate datePickerStyle:(KMDatePickerStyle)datePickerStyle {
    _delegate = delegate;
    _datePickerStyle = datePickerStyle;
    return [self initWithFrame:frame];
}

#pragma mark - Overridden properties
- (void)setMinLimitedDate:(NSDate *)minLimitedDate {
    _minLimitedDate = minLimitedDate;
   
    if (_minLimitedDate && !_defaultLimitedDate) {
        
        _defaultLimitedDate = _minLimitedDate;
    }
}

#pragma mark - Custom method
- (void)addUnitLabel:(NSString *)text withPointX:(CGFloat)pointX {
    CGFloat pointY = _pikV.frame.size.height/2 - 10.0 + kHeightOfButtonContentView;
    UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(pointX, pointY, 20.0, 20.0)];
    lblUnit.text = text;
    lblUnit.textAlignment = NSTextAlignmentCenter;
    lblUnit.textColor = [UIColor blackColor];
    lblUnit.backgroundColor = [UIColor clearColor];
    lblUnit.font = [UIFont systemFontOfSize:18.0];
    lblUnit.layer.shadowColor = [[UIColor whiteColor] CGColor];
    lblUnit.layer.shadowOpacity = 0.5;
    lblUnit.layer.shadowRadius = 5.0;
    [self addSubview:lblUnit];
}

- (NSUInteger)daysOfMonth {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01 00:00", _mArrYear[_yearIndex], _mArrMonth[_monthIndex]];
    return [[DateHelper dateFromString:dateStr withFormat:@"yyyy-MM-dd HH:mm"] daysOfMonth];
}

- (void)reloadDayArray {
    _mArrDay = [NSMutableArray new];
    for (NSUInteger i=1, len=[self daysOfMonth]; i<=len; i++) {
        [_mArrDay addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
}

- (void)loadData {
    // Initialize the minimum and maximum restriction time and scroll to the specified time entity object instance.
    if (!_minLimitedDate) {
        _minLimitedDate = [DateHelper dateFromString:kDefaultMinLimitedDate withFormat:nil];
    }
    _datePickerDateMinLimited = [[KMDatePickerDateModel alloc] initWithDate:_minLimitedDate];
    
    if (!_maxLimitedDate) {
        _maxLimitedDate = [DateHelper dateFromString:kDefaultMaxLimitedDate withFormat:nil];
    }
    _datePickerDateMaxLimited = [[KMDatePickerDateModel alloc] initWithDate:_maxLimitedDate];
    
    // Scroll to the specified time; the default value is the current time. If the use of custom time is less than the minimum limit time, then the minimum limit time is correct; if the use of custom time is greater than the maximum limit time, then the maximum limit time is accurate.
    if (!_scrollToDate) {
        _scrollToDate = [DateHelper localeDate];
    }
    if ([_scrollToDate compare:_minLimitedDate] == NSOrderedAscending) {
        _scrollToDate = _minLimitedDate;
    } else if ([_scrollToDate compare:_maxLimitedDate] == NSOrderedDescending) {
        _scrollToDate = _maxLimitedDate;
    }
    _datePickerDateScrollTo = [[KMDatePickerDateModel alloc] initWithDate:_scrollToDate];
    
    // An array of initializes the storage time data source
    // year
    _mArrYear = [NSMutableArray new];
    for (NSInteger beginVal=[_datePickerDateMinLimited.year integerValue], endVal=[_datePickerDateMaxLimited.year integerValue]; beginVal<=endVal; beginVal++) {
        [_mArrYear addObject:[NSString stringWithFormat:@"%ld", (long)beginVal]];
    }
    _yearIndex = [_datePickerDateScrollTo.year integerValue] - [_datePickerDateMinLimited.year integerValue];
    
    // month
    _mArrMonth = [[NSMutableArray alloc] initWithCapacity:kMonthCountOfEveryYear];
    for (NSInteger i=1; i<=kMonthCountOfEveryYear; i++) {
        [_mArrMonth addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
    _monthIndex = [_datePickerDateScrollTo.month integerValue] - 1;
    
    // day
    [self reloadDayArray];
    _dayIndex = [_datePickerDateScrollTo.day integerValue] - 1;
    
    // Hour
    _mArrHour = [[NSMutableArray alloc] initWithCapacity:kHourCountOfEveryDay];
    for (NSInteger i=0; i<kHourCountOfEveryDay; i++) {
        [_mArrHour addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
    _hourIndex = [_datePickerDateScrollTo.hour integerValue];//[_datePickerDateScrollTo.hour integerValue];
    
    // Minute
    _mArrMinute = [[NSMutableArray alloc] initWithCapacity:kMinuteCountOfEveryHour];
    for (NSInteger i=0; i<kMinuteCountOfEveryHour; i++) {
        [_mArrMinute addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
    _minuteIndex = [_datePickerDateScrollTo.minute integerValue];;//[_datePickerDateScrollTo.minute integerValue];
}

- (void)scrollToDateIndexPosition {
    NSArray *arrIndex;
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            arrIndex = @[
                         [NSNumber numberWithInteger:_yearIndex],
                         [NSNumber numberWithInteger:_monthIndex],
                         [NSNumber numberWithInteger:_dayIndex],
                         [NSNumber numberWithInteger:_hourIndex],
                         [NSNumber numberWithInteger:_minuteIndex]
                         ];
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            arrIndex = @[[NSNumber numberWithInteger:_yearIndex],
                       [NSNumber numberWithInteger:_monthIndex],
                       [NSNumber numberWithInteger:_dayIndex],
                         [NSNumber numberWithInteger:_hourIndex]
                         ];
            break;
        }
        case KMDatePickerStyleYearMonthDay: {
            arrIndex = @[
                         [NSNumber numberWithInteger:_yearIndex],
                         [NSNumber numberWithInteger:_monthIndex],
                         [NSNumber numberWithInteger:_dayIndex]
                         ];
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            arrIndex = @[
                         [NSNumber numberWithInteger:_monthIndex],
                         [NSNumber numberWithInteger:_dayIndex],
                         [NSNumber numberWithInteger:_hourIndex],
                         [NSNumber numberWithInteger:_minuteIndex]
                         ];
            break;
        }
        case KMDatePickerStyleHourMinute: {
            arrIndex = @[
                         [NSNumber numberWithInteger:_hourIndex],
                         [NSNumber numberWithInteger:_minuteIndex]
                         ];
            break;
        }
        case KMDatePickerStyleHour: {
            arrIndex = @[
                         [NSNumber numberWithInteger:_hourIndex]
                         ];
            break;
        }

    }

    for (NSUInteger i=0, len=arrIndex.count; i<len; i++) {
        [_pikV selectRow:[arrIndex[i] integerValue] inComponent:i animated:YES];
    }
}

- (BOOL)validatedDate:(NSDate *)date {
    NSString *minDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                            _datePickerDateMinLimited.year,
                            _datePickerDateMinLimited.month,
                            _datePickerDateMinLimited.day,
                            _datePickerDateMinLimited.hour,
                            _datePickerDateMinLimited.minute
                            ];
    
    return !([date compare:[DateHelper dateFromString:minDateStr withFormat:nil]] == NSOrderedAscending ||
             [date compare:_maxLimitedDate] == NSOrderedDescending);
}

- (BOOL)canShowScrollToNowButton {
    return [self validatedDate:[DateHelper localeDate]];
}

- (void)cancel:(UIButton *)sender {
    UIViewController *delegateVC = (UIViewController *)self.delegate;
    [delegateVC.view endEditing:YES];
}

- (void)scrollToNowDateIndexPosition:(UIButton *)sender {
    [self scrollToDateIndexPositionWithDate:[DateHelper localeDate]];
}

- (void)scrollToDateIndexPositionWithDate:(NSDate *)date {
    // To distinguish the tag color of the maximum and minimum limits, the reloading of all component columns is needed here.
    [_pikV reloadAllComponents];
    
    _scrollToDate = date;
    _datePickerDateScrollTo = [[KMDatePickerDateModel alloc] initWithDate:_scrollToDate];
    _yearIndex = [_datePickerDateScrollTo.year integerValue] - [_datePickerDateMinLimited.year integerValue];
    _monthIndex = [_datePickerDateScrollTo.month integerValue] - 1;
    _dayIndex = [_datePickerDateScrollTo.day integerValue] - 1;
    _hourIndex = [_datePickerDateScrollTo.hour integerValue];;//[_datePickerDateScrollTo.hour integerValue];
    _minuteIndex = [_datePickerDateScrollTo.hour integerValue];;//[_datePickerDateScrollTo.minute integerValue];
    [self scrollToDateIndexPosition];
}

- (void)confirm:(UIButton *)sender {
    [self playDelegateAfterSelectedRow];
    
    [self cancel:sender];
}

- (UIColor *)monthRowTextColor:(NSInteger)row {
    UIColor *color = kRowNormalStatusColor;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01 00:00",
                         _mArrYear[_yearIndex],
                         _mArrMonth[row]
                         ];
    NSDate *date = [DateHelper dateFromString:dateStr withFormat:nil];
    
    NSString *minDateStr = [NSString stringWithFormat:@"%@-%@-01 00:00",
                         _datePickerDateMinLimited.year,
                         _datePickerDateMinLimited.month
                         ];
    
    if ([date compare:[DateHelper dateFromString:minDateStr withFormat:nil]] == NSOrderedAscending ||
        [date compare:_maxLimitedDate] == NSOrderedDescending) {
        color = kRowDisabledStatusColor;
    }
    
    return color;
}

- (UIColor *)dayRowTextColor:(NSInteger)row {
    UIColor *color = kRowNormalStatusColor;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00",
                         _mArrYear[_yearIndex],
                         _mArrMonth[_monthIndex],
                         _mArrDay[row]
                         ];
    NSDate *date = [DateHelper dateFromString:dateStr withFormat:nil];
    
    NSString *minDateStr = [NSString stringWithFormat:@"%@-%@-%@ 00:00",
                            _datePickerDateMinLimited.year,
                            _datePickerDateMinLimited.month,
                            _datePickerDateMinLimited.day
                            ];
    
    if ([date compare:[DateHelper dateFromString:minDateStr withFormat:nil]] == NSOrderedAscending ||
        [date compare:_maxLimitedDate] == NSOrderedDescending) {
        color = kRowDisabledStatusColor;
    }
    
    return color;
}

- (UIColor *)hourRowTextColor:(NSInteger)row {
    UIColor *color = kRowNormalStatusColor;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:00",
                         _mArrYear[_yearIndex],
                         _mArrMonth[_monthIndex],
                         _mArrDay[_dayIndex],
                         _mArrHour[row]
                         ];
    NSDate *date = [DateHelper dateFromString:dateStr withFormat:nil];
    
    NSString *minDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:00",
                            _datePickerDateMinLimited.year,
                            _datePickerDateMinLimited.month,
                            _datePickerDateMinLimited.day,
                            _datePickerDateMinLimited.hour
                            ];
    
    if ([date compare:[DateHelper dateFromString:minDateStr withFormat:nil]] == NSOrderedAscending ||
        [date compare:_maxLimitedDate] == NSOrderedDescending) {
        color = kRowDisabledStatusColor;
    }
    
    return color;
}

- (UIColor *)minuteRowTextColor:(NSInteger)row {
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    UIColor *color = kRowNormalStatusColor;
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",
                         _mArrYear[_yearIndex],
                         _mArrMonth[_monthIndex],
                         _mArrDay[_dayIndex],
                         _mArrHour[_hourIndex],
                         _mArrMinute[row]
                         ];
    NSDate *date = [DateHelper dateFromString:dateStr withFormat:format];
    
    NSString *minDateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",
                            _datePickerDateMinLimited.year,
                            _datePickerDateMinLimited.month,
                            _datePickerDateMinLimited.day,
                            _datePickerDateMinLimited.hour,
                            _datePickerDateMinLimited.minute
                            ];
    
    if ([date compare:[DateHelper dateFromString:minDateStr withFormat:format]] == NSOrderedAscending ||
        [date compare:_maxLimitedDate] == NSOrderedDescending) {
        color = kRowDisabledStatusColor;
    }
    
    return color;
}

#pragma mark - draw Rect
- (void)drawRect:(CGRect)rect {

    [self loadData];
    

    UIView *buttonContentView = [[UIView alloc] initWithFrame:CGRectMake(-2.0, 0.0, kWidthOfTotal + 4.0, kHeightOfButtonContentView)];
    buttonContentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    buttonContentView.layer.borderWidth = 0.5;
    [self addSubview:buttonContentView];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(2.0, 2.5, 60.0, kHeightOfButtonContentView - 5.0);
    btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnCancel setTitle:LS(@"words_cancel") forState:UIControlStateNormal];
    [btnCancel setTitleColor:kButtonNormalStatusColor forState:UIControlStateNormal];
    [btnCancel addTarget:self
                  action:@selector(cancel:)
        forControlEvents:UIControlEventTouchUpInside];
    [buttonContentView addSubview:btnCancel];
    
//    if ([self canShowScrollToNowButton]) {
//        UIButton *btnScrollToNow = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnScrollToNow.frame = CGRectMake(buttonContentView.frame.size.width/2 - 50.0, 2.5, 100.0, kHeightOfButtonContentView - 5.0);
//        btnScrollToNow.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [btnScrollToNow setTitle:@"现在时间" forState:UIControlStateNormal];
//        [btnScrollToNow setTitleColor:kButtonNormalStatusColor forState:UIControlStateNormal];
//        [btnScrollToNow addTarget:self
//                           action:@selector(scrollToNowDateIndexPosition:)
//                 forControlEvents:UIControlEventTouchUpInside];
//        [buttonContentView addSubview:btnScrollToNow];
//    }
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame = CGRectMake(kWidthOfTotal - 58.0, 2.5, 60.0, kHeightOfButtonContentView - 5.0);
    btnConfirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnConfirm setTitle:LS(@"words_sure_ok") forState:UIControlStateNormal];
    [btnConfirm setTitleColor:kButtonNormalStatusColor forState:UIControlStateNormal];
    [btnConfirm addTarget:self
                   action:@selector(confirm:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonContentView addSubview:btnConfirm];
    

    if (!_pikV) {
        _pikV = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, kHeightOfButtonContentView, kWidthOfTotal, self.frame.size.height - kHeightOfButtonContentView)];
        _pikV.showsSelectionIndicator = YES;
        _pikV.backgroundColor = [UIColor clearColor];
        [self addSubview:_pikV];
    }
    _pikV.dataSource = self;
    _pikV.delegate = self;
    
    [self scrollToDateIndexPosition];
}

#pragma mark -  KMDatePickerDelegate
- (void)playDelegateAfterSelectedRow {
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self
                    didSelectDate:_datePickerDateScrollTo];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger numberOfComponents = 0;
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            numberOfComponents = 5;
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            numberOfComponents = 4;
            break;
        }
        case KMDatePickerStyleYearMonthDay: {
            numberOfComponents = 3;
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            numberOfComponents = 4;
            break;
        }
        case KMDatePickerStyleHourMinute: {
            numberOfComponents = 2;
            break;
        }
        case KMDatePickerStyleHour:{
            numberOfComponents = 1;
            break;
        }
    }
    return numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger numberOfRows = 0;
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            switch (component) {
                case 0:
                    numberOfRows = _mArrYear.count;
                    break;
                case 1:
                    numberOfRows = kMonthCountOfEveryYear;
                    break;
                case 2:
                    numberOfRows = [self daysOfMonth];
                    break;
                case 3:
                    numberOfRows = kHourCountOfEveryDay;
                    break;
                case 4:
                    numberOfRows = kMinuteCountOfEveryHour;
                    break;
            }
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            switch (component) {
                case 0:
                    numberOfRows = _mArrYear.count;
                    break;
                case 1:
                    numberOfRows = kMonthCountOfEveryYear;
                    break;
                case 2:
                    numberOfRows = [self daysOfMonth];
                    break;
                case 3:
                    numberOfRows = kHourCountOfEveryDay;
                    break;
                }
            break;

        }
        case KMDatePickerStyleYearMonthDay: {
            switch (component) {
                case 0:
                    numberOfRows = _mArrYear.count;
                    break;
                case 1:
                    numberOfRows = kMonthCountOfEveryYear;
                    break;
                case 2:
                    numberOfRows = [self daysOfMonth];
                    break;
            }
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            switch (component) {
                case 0:
                    numberOfRows = kMonthCountOfEveryYear;
                    break;
                case 1:
                    numberOfRows = [self daysOfMonth];
                    break;
                case 2:
                    numberOfRows = kHourCountOfEveryDay;
                    break;
                case 3:
                    numberOfRows = kMinuteCountOfEveryHour;
                    break;
            }
            break;
        }
        case KMDatePickerStyleHourMinute: {
            switch (component) {
                case 0:
                    numberOfRows = kHourCountOfEveryDay;
                    break;
                case 1:
                    numberOfRows = kMinuteCountOfEveryHour;
                    break;
            }
            break;
        }
        case KMDatePickerStyleHour: {
            switch (component) {
                case 0:
                    numberOfRows = kHourCountOfEveryDay;
                    break;
            }
            break;
        }

    }
    return numberOfRows;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 50.0;
    CGFloat widthOfAverage;
    
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            // Rule one: average width = width - the width of the total - the width of two numbers compared to the year - the right alignment leads to the offset width to display the "sub" text) / 5 equal parts
            widthOfAverage = (kWidthOfTotal - 20.0 - 25.0) / 5;
            switch (component) {
                case 0:
                    width = widthOfAverage + 20.0;
                    // Rule two: the X coordinate position of the unit label = the horizontal middle X coordinate + offset of the column.
                    [self addUnitLabel:LS(@"words_year") withPointX:width/2 + 24.0];
                    break;
                case 1:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_month") withPointX:(widthOfAverage + 20.0) + width/2 + 16.0];
                    break;
                case 2:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_day") withPointX:(2*widthOfAverage + 20.0) + width/2 + 22.0];
                    break;
                case 3:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_hour") withPointX:(3*widthOfAverage + 20.0) + width/2 + 28.0];
                    break;
                case 4:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_minute") withPointX:(4*widthOfAverage + 20.0) + width/2 + 32.0];
                    break;
            }
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            widthOfAverage = (kWidthOfTotal - 20.0 - 25.0) / 4;
            switch (component) {
                case 0:
                    width = widthOfAverage + 20.0;
                    // Rule two: the X coordinate position of the unit label = the horizontal middle X coordinate + offset of the column.
                    [self addUnitLabel:LS(@"words_year") withPointX:width/2 + 24.0];
                    break;
                case 1:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_month") withPointX:(widthOfAverage + 20.0) + width/2 + 16.0];
                    break;
                case 2:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_day") withPointX:(2*widthOfAverage + 20.0) + width/2 + 22.0];
                    break;
                case 3:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_hour") withPointX:(3*widthOfAverage + 20.0) + width/2 + 28.0];
                    break;
              
            }
            break;

        }
        case KMDatePickerStyleYearMonthDay: {
            widthOfAverage = (kWidthOfTotal - 20.0 - 15.0) / 3;
            switch (component) {
                case 0:
                    width = widthOfAverage + 20.0;
                    [self addUnitLabel:LS(@"words_year") withPointX:width/2 + 24.0];
                    break;
                case 1:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_month") withPointX:(widthOfAverage + 20.0) + width/2 + 16.0];
                    break;
                case 2:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_day") withPointX:(2*widthOfAverage + 20.0) + width/2 + 22.0];
                    break;
            }
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            widthOfAverage = (kWidthOfTotal - 20.0) / 4;
            switch (component) {
                case 0:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_month") withPointX:width/2 + 11.0];
                    break;
                case 1:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_day") withPointX:widthOfAverage + width/2 + 17.0];
                    break;
                case 2:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_hour") withPointX:2*widthOfAverage + width/2 + 23.0];
                    break;
                case 3:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_minute") withPointX:3*widthOfAverage + width/2 + 27.0];
                    break;
            }
            break;
        }
        case KMDatePickerStyleHourMinute: {
            widthOfAverage = (kWidthOfTotal - 10.0) / 2;
            switch (component) {
                case 0:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_hour") withPointX:width/2 + 12.0];
                    break;
                case 1:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_minute") withPointX:widthOfAverage + width/2 + 18.0];
                    break;
            }
            break;
        }
        case KMDatePickerStyleHour: {
            widthOfAverage = (kWidthOfTotal - 10.0);
            switch (component) {
                case 0:
                    width = widthOfAverage;
                    [self addUnitLabel:LS(@"words_hour") withPointX:width/2 + 16.0];
                    break;
            }
            break;
        }
   
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *lblCustom = (UILabel *)view;
    if (!lblCustom) {
        lblCustom = [UILabel new];
        lblCustom.textAlignment = NSTextAlignmentCenter;
        lblCustom.font = [UIFont systemFontOfSize:18.0];
    }
    
    NSString *text;
    UIColor *textColor = kRowNormalStatusColor;
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            switch (component) {
                case 0:
                    text = _mArrYear[row];
                    break;
                case 1:
                    text = _mArrMonth[row];
                    textColor = [self monthRowTextColor:row];
                    break;
                case 2:
                    text = _mArrDay[row];
                    textColor = [self dayRowTextColor:row];
                    break;
                case 3:
                    text = _mArrHour[row];
                    textColor = [self hourRowTextColor:row];
                    break;
                case 4:
                    text = _mArrMinute[row];
                    textColor = [self minuteRowTextColor:row];
                    break;
            }
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            switch (component) {
                case 0:
                    text = _mArrYear[row];
                    break;
                case 1:
                    text = _mArrMonth[row];
                    textColor = [self monthRowTextColor:row];
                    break;
                case 2:
                    text = _mArrDay[row];
                    textColor = [self dayRowTextColor:row];
                    break;
                case 3:
                    text = _mArrHour[row];
                    textColor = [self hourRowTextColor:row];
                    break;
                }
            break;

        }
        case KMDatePickerStyleYearMonthDay: {
            switch (component) {
                case 0:
                    text = _mArrYear[row];
                    break;
                case 1:
                    text = _mArrMonth[row];
                    textColor = [self monthRowTextColor:row];
                    break;
                case 2:
                    text = _mArrDay[row];
                    textColor = [self dayRowTextColor:row];
                    break;
            }
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            switch (component) {
                case 0:
                    text = _mArrMonth[row];
                    textColor = [self monthRowTextColor:row];
                    break;
                case 1:
                    text = _mArrDay[row];
                    textColor = [self dayRowTextColor:row];
                    break;
                case 2:
                    text = _mArrHour[row];
                    textColor = [self hourRowTextColor:row];
                    break;
                case 3:
                    text = _mArrMinute[row];
                    textColor = [self minuteRowTextColor:row];
                    break;
            }
            break;
        }
        case KMDatePickerStyleHourMinute: {
            switch (component) {
                case 0:
                    text = _mArrHour[row];
                    textColor = [self hourRowTextColor:row];
                    break;
                case 1:
                    text = _mArrMinute[row];
                    textColor = [self minuteRowTextColor:row];
                    break;
            }
            break;
        }
        case KMDatePickerStyleHour: {
            switch (component) {
                case 0:
                    text = _mArrHour[row];
                    textColor = [self hourRowTextColor:row];
                    break;
            }
            break;
        }

    }
    lblCustom.text = text;
    lblCustom.textColor = textColor;
    return lblCustom;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (_datePickerStyle) {
        case KMDatePickerStyleYearMonthDayHourMinute: {
            switch (component) {
                case 0:
                    _yearIndex = row;
                    break;
                case 1:
                    _monthIndex = row;
                    break;
                case 2:
                    _dayIndex = row;
                    break;
                case 3:
                    _hourIndex = row;
                    break;
                case 4:
                    _minuteIndex = row;
                    break;
            }
            if (component == 0 || component == 1) {
                [self reloadDayArray];
                if (_mArrDay.count-1 < _dayIndex) {
                    _dayIndex = _mArrDay.count-1;
                }
            }
            break;
        }
        case KMDatePickerStyleYearMonthDayHour:{
            switch (component) {
                case 0:
                    _yearIndex = row;
                    break;
                case 1:
                    _monthIndex = row;
                    break;
                case 2:
                    _dayIndex = row;
                    break;
                case 3:
                    _hourIndex = row;
                    break;
                }
            if (component == 0 || component == 1) {
                [self reloadDayArray];
                if (_mArrDay.count-1 < _dayIndex) {
                    _dayIndex = _mArrDay.count-1;
                }
            }
            break;

        }
        case KMDatePickerStyleYearMonthDay: {
            switch (component) {
                case 0:
                    _yearIndex = row;
                    break;
                case 1:
                    _monthIndex = row;
                    break;
                case 2:
                    _dayIndex = row;
                    break;
            }
            if (component == 0 || component == 1) {
                [self reloadDayArray];
                if (_mArrDay.count-1 < _dayIndex) {
                    _dayIndex = _mArrDay.count-1;
                }
            }
            break;
        }
        case KMDatePickerStyleMonthDayHourMinute: {
            switch (component) {
                case 0:
                    _monthIndex = row;
                    break;
                case 1:
                    _dayIndex = row;
                    break;
                case 2:
                    _hourIndex = row;
                    break;
                case 3:
                    _minuteIndex = row;
                    break;
            }
            if (component == 0) {
                [self reloadDayArray];
                if (_mArrDay.count-1 < _dayIndex) {
                    _dayIndex = _mArrDay.count-1;
                }
            }
            break;
        }
        case KMDatePickerStyleHourMinute: {
            switch (component) {
                case 0:
                    _hourIndex = row;
                    break;
                case 1:
                    _minuteIndex = row;
                    break;
            }
            break;
        }
        case KMDatePickerStyleHour: {
            switch (component) {
                case 0:
                    _hourIndex = row;
                    break;
               
            }
            break;
        }

    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                         _mArrYear[_yearIndex],
                         _mArrMonth[_monthIndex],
                         _mArrDay[_dayIndex],
                         _mArrHour[_hourIndex],
                         _mArrMinute[_minuteIndex]
                         ];
    _scrollToDate = [DateHelper dateFromString:dateStr withFormat:nil];
    _datePickerDateScrollTo = [[KMDatePickerDateModel alloc] initWithDate:_scrollToDate];
    
    // To distinguish the tag color of the maximum and minimum limits, the reloading of all component columns is needed here.
    [pickerView reloadAllComponents];
    
    // If the selection time is not within the minimum and maximum time limit, scroll to the valid default range.
    if (![self validatedDate:_scrollToDate]) {
        [self scrollToDateIndexPositionWithDate:_defaultLimitedDate];
    }
}

@end

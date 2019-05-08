//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
@protocol MMDateViewDelegate;
@interface MMDateView : MMPopupView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) id<MMDateViewDelegate> delegate;

@end

@protocol MMDateViewDelegate<NSObject>
@optional
-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker;
@end

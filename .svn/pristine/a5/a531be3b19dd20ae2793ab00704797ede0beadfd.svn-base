//
//  MMChoiceOneView.h
//  aiyuedong
//
//  Created by gravel on 15/9/23.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPopupView.h"

@protocol MMChoiceViewDelegate;

@interface MMChoiceOneView : MMPopupView

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) id<MMChoiceViewDelegate> delegate;

@end

@protocol MMChoiceViewDelegate<NSObject>
@optional
-(void)MMChoiceViewChoiced:(UIPickerView*)picker;
@end

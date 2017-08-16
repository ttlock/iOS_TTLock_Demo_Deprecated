//
//  MMChoiceOneView.m
//  aiyuedong
//
//  Created by gravel on 15/9/23.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MMChoiceOneView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "Masonry.h"
#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

// pickerView高度
#define kPVH (kWinH*0.35>230?230:(kWinH*0.35<200?200:kWinH*0.35))
@interface MMChoiceOneView()

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation MMChoiceOneView


- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:NSLocalizedString(@"words_cancel", nil) forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(choiced)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:NSLocalizedString(@"words_sure_ok", nil) forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
        
        self.pickerView = [UIPickerView new];
        [self addSubview:self.pickerView];
        
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    
    return self;
}
-(void)choiced{
    
    [self.delegate  MMChoiceViewChoiced:_pickerView];
    [self hide];
}
- (void)actionHide
{
    
    [self hide];
}
@end

//
//  KeypadAddGuide2ViewController.m
//  TTLockSourceCodeDemo
//
//  Created by Jinbo Lu on 2019/5/28.
//  Copyright © 2019 Sciener. All rights reserved.
//

#import "KeypadAddGuide2ViewController.h"
#import "KeypadAddViewController.h"


@interface KeypadAddGuide2ViewController ()

@end

@implementation KeypadAddGuide2ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LS(@"words_Add_Keypad");
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keypad_image_2"]];
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    
    UILabel *setLabel = [UILabel new];
    setLabel.text = LS(@"words_Setting_key");
    setLabel.textColor = UIColor.lightGrayColor;
    setLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:setLabel];
    
    UILabel *describeLabel = [UILabel new];
    describeLabel.text = [NSString stringWithFormat:@"%@%@",LS(@"words_long_press_the_setting_key"),LS(@"tint_Click_next_when_the_keypad_flashes")];
    describeLabel.textColor = UIColor.blackColor;
    describeLabel.numberOfLines = 0;
    describeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:describeLabel];
    
    UIButton *nextButton = [self setupButtonTitle:LS(@"words_next") titleColor:UIColor.blackColor selector:@selector(nextButtonCLick)];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageView.frame.size);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(describeLabel.mas_top).offset(-20);
    }];
    
    [setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left);
        make.bottom.equalTo(imageView).offset(-50);
    }];
    
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view.mas_centerY);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(describeLabel);
        make.height.mas_equalTo(45);;
        make.bottom.equalTo(self.view).offset(-70);
    }];
    
}

- (void)nextButtonCLick{
    KeypadAddViewController *vc = [[KeypadAddViewController alloc] init];
    vc.selectedKey = self.selectedKey;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)setupButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor selector:(SEL)selector{
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = titleColor.CGColor;
    button.layer.borderWidth = 0.5;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

@end

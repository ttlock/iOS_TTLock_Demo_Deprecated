//
//  DiscoverDeviceCell.m
//  Sciener
//
//  Created by wjjxx on 16/7/25.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "DiscoverDeviceCell.h"

@implementation DiscoverDeviceCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCell];
    }
    
    return self;
}

- (void)createCell{
    
    self.label_left = [[UILabel alloc]init];
    self.label_left.font = [UIFont systemFontOfSize:15];
    self.label_left.textColor = [UIColor blackColor];
    self.label_left.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.label_left];
    
    self.image_right = [[UIImageView alloc]init];
    [self.contentView addSubview:self.image_right];
   
    
    [self.label_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.image_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
       make.centerY.mas_equalTo(self);
    }];
}

@end

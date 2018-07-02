//
//  KeyDetailCell.m
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import "KeyDetailCell.h"

@implementation KeyDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)layoutSubviews{
//    
//    
//    CGSize size = [label_right.text sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(2000, 20000)];
//    
//    if (size.width>180) {

//        label_right.frame = CGRectMake(label_right.frame.origin.x, label_right.frame.origin.y, 180, label_right.frame.size.height);
//    }
//    
//}

@end

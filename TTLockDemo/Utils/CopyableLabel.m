//
//  CopyableLabel.m
//  Sciener
//
//  Created by wjjxx on 16/10/9.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "CopyableLabel.h"

@implementation CopyableLabel

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    self.userInteractionEnabled=YES;
    //创建并添加长按手势
    UILongPressGestureRecognizer* longPregress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPregress)];
    [self addGestureRecognizer:longPregress];
}

-(void)longPregress{
    //成为第一响应者
    [self becomeFirstResponder];
    //创建并设置菜单控制器
    UIMenuController* menu=[UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

/**
 * label能执行哪些操作(比如copy, paste等等)
 * @return  YES:支持这种操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( action == @selector(copy:)) return YES;
    
    return NO;
}


- (void)copy:(UIMenuController *)menu
{
    // 将自己的文字复制到粘贴板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text.length > 0 ?self.text:@"";
}


@end

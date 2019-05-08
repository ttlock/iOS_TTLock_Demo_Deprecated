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
    UILongPressGestureRecognizer* longPregress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPregress)];
    [self addGestureRecognizer:longPregress];
}

-(void)longPregress{

    [self becomeFirstResponder];
    UIMenuController* menu=[UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( action == @selector(copy:)) return YES;
    
    return NO;
}


- (void)copy:(UIMenuController *)menu
{

    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text.length > 0 ?self.text:@"";
}


@end

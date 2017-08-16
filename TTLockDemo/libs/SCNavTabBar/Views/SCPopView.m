//
//  SCPopView.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCPopView.h"
#import "CommonMacro.h"

@implementation SCPopView

#pragma mark - Private Methods
#pragma mark -
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        [widths addObject:width];
    }
    
    return widths;
}

- (void)updateSubViewsWithItemWidths:(NSArray *)itemWidths;
{
    CGFloat buttonX = DOT_COORDINATE;
    CGFloat buttonY = DOT_COORDINATE;
    for (NSInteger index = 0; index < [itemWidths count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(buttonX, buttonY, [itemWidths[index] floatValue], ITEM_HEIGHT);
        [button setTitle:_itemNames[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        buttonX += [itemWidths[index] floatValue];
        
        @try {
            if ((buttonX + [itemWidths[index] floatValue]) >= SCREEN_WIDTH)
            {
                buttonX = DOT_COORDINATE;
                buttonY += ITEM_HEIGHT;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

- (void)itemPressed:(UIButton *)button
{
    
    NSArray * normalImageArray = @[@"home_normal", @"category_normal", @"collect_normal"];
    NSArray * selectedImageArray = @[@"home_selected", @"category_selected", @"collect_selected"];
    
    for (int i = 0; i < _items.count; i++) {
        UIButton * btn = _items[i];
        [btn setImage:[UIImage imageNamed:normalImageArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:UIColorWithRGBA(255, 115, 143, 1) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageArray[button.tag]] forState:UIControlStateNormal];
    
    [_delegate itemPressedWithIndex:button.tag];
}

#pragma mark - Public Methods
#pragma marl -
- (void)setItemNames:(NSArray *)itemNames
{
    _itemNames = itemNames;
    
    NSArray *itemWidths = [self getButtonsWidthWithTitles:itemNames];
    [self updateSubViewsWithItemWidths:itemWidths];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

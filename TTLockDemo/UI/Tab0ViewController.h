//
//  FirstViewController.h
//  sciener
//
//  Created by wan on 13-1-21.
//  Copyright (c) 2013年 wan. All rights reserved.
//

#import <UIKit/UIKit.h>


/*!
 @class
 @abstract 首页界面
 */
@interface Tab0ViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate>
{

    
    
}
/*!
 @property
 @abstract 自定义表视图
 */
@property(nonatomic,strong) IBOutlet UITableView* customTableView;

/*!
 @method
 @abstract 添加按钮
 @discussion  点击后跳转到AddLockGuider1ViewController界面
 @param sender 点击的按钮
 @result void
 */
-(void)rightAction:(id)sender;



@end

//
//  TimePsSendedListVC.h
//  sciener
//
//  Created by 谢元潮 on 15/1/19.
//
//

#import <UIKit/UIKit.h>
#import "Key.h"

/*!
 @class
 @abstract 键盘密码使用记录界面
 */
@interface TimePsSendedListVC : UIViewController
{

    
    IBOutlet UIActivityIndicatorView* aiv;
    IBOutlet UITableView* customTableView;
    IBOutlet UILabel * label_no_data;
    
    NSMutableArray* records;
    
    BOOL _reloading;
    
}

@property (nonatomic,strong)Key *selectedKey;
@end

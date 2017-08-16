//
//  KeyDetailViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import <UIKit/UIKit.h>


/*!
 @class
 @abstract 钥匙详情页
 */
@interface KeyDetailViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    
    IBOutlet UITableView* customTableView;
    
    UIAlertView *alertView;
    
}

@property(nonatomic,strong)Key *selectedKey;



@end

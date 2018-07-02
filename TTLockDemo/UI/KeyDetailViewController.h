//
//  KeyDetailViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-2-28.
//
//

#import <UIKit/UIKit.h>

@interface KeyDetailViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    
    IBOutlet UITableView* customTableView;
    
    UIAlertView *alertView;
    
}

@property(nonatomic,strong)Key *selectedKey;



@end

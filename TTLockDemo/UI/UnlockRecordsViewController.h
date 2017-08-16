//
//  UnlockRecordsViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-3-1.
//
//

#import <UIKit/UIKit.h>
/*!
 @class
 @abstract 开锁记录界面
 */
@interface UnlockRecordsViewController : UIViewController
{
    IBOutlet UIActivityIndicatorView* aiv;
    IBOutlet UITableView* customTableView;
    IBOutlet UILabel * label_no_data;
    NSMutableArray* records;
}
@property (nonatomic,strong)Key *selectedKey;

@end

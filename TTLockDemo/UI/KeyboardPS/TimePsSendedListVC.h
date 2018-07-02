//
//  TimePsSendedListVC.h
//  sciener
//
//  Created by TTLock on 15/1/19.
//
//

#import <UIKit/UIKit.h>
#import "Key.h"

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

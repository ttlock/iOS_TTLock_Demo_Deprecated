//
//  UserManageViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-3-6.
//
//

#import <UIKit/UIKit.h>
#import "Key.h"
/*!
 @class
 @abstract 用户管理界面
 */
@interface UserManageViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    
    IBOutlet UILabel * label_no_user;
    IBOutlet UITableView *customTableView;
    IBOutlet UIActivityIndicatorView *aiv;

    NSMutableArray *keys;
    UIAlertView *alertView;
    
}
/*!
 @property
 @abstract currentKey 当前使用的钥匙
 */
@property (nonatomic, strong) Key* currentKey;

/*!
 @method
 @abstract 取得使用锁的用户
 @param usersGot 用户数组
 @param success 成功标志
 @param isFromNet 是否从网路获取
 @result 返回结果
 */
-(void)gotUsers:(NSMutableArray*)usersGot success:(BOOL)success isFromNet:(BOOL)isFromNet;

-(void)showAlert;
-(void)cancelAlert;
@end

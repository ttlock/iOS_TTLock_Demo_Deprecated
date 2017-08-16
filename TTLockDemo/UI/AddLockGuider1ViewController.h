//
//  AddLockGuider1ViewController.h
//  BTstackCocoa
//
//  Created by wan on 13-2-21.
//
//

#import <UIKit/UIKit.h>

@protocol BTDiscoveryDelegate;

/*!
 @enum
 @abstract 关于这个enum的一些基本信息
 @constant kInquiryInactive 休眠
 @constant kInquiryActive    正常
 */
typedef enum {
	kInquiryInactive,
	kInquiryActive,
	kInquiryRemoteName
} InquiryState;
/*!
 @class
 @abstract 添加锁界面
 */
@interface AddLockGuider1ViewController : UIViewController<UIAlertViewDelegate,TTSDKDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UITableView *tableViewCustom;
   
	UIActivityIndicatorView *deviceActivity;
	UIActivityIndicatorView *bluetoothActivity;
    UIAlertView *alertView;
    
}


/*!
 @property
 @abstract 定义BTDiscoveryDelegate
 */
@property (nonatomic, assign) NSObject<BTDiscoveryDelegate> * delegate;
/*!
 @property
 @abstract 显示图标标志
 */
@property (nonatomic, assign) BOOL showIcons;
/*!
 @property
 @abstract 定制的文本
 */
@property (nonatomic, strong) NSString *customActivityText;

/*!
 @method
 @abstract 创建AddLockGuider1ViewController单例
 @result AddLockGuider1ViewController
 */
+(AddLockGuider1ViewController*) sharedInstance;

/*!
 @method
 @abstract 显示提示框
 @result void
 */
-(void)showAlert;
/*!
 @method
 @abstract 取消提示框
 @result void
 */
-(void)cancelAlert;
/*!
 @method
 @abstract 连接超时
 @result void
 */
-(void)connectTimeOut;



@end



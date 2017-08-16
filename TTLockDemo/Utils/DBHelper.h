//
//  DBHelper.h
//      
//
//  Created by wan on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Key.h"
#import "LockModel.h"
#import "Define.h"


/*!
 @class
 @abstract 数据库助手类
 */
@interface DBHelper : NSObject<NSFetchedResultsControllerDelegate>
{

    NSFetchedResultsController *fetcher;
}


/*!
 @property
 @abstract 被管理对象上下文
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/*!
 @property
 @abstract 持久化存储协调器
 */
@property (nonatomic, strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 @property
 @abstract 被管理对象模型
 */
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

/*!
 @method
 @abstract 创建数据库助手单例
 @discussion
 @result DBHelper
 */
+(DBHelper *) sharedInstance;

/*!
 @method
 @abstract 获取管理员钥匙
 @discussion
 @result NSMutableArray
 */
-(NSMutableArray*) fetchAdminKeys;

/*!
 @method
 @abstract 获取当前用户的钥匙
 @discussion
 @result NSMutableArray
 */
-(NSMutableArray*)fetchKeys;

/*!
 @method
 @abstract 获取指定账户的所有钥匙
 @discussion
 @param userName 用户名
 @result NSMutableArray
 */
- (NSMutableArray*) fetchAllKeysWithAccount:(NSString*)userName;
/*!
 @method
 @abstract 获取指定锁名的所有钥匙
 @discussion
 @param lockmacname 锁名
 @result NSMutableArray
 */
-(NSMutableArray*) fetchAllKeysWithLockName:(NSString*)lockmacname;

-(Key*) fetchKeyWithDoorName:(NSString*)doorName;
/*!
 @method
 @abstract 获取指定锁名的一把钥匙
 @discussion
 @param lock 锁名
 @result Key
 */
-(Key*) fetchKeyWithLockName:(NSString*)lock;
/*!
 @method
 @abstract 获取指定锁mac地址的一把钥匙
 @discussion
 @param lockmac 锁mac地址
 @result Key
 */
- (Key*) fetchKeyWithLockMac:(NSString*)lockmac;

/*!
 @method
 @abstract 保存钥匙
 @discussion
 @param key 钥匙
 @result void
 */
-(void)saveKey : (KeyModel *)key;
/*!
 @method
 @abstract 更新数据库
 @discussion
 @result void
 */
-(void)update;
/*!
 @method
 @abstract 删除钥匙
 @discussion
 @param key 钥匙
 @result void
 */
-(void)deleteKey : (Key *)key;


@end

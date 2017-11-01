//
//  DBHelper.m
//
//
//  Created by wan on 13-2-27.
//
//

#import "DBHelper.h"
#import "SettingHelper.h"
@interface DBHelper()

- (NSURL *)applicationDocumentsDirectory;

@end

static DBHelper * dbHelper = nil;
//static NSManagedObjectContext *context = nil;

@implementation DBHelper

@synthesize managedObjectContext;


bool DEBUG_DBHelper = true;


+(DBHelper *) sharedInstance {
    
	if (!dbHelper) {
        
		dbHelper = [[DBHelper alloc] init];
	}
    
	return dbHelper;
    
}
- (NSMutableArray*) fetchAdminKeys
{
    @synchronized(self){
        __block NSMutableArray *keys;
        [self.managedObjectContext performBlockAndWait:^(){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isAdmin = %i",1]];
            
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockId" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
           
            fetcher = nil;
            fetchRequest = nil;
        }];
        
        
        return keys;
    }
   
}

- (NSMutableArray*) fetchKeys
{
    @synchronized(self){
        __block NSMutableArray *keys;
    
        [self.managedObjectContext performBlockAndWait:^(){
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"username = %@",[SettingHelper getOpenID]]];
            
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockAlias" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            fetcher = nil;
            fetchRequest = nil;
        }];
       
        
        return keys;
    }
    
}

- (NSMutableArray*) fetchAllKeysWithAccount:(NSString*)userName
{
    @synchronized(self){
        __block NSMutableArray *keys;
        [self.managedObjectContext performBlockAndWait:^(){
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"username= %@",userName]];
            
            //初始化排序对象                                              
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockId" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            
            
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            
            
            fetcher = nil;
            fetchRequest = nil;
        }];
        
        
        return keys;
    }
    
}

- (NSMutableArray*) fetchAllKeysWithLockName:(NSString*)lockmacname
{
    
    @synchronized(self){
        
        __block NSMutableArray *keys;
        
        [self.managedObjectContext performBlockAndWait:^(){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lockName = %@ ",lockmacname]];
            
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockId" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            
            
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            fetcher = nil;
            fetchRequest = nil;
        }];
       
        
        return keys;
    }
    
}
-(Key*) fetchKeyWithDoorName:(NSString*)doorName{
    @synchronized(self){
        
        __block NSMutableArray *keys=nil;
        
        [self.managedObjectContext performBlockAndWait:^(){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            // Add a sort descriptor
            //	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES selector:nil];
            //	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lockName = %@ and username = %@",doorName,[SettingHelper getOpenID]]];
            
            
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockName" ascending:YES];
            //初始化第二个排序对象
            //    NSSortDescriptor *sort_isAdmin = [[NSSortDescriptor alloc] initWithKey:@"isAdmin" ascending:NO];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            //    fetchRequest.sortDescriptors = sortDescriptors;//设置查询请求的排序条件
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            
            
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            
            fetcher = nil;
            fetchRequest = nil;
        }];
        
        
        if ([keys count]>0) {
            
            return [keys objectAtIndex:0];
        }else{
            
            return nil;
        }
    }
    
}
- (Key*) fetchKeyWithLockName:(NSString*)lockname
{
    
    @synchronized(self){
        
        __block NSMutableArray *keys=nil;
        
        [self.managedObjectContext performBlockAndWait:^(){

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lockName = %@ and username = %@",lockname,[SettingHelper getOpenID]]];
            
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockId" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            
            
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            
            fetcher = nil;
            fetchRequest = nil;
        }];
       
        
        if ([keys count]>0) {
            
            return [keys objectAtIndex:0];
        }else{
            
            return nil;
        }
    }
}

- (Key*) fetchKeyWithLockMac:(NSString*)lockmac
{
    
    @synchronized(self){
        
        __block NSMutableArray *keys=nil;
        
        [self.managedObjectContext performBlockAndWait:^(){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Key" inManagedObjectContext:self.managedObjectContext]];
           
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lockMac = %@ and username = %@",lockmac,[SettingHelper getOpenID]]];
            //初始化排序对象
            NSSortDescriptor *sort_doorName = [[NSSortDescriptor alloc] initWithKey:@"lockId" ascending:YES];
            //定义排序数据
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort_doorName, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            // Init the fetched results controller
            NSError *error;
            fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                          managedObjectContext:self.managedObjectContext
                                                            sectionNameKeyPath:nil
                                                                     cacheName:nil];
            fetcher.delegate = self;
            
            
            if (![fetcher performFetch:&error])
                NSLog(@"ERROR:FETCH KEYS...Error: %@", [error localizedDescription]);
            
            keys = [NSMutableArray arrayWithArray:fetcher.fetchedObjects];
            
            
            fetcher = nil;
            fetchRequest = nil;
        }];
        
        
        if ([keys count]>0) {
            
            return [keys objectAtIndex:0];
        }else{
            
            return nil;
        }
    }
}

-(void)saveKey : (KeyModel *)key
{
    @synchronized(self){
        
        [self.managedObjectContext performBlockAndWait:^(){
            
            // Insert key
            Key *keyInstance = (Key*)[NSEntityDescription insertNewObjectForEntityForName:@"Key"
                                                                   inManagedObjectContext:self.managedObjectContext];
            
            keyInstance.electricQuantity = key.electricQuantity;
            keyInstance.deletePwd = key.deletePwd;
            keyInstance.lockAlias = key.lockAlias;
            keyInstance.lockName = key.lockName;
            keyInstance.endDate = key.endDate;
            keyInstance.lockFlagPos = key.lockFlagPos;
            keyInstance.keyId = key.keyId;
            keyInstance.lockMac = key.lockMac;
            keyInstance.noKeyPwd = key.noKeyPwd;
            keyInstance.adminPwd = key.adminPwd;
            keyInstance.startDate = key.startDate;
            
            NSString *lockVersion = [NSString stringWithFormat:@"%d.%d.%d.%d.%d",key.lockVersion.protocolType,key.lockVersion.protocolVersion,key.lockVersion.scene,key.lockVersion.groupId,key.lockVersion.orgId];
            keyInstance.lockVersion = lockVersion;
            
            
            keyInstance.lockId = key.lockId;
            keyInstance.aesKeyStr = key.aesKeyStr;
            keyInstance.lockKey = key.lockKey;
            keyInstance.userType = key.userType;
            keyInstance.username = [SettingHelper getOpenID];
            keyInstance.keyStatus = key.keyStatus;
            keyInstance.remarks = key.remarks;
            keyInstance.timezoneRawOffset = key.timezoneRawOffset;
            
            // Save the data
            NSError *error = nil;
            if (![self.managedObjectContext save:&error])
                NSLog(@"ERROR:INSERT KEY FAIL...Error LOG: %@", [error localizedDescription]);
            
        }];
       
    }
    
    
    
}
-(void)deleteKey : (Key *)key
{
    
    [self.managedObjectContext performBlockAndWait:^(){
        
        
         if (key!=nil) {
             
             [self.managedObjectContext deleteObject:key];
             
             NSError* error = nil;
             
             if (![self.managedObjectContext save:&error])
                 NSLog(@"ERROR:DELETE KEY FAIL...Error LOG: %@", [error localizedDescription]);
             
         }
         
     }];
    
}

-(void)update
{
    
    [self.managedObjectContext performBlockAndWait:^(){
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
            NSLog(@"ERROR:INSERT KEY FAIL...Error LOG: %@", [error localizedDescription]);
    }];
}

//-(void)clearKeys
//{
//    
//    [context deletedObjects];
//    NSError* error;
//    if (![context save:&error])
//        NSLog(@"ERROR:CLEAR KEYS FAIL...Error LOG: %@", [error localizedDescription]);
//    
//}



#pragma mark - Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{

    if (managedObjectContext !=nil) {
        
        return managedObjectContext;
    }
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TTLockDemo.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        
        NSLog(@"NSPersistentStoreCoordinator copy");
        
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"TTLockDemo" withExtension:@"sqlite"];
        
        if (defaultStoreURL) {
            
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
        
    }
    
    
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    
    NSError *error;
    //TODO 数据库升级用这个，这个NSMigratePersistentStoresAutomaticallyOption和NSInferMappingModelAutomaticallyOption都为yes，就是自动升级，也就是轻量级的数据库迁移。为no的话，就是手动升级，另外一种数据库迁移方法，针对复杂的数据库升级
    
    //自动升级
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    //手动升级
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
//                                       NSMigratePersistentStoresAutomaticallyOption,
//                                       [NSNumber numberWithBool:NO],
//                                       NSInferMappingModelAutomaticallyOption,
//                                       nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }else{
        managedObjectContext = [[NSManagedObjectContext alloc]
                                initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return managedObjectContext;
}




- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
   if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
    }
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folderPath = [NSString stringWithFormat:@"%@/TTLockDemo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    
    if(![fileManager fileExistsAtPath:folderPath]){
        //如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:[folderPath stringByAppendingPathComponent:@"TTLockDemo.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
        
    }
    
    return _persistentStoreCoordinator;
    
}

#pragma mark - Application's documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

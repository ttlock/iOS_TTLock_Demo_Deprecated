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


@interface DBHelper : NSObject<NSFetchedResultsControllerDelegate>
{

    NSFetchedResultsController *fetcher;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;


+(DBHelper *) sharedInstance;


-(NSMutableArray*)fetchKeys;

-(Key*) fetchKeyWithDoorName:(NSString*)doorName;

- (Key*) fetchKeyWithLockMac:(NSString*)lockmac;

-(void)saveKey : (KeyModel *)key;

-(void)update;

-(void)deleteKey : (Key *)key;


@end

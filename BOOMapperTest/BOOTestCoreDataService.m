//
//  BOOTestCoreDataService.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 15/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOTestCoreDataService.h"

@interface BOOTestCoreDataService()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation BOOTestCoreDataService
+(BOOTestCoreDataService *)sharedInstance{
    static dispatch_once_t onceToken;
    static BOOTestCoreDataService *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BOOTestCoreDataService alloc] init];
    });
    return instance;
}

-(void)reset{
    NSString *path = @"/Users/tobiasboogh/Projects/Boogh/BOOiOSGoodies/build/Debug/Model.sqlite";
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        if (error != nil){
            NSLog(@"%@", error);
        }
    }
}

-(NSManagedObjectModel *)managedObjectModel{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *path = @"/Users/tobiasboogh/Projects/Boogh/BOOiOSGoodies/build/Debug/Model.momd";
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

-(NSManagedObjectContext *)managedObjectContext{
    
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    NSString *STORE_TYPE = NSSQLiteStoreType;
    
    NSString *path = @"/Users/tobiasboogh/Projects/Boogh/BOOiOSGoodies/build/Debug/Model.sqlite";
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
    
    if (newStore == nil) {
        NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }
    return managedObjectContext;
}

+(void)recreateStoreInContext:(NSManagedObjectContext *)context{
    [context lock];
    
    NSArray *stores = context.persistentStoreCoordinator.persistentStores;
    NSError *storeError = nil;
    for (NSPersistentStore *store in stores){
        if (![context.persistentStoreCoordinator removePersistentStore:store error:&storeError]){
            NSLog(@"Store Configuration Failure %@", ([storeError localizedDescription] != nil) ? [storeError localizedDescription] : @"Unknown Error");
        }
    }
    NSString *path = @"/Users/tobiasboogh/Projects/Boogh/BOOiOSGoodies/build/Debug/Model.sqlite";
    NSURL *url = [NSURL fileURLWithPath:path];
    NSPersistentStore *newStore = [context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&storeError];
    
    if (newStore == nil) {
        NSLog(@"Store Configuration Failure %@", ([storeError localizedDescription] != nil) ? [storeError localizedDescription] : @"Unknown Error");
    }
    [context reset];
    [context unlock];
}
@end

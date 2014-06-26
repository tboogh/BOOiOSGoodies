//
//  BOOTestCoreDataService.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 15/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface BOOTestCoreDataService : NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
+(BOOTestCoreDataService *)sharedInstance;

+(void)recreateStoreInContext:(NSManagedObjectContext *)context;
-(void)reset;
@end

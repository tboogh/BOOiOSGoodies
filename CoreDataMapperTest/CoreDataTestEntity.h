//
//  CoreDataTestEntity.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 15/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CoreDataTestEntity;

@interface CoreDataTestEntity : NSManagedObject

@property (nonatomic, retain) NSString * string;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) CoreDataTestEntity *parent;
@property (nonatomic, retain) NSOrderedSet *children;
@end

@interface CoreDataTestEntity (CoreDataGeneratedAccessors)

- (void)insertObject:(CoreDataTestEntity *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(CoreDataTestEntity *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(CoreDataTestEntity *)value;
- (void)removeChildrenObject:(CoreDataTestEntity *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

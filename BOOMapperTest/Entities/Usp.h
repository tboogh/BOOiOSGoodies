//
//  Usp.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Characteristics, Image, StructureNode;

@interface Usp : NSManagedObject

@property (nonatomic, retain) NSString * cmDescr;
@property (nonatomic, retain) NSString * cmHeader;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *article_characteristics;
@property (nonatomic, retain) NSSet *cmImages;
@property (nonatomic, retain) StructureNode *parentStructureNode;
@end

@interface Usp (CoreDataGeneratedAccessors)

- (void)addArticle_characteristicsObject:(Characteristics *)value;
- (void)removeArticle_characteristicsObject:(Characteristics *)value;
- (void)addArticle_characteristics:(NSSet *)values;
- (void)removeArticle_characteristics:(NSSet *)values;

- (void)addCmImagesObject:(Image *)value;
- (void)removeCmImagesObject:(Image *)value;
- (void)addCmImages:(NSSet *)values;
- (void)removeCmImages:(NSSet *)values;

@end

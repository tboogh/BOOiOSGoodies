//
//  StructureNode.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Characteristics, Document, Image, Product, StructureNode, Usp;

@interface StructureNode : BaseEntity

@property (nonatomic, retain) NSString * cmDescr;
@property (nonatomic, retain) NSString * cmHeader;
@property (nonatomic, retain) NSString * cmStructDescr;
@property (nonatomic, retain) NSString * cmStructName;
@property (nonatomic, retain) NSString * cmStructTypeKey;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *article_characteristics;
@property (nonatomic, retain) NSSet *cmDocs;
@property (nonatomic, retain) NSSet *cmImages;
@property (nonatomic, retain) NSOrderedSet *cmProducts;
@property (nonatomic, retain) NSOrderedSet *cmStructures;
@property (nonatomic, retain) NSSet *cmUsps;
@property (nonatomic, retain) StructureNode *parentStructureNode;
@end

@interface StructureNode (CoreDataGeneratedAccessors)

- (void)addArticle_characteristicsObject:(Characteristics *)value;
- (void)removeArticle_characteristicsObject:(Characteristics *)value;
- (void)addArticle_characteristics:(NSSet *)values;
- (void)removeArticle_characteristics:(NSSet *)values;

- (void)addCmDocsObject:(Document *)value;
- (void)removeCmDocsObject:(Document *)value;
- (void)addCmDocs:(NSSet *)values;
- (void)removeCmDocs:(NSSet *)values;

- (void)addCmImagesObject:(Image *)value;
- (void)removeCmImagesObject:(Image *)value;
- (void)addCmImages:(NSSet *)values;
- (void)removeCmImages:(NSSet *)values;

- (void)insertObject:(Product *)value inCmProductsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCmProductsAtIndex:(NSUInteger)idx;
- (void)insertCmProducts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCmProductsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCmProductsAtIndex:(NSUInteger)idx withObject:(Product *)value;
- (void)replaceCmProductsAtIndexes:(NSIndexSet *)indexes withCmProducts:(NSArray *)values;
- (void)addCmProductsObject:(Product *)value;
- (void)removeCmProductsObject:(Product *)value;
- (void)addCmProducts:(NSOrderedSet *)values;
- (void)removeCmProducts:(NSOrderedSet *)values;
- (void)insertObject:(StructureNode *)value inCmStructuresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCmStructuresAtIndex:(NSUInteger)idx;
- (void)insertCmStructures:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCmStructuresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCmStructuresAtIndex:(NSUInteger)idx withObject:(StructureNode *)value;
- (void)replaceCmStructuresAtIndexes:(NSIndexSet *)indexes withCmStructures:(NSArray *)values;
- (void)addCmStructuresObject:(StructureNode *)value;
- (void)removeCmStructuresObject:(StructureNode *)value;
- (void)addCmStructures:(NSOrderedSet *)values;
- (void)removeCmStructures:(NSOrderedSet *)values;
- (void)addCmUspsObject:(Usp *)value;
- (void)removeCmUspsObject:(Usp *)value;
- (void)addCmUsps:(NSSet *)values;
- (void)removeCmUsps:(NSSet *)values;

@end

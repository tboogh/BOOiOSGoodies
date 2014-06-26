//
//  Article.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, Characteristics, Document, Image, Product;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * mvxMMITDS;
@property (nonatomic, retain) NSString * mvxMMITNO;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *article_characteristics;
@property (nonatomic, retain) NSSet *cmDocs;
@property (nonatomic, retain) NSSet *cmImages;
@property (nonatomic, retain) NSSet *cmRelated;
@property (nonatomic, retain) Article *parentArticle;
@property (nonatomic, retain) Product *parentProduct;
@end

@interface Article (CoreDataGeneratedAccessors)

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

- (void)addCmRelatedObject:(Article *)value;
- (void)removeCmRelatedObject:(Article *)value;
- (void)addCmRelated:(NSSet *)values;
- (void)removeCmRelated:(NSSet *)values;

@end

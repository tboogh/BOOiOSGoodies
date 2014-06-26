//
//  Product.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Article, Certificate, CharsetP, Document, Image, Product, StructureNode;

@interface Product : BaseEntity

@property (nonatomic, retain) NSString * cmMaterial;
@property (nonatomic, retain) NSString * cmProdName;
@property (nonatomic, retain) NSString * cmProdType;
@property (nonatomic, retain) NSString * cmShortDescr;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * maxDepth;
@property (nonatomic, retain) NSNumber * maxHeight;
@property (nonatomic, retain) NSNumber * maxWidth;
@property (nonatomic, retain) NSNumber * minDepth;
@property (nonatomic, retain) NSNumber * minHeight;
@property (nonatomic, retain) NSNumber * minWidth;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *cmArticles;
@property (nonatomic, retain) NSSet *cmCertificates;
@property (nonatomic, retain) NSSet *cmCharsetP;
@property (nonatomic, retain) NSSet *cmDocs;
@property (nonatomic, retain) NSSet *cmImages;
@property (nonatomic, retain) NSSet *cmProducts;
@property (nonatomic, retain) Product *parentProduct;
@property (nonatomic, retain) StructureNode *parentStructureNode;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addCmArticlesObject:(Article *)value;
- (void)removeCmArticlesObject:(Article *)value;
- (void)addCmArticles:(NSSet *)values;
- (void)removeCmArticles:(NSSet *)values;

- (void)addCmCertificatesObject:(Certificate *)value;
- (void)removeCmCertificatesObject:(Certificate *)value;
- (void)addCmCertificates:(NSSet *)values;
- (void)removeCmCertificates:(NSSet *)values;

- (void)addCmCharsetPObject:(CharsetP *)value;
- (void)removeCmCharsetPObject:(CharsetP *)value;
- (void)addCmCharsetP:(NSSet *)values;
- (void)removeCmCharsetP:(NSSet *)values;

- (void)addCmDocsObject:(Document *)value;
- (void)removeCmDocsObject:(Document *)value;
- (void)addCmDocs:(NSSet *)values;
- (void)removeCmDocs:(NSSet *)values;

- (void)addCmImagesObject:(Image *)value;
- (void)removeCmImagesObject:(Image *)value;
- (void)addCmImages:(NSSet *)values;
- (void)removeCmImages:(NSSet *)values;

- (void)addCmProductsObject:(Product *)value;
- (void)removeCmProductsObject:(Product *)value;
- (void)addCmProducts:(NSSet *)values;
- (void)removeCmProducts:(NSSet *)values;

@end

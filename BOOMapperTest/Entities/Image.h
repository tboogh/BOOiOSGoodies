//
//  Image.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, Product, StructureNode, Usp;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * cmCategoryKey;
@property (nonatomic, retain) NSString * cmDescr;
@property (nonatomic, retain) NSString * cmHeader;
@property (nonatomic, retain) NSString * cmImageClassKey;
@property (nonatomic, retain) NSString * cmImageTypeKey;
@property (nonatomic, retain) NSString * cmName;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Article *parentArticle;
@property (nonatomic, retain) Product *parentProduct;
@property (nonatomic, retain) StructureNode *parentStructureNode;
@property (nonatomic, retain) Usp *parentUsp;

@end

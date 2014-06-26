//
//  Document.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, Product, StructureNode;

@interface Document : NSManagedObject

@property (nonatomic, retain) NSString * cmCategoryKey;
@property (nonatomic, retain) NSString * cmFileTypeCD;
@property (nonatomic, retain) NSString * cmFileTypeKey;
@property (nonatomic, retain) NSString * cmName;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Article *parentArticle;
@property (nonatomic, retain) Product *parentProduct;
@property (nonatomic, retain) StructureNode *parentStructureNode;

@end

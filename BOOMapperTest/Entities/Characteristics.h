//
//  Characteristics.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, StructureNode, Usp;

@interface Characteristics : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * pos;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) Article *parentArticle;
@property (nonatomic, retain) StructureNode *parentStructureNode;
@property (nonatomic, retain) Usp *parentUsp;

@end

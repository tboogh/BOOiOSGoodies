//
//  Certificate.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Certificate : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Product *parentProduct;

@end

//
//  File.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface File : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * cmFilename;
@property (nonatomic, retain) NSString * cmFileUrl;
@property (nonatomic, retain) NSString * cmName;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * subCategory;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unique;

@end

//
//  BOOMapper.h
//  Catalog
//
//  Created by Tobias Boogh on 13/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BOOMapper;

@interface BOOMapperPropertyInfo : NSObject
@property (nonatomic) BOOL isReadonly;
@property (nonatomic) BOOL isCopy;
@property (nonatomic) BOOL isRetain;
@property (nonatomic) BOOL isNonAtomic;
@property (nonatomic) BOOL hasCustomGetter;
@property (nonatomic) BOOL hasCustomSetter;
@property (nonatomic) BOOL isDynamic;
@property (nonatomic) BOOL isWeak;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *customGetterName;
@property (nonatomic, strong) NSString *customSetterName;
@property (nonatomic, strong) NSString *className;
@end

@protocol BOOMapperDelegate <NSObject>
@optional
-(Class)mapper:(BOOMapper *)mapper classForPropertyWithName:(NSString *)propertyName;
-(id)mapper:(BOOMapper *)mapper instanceForClass:(Class)class;
@end

@interface BOOMapper : NSObject
@property (nonatomic, weak) id<BOOMapperDelegate> delegate;
-(instancetype)initWithDelegate:(id<BOOMapperDelegate>)delegate;

-(id)objectFromDictionary:(NSDictionary *)dictionary class:(Class)class;
@end

//
//  BOOMapper.m
//  Catalog
//
//  Created by Tobias Boogh on 13/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOMapper.h"
#import <objc/runtime.h>

@implementation BOOMapperPropertyInfo
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ %@", self.name, self.className];
}
@end

@implementation BOOMapper

-(instancetype)initWithDelegate:(id<BOOMapperDelegate>)delegate{
    self = [super init];
    if (self){
        _delegate = delegate;
    }
    return self;
}

-(id)objectFromDictionary:(NSDictionary *)dictionary class:(Class)class{
    NSMutableArray *propertyKeys = [[BOOMapper propertyNamesForClass:class] mutableCopy];
    NSMutableArray *dictionaryKeys = [[dictionary allKeys] mutableCopy];
    
    [propertyKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [propertyKeys replaceObjectAtIndex:idx withObject:[obj lowercaseString]];
    }];
    [dictionaryKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [dictionaryKeys replaceObjectAtIndex:idx withObject:[obj lowercaseString]];
    }];
    
    NSMutableSet *keys = [NSMutableSet setWithArray:dictionaryKeys];
    NSSet *mappableProperties = [NSSet setWithArray:propertyKeys];
    [keys intersectSet:mappableProperties];
    id object;
    if (self.delegate != nil){
        if ([self.delegate respondsToSelector:@selector(mapper:instanceForClass:)]){
            object = [self.delegate mapper:self instanceForClass:class];
        }
    }
    if (object == nil){
        object = [[class alloc] init];
    }
    
    NSDictionary *propertyInfoDictionary = [BOOMapper propertyAttributesForClass:class];
    
    for (NSString *key in keys) {
        BOOMapperPropertyInfo *info = propertyInfoDictionary[key];
        if (info != nil){
            id value = [self convertedValue:[dictionary valueForKey:key] forProperty:info];
            
            if ([value isKindOfClass:[NSSet class]] ){
                NSLog(@"%@", value);
            }
            if (info.isReadonly){
                NSLog(@"Cannot set value for %@ as it is readonly", info.name);
            } else if (info.hasCustomSetter){
                SEL selector = NSSelectorFromString(info.customSetterName);
                if ([object respondsToSelector:selector]){
                    IMP imp = [object methodForSelector:selector];
                    void (*func)(id , SEL, id) = (void *)imp;
                    func(object, selector, value);
                }
            } else if (info.isWeak){
                NSLog(@"Warning: Property %@ is a weak reference", info.name);
            } else {
                [object setValue:value forKey:info.name];
            }
        }
    }
    
    return object;
}

-(id)convertedValue:(id)value forProperty:(BOOMapperPropertyInfo *)propertyInfo{
    if ([value isKindOfClass:[NSDictionary class]]){
        if (self.delegate != nil){
            if ([self.delegate respondsToSelector:@selector(mapper:classForPropertyWithName:)]){
                Class class = [self.delegate mapper:self classForPropertyWithName:propertyInfo.name];
                if (class == nil){
                    NSLog(@"No class returned for %@, returning dictionary value", propertyInfo.name);
                    return value;
                }
                id object = [self objectFromDictionary:value class:class];
                return object;
            }
        }
    } else {
        Class propertyClass = NSClassFromString(propertyInfo.className);
        if (propertyClass == [NSNumber class]){
            if ([value isKindOfClass:[NSString class]]){
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                return value;
            } else if ([value isKindOfClass:[NSNumber class]]){
                return value;
            } else {
                NSLog(@"Unsupported value class %@ for %@", NSStringFromClass([value class]), NSStringFromClass(propertyClass));
            }
        } else if (propertyClass == [NSString class]){
            if ([value isKindOfClass:[NSString class]]){
                return value;
            } else if ([value isKindOfClass:[NSNumber class]]){
                return [NSString stringWithFormat:@"%@", value];
            } else {
                NSLog(@"Unsupported value class %@ for %@", NSStringFromClass([value class]), NSStringFromClass(propertyClass));
            }
        } else if (propertyClass == [NSSet class] || propertyClass == [NSMutableSet class]){
            NSMutableSet *set = [[NSMutableSet alloc] init];
            if ([value isKindOfClass:[NSArray class]]){
                for (id arrayValue in value) {
                    id convertedArrayValue = value;
                    if ([arrayValue isKindOfClass:[NSDictionary class]]){
                         convertedArrayValue = [self convertedValue:arrayValue forProperty:propertyInfo];
                    }
                    if (convertedArrayValue != nil){
                        [set addObject:convertedArrayValue];
                    }
                }
            }
            return set;
        } else if (propertyClass == [NSOrderedSet class] || propertyClass == [NSMutableOrderedSet class]){
            NSMutableOrderedSet *set = [[NSMutableOrderedSet alloc] init];
            if ([value isKindOfClass:[NSArray class]]){
                for (id arrayValue in value) {
                    id convertedArrayValue = value;
                    if ([arrayValue isKindOfClass:[NSDictionary class]]){
                        convertedArrayValue = [self convertedValue:arrayValue forProperty:propertyInfo];
                    }
                    if (convertedArrayValue != nil){
                        [set addObject:convertedArrayValue];
                    }
                }
            }
            return set;
        } else if (propertyClass == [NSArray class] || propertyClass == [NSMutableArray class]){
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([value isKindOfClass:[NSArray class]]){
                for (id arrayValue in value) {
                    id convertedArrayValue = arrayValue;
                    if ([arrayValue isKindOfClass:[NSDictionary class]]){
                         convertedArrayValue = [self convertedValue:arrayValue forProperty:propertyInfo];
                        
                    }
                    if (convertedArrayValue != nil){
                        [array addObject:convertedArrayValue];
                    }
                }
            }
            return array;
        }
    }
    return nil;
}

+(NSArray *)propertyNamesForClass:(Class)class{
    NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
    unsigned int count;
    objc_property_t *list = nil;
    list = class_copyPropertyList(class, &count);
    for (int i=0; i < count; ++i){
        objc_property_t prop = list[i];
        const char *name = property_getName(prop);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [propertyArray addObject:propertyName];
    }
    return propertyArray;
}

+(NSMutableDictionary *)propertyAttributesForClass:(Class)class{
    NSMutableDictionary *propertyInfoDictionary = [[NSMutableDictionary alloc] init];
    unsigned int count;
    objc_property_t *list = nil;
    list = class_copyPropertyList(class, &count);
    for (int i=0; i < count; ++i){
        objc_property_t prop = list[i];
        const char *name = property_getName(prop);
        
        NSString *attributes = [NSString stringWithCString:property_getAttributes(prop) encoding:NSUTF8StringEncoding];
        
        BOOMapperPropertyInfo *info = [[BOOMapperPropertyInfo alloc] init];
        info.name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [propertyInfoDictionary setValue:info forKey:info.name];
        
        NSArray *array = [attributes componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        for (NSString *string in array) {
            unichar firstCharacter = [string characterAtIndex:0];
            if (firstCharacter == 'T'){
                NSString *classString = [[string stringByReplacingOccurrencesOfString:@"T@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                info.className = classString;
            } else if (firstCharacter == '&'){
                info.isRetain = YES;
            } else if (firstCharacter == 'N'){
                info.isNonAtomic = YES;
            } else if (firstCharacter == 'G'){
                info.hasCustomGetter = YES;
                info.customGetterName = [string substringFromIndex:1];
            } else if (firstCharacter == 'S'){
                info.hasCustomSetter = YES;
                info.customSetterName = [string substringFromIndex:1];
            } else if (firstCharacter == 'V'){
//              Name already set
//                NSString *name = [string stringByReplacingOccurrencesOfString:@"V_" withString:@""];
//                info.name = name;
            } else if (firstCharacter == 'R'){
                info.isReadonly = YES;
            } else if (firstCharacter == 'C'){
                info.isCopy = YES;
            } else if (firstCharacter == 'D'){
                info.isDynamic = YES;
            } else if (firstCharacter == 'W'){
                info.isWeak = YES;
            } else if (firstCharacter == 'P'){
//              Garbage Collection
            } else {
                NSLog(@"Unknown: %@", string);
            }
        }
    }
    return propertyInfoDictionary;
}
@end

//
//  BOOTestClass.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 13/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOTestClass.h"

@implementation BOOSubTestClass
+(NSDictionary *)testDictionary{
    NSDictionary *subDict = @{@"subTestNumber": @(1.5), @"subTestString": @"Dude!"};
    return subDict;
}

-(instancetype)initWithTestData{
    return [self initWithDictionary:[BOOSubTestClass testDictionary]];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _subTestNumber = [dict valueForKey:@"subTestNumber"];
        _subTestString = [dict valueForKey:@"subTestString"];
    }
    return self;
}

-(BOOL)isEqualToTestClass:(BOOSubTestClass *)testClass{
    if (![self.subTestNumber isEqualToNumber:testClass.subTestNumber]){
        return NO;
    }
    if (![self.subTestString isEqualToString:testClass.subTestString]){
        return NO;
    }
    return YES;
}

@end

@implementation BOOTestClass
+(NSDictionary *)testDictionary{
    NSDictionary *subDict = [BOOSubTestClass testDictionary];
    
    NSDictionary *dict = @{@"testNumber": @(3.1415), @"testString": @"Hello, World!", @"testArray": @[@"One", @"Two", @"Three"], @"childTestClass": subDict, @"childTestClassArray" : @[subDict, subDict, subDict]};
    return dict;
}
-(instancetype)initWithTestData{
    return [self initWithDictionary:[BOOTestClass testDictionary]];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _testNumber = [dict valueForKey:@"testNumber"];
        _testString = [dict valueForKey:@"testString"];
        _testArray = [dict valueForKey:@"testArray"];
        _childTestClass = [[BOOSubTestClass alloc] initWithDictionary:[dict valueForKey:@"childTestClass"]];
    }
    return self;
}

-(BOOL)isEqualToTestClass:(BOOTestClass *)testClass{
    if (![self.testNumber isEqualToNumber:testClass.testNumber]){
        return NO;
    }
    if (![self.testString isEqualToString:testClass.testString]){
        return NO;
    }
    if (self.testArray != nil || testClass.testArray != nil){
        if (self.testArray == nil && testClass.testArray != nil){
            return NO;
        }
        if (self.testArray != nil && testClass.testArray == nil){
            return NO;
        }
        
    }
    return YES;
}

-(NSString *)getTheString{
    return _customGetterString;
}

-(void)setTheString:(NSString *)customSetterString{
    _customGetterString = customSetterString;
}

-(void)setTheNumber:(NSNumber *)customGetterSetterNumber{
    aNumber = customGetterSetterNumber;
}

-(NSNumber *)getTheNumber{
    return aNumber;
}
@end

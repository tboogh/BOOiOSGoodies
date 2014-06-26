//
//  BOOTestClass.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 13/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOOSubTestClass : NSObject
@property (nonatomic, strong) NSString *subTestString;
@property (nonatomic, strong) NSNumber *subTestNumber;

+(NSDictionary *)testDictionary;
-(instancetype)initWithTestData;
-(BOOL)isEqualToTestClass:(BOOSubTestClass *)testClass;
@end

@interface BOOTestClass : NSObject{
    NSNumber *aNumber;
}
@property (nonatomic, strong) NSString *testString;
@property (nonatomic, strong) NSNumber *testNumber;
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, strong, readonly) NSString *readonlyString;
@property (nonatomic, strong, setter = setTheString:) NSString *customSetterString;
@property (nonatomic, strong, getter = getTheString) NSString *customGetterString;
@property (nonatomic, strong, getter = getTheNumber, setter = setTheNumber:) NSNumber *customGetterSetterNumber;
@property (nonatomic, strong) BOOSubTestClass *childTestClass;

-(instancetype)initWithTestData;
-(BOOL)isEqualToTestClass:(BOOTestClass *)testClass;

+(NSDictionary *)testDictionary;

@end

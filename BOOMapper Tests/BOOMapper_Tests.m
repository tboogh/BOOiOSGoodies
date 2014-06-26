//
//  BOODataMapperTests.m
//  BOODataMapperTests
//
//  Created by Tobias Boogh on 11/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BOOTestClass.h"
#import "BOOMapper.h"
#import "BOOTestCoreDataService.h"
#import "CoreDataTestEntity.h"

@interface BOODataMapperTests : XCTestCase<BOOMapperDelegate>
@property (nonatomic, strong) BOOMapper *mapper;
@end

@implementation BOODataMapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    BOOMapper *mapper = [[BOOMapper alloc] initWithDelegate:self];
    self.mapper = mapper;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.mapper = nil;
}

-(void)testDictionaryConversion{
    BOOTestClass *referenceClass = [[BOOTestClass alloc] initWithTestData];
    
    NSDictionary *dict = [BOOTestClass testDictionary];
    BOOTestClass *testClass = [self.mapper objectFromDictionary:dict class:[BOOTestClass class]];
    XCTAssert([testClass.testString isEqualToString:referenceClass.testString], "String deserialization failed");
    XCTAssert([testClass.testNumber isEqualToNumber:referenceClass.testNumber], "Number deserialization failed");
    if (testClass.testArray != nil){
        XCTAssert(testClass.testArray.count == referenceClass.testArray.count, "testArray of incorrect length");
        for (int i=0; i < testClass.testArray.count; ++i){
            XCTAssert([testClass.testArray[i] isEqualTo:referenceClass.testArray[i]], "testArray values %@ not equal", testClass.testArray[i]);
        }
    }
    XCTAssert(testClass.childTestClass != nil, "childTestClass failed");
    XCTAssert([testClass.childTestClass.subTestNumber isEqualToNumber:referenceClass.childTestClass.subTestNumber], @"childTestClass.subTestNumber not equal");
    XCTAssert([testClass.childTestClass.subTestString isEqualToString:referenceClass.childTestClass.subTestString], @"childTestClass.subTestString not equal");
}

-(void)testFileParse{
    
}

-(void)testCoreDataConversion{
    NSDictionary *dict = @{@"number": @(13.14), @"string": @"Hello, World!"};
    NSDictionary *dict2 = @{@"number": @(13.14), @"string": @"Hello, World!", @"childClass": dict, @"children": @[dict, dict, dict]};
    CoreDataTestEntity *testEntity = [self.mapper objectFromDictionary:dict2 class:[CoreDataTestEntity class]];
    
    XCTAssert(testEntity != nil, @"Failed to create entity");
    XCTAssert(![testEntity.number isEqualToNumber:@(13.14)], @"Number incorrect");
    BOOL stringBool = [testEntity.string isEqualToString:@"Hello, World!"];
    XCTAssert(stringBool, @"String incorrect");
    XCTAssert(testEntity.children != nil, @"Children set is empty");
}


-(id)mapper:(BOOMapper *)mapper instanceForClass:(Class)class{
    if (class == [BOOTestClass class]){
        return [[BOOTestClass alloc] init];
    } else if (class == [CoreDataTestEntity class]){
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CoreDataTestEntity" inManagedObjectContext:[[BOOTestCoreDataService sharedInstance] managedObjectContext]];
        CoreDataTestEntity *testEntity = [[CoreDataTestEntity alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[[BOOTestCoreDataService sharedInstance] managedObjectContext]];
        return testEntity;
    }
    return nil;
}

-(Class)mapper:(BOOMapper *)mapper classForPropertyWithName:(NSString *)key{
    if ([key isEqualToString:@"childTestClass"]){
        return [BOOSubTestClass class];
    } else if ([key isEqualToString:@"children"]){
        return [CoreDataTestEntity class];
    }
    return nil;
}
@end

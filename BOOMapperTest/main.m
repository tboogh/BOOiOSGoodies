//
//  main.m
//  BOOMapperTesting
//
//  Created by Tobias Boogh on 13/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOOMapper.h"
#import "BOOTestClass.h"
#import "BOOImportTest.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
//        NSDictionary *dict = @{@"testNumber": @(1.5), @"testString": @"Play it again sam", @"customSetterString": @"This is a custom set string"};
//        BOOMapper *mapper = [[BOOMapper alloc] init];
//        BOOTestClass *testClass = [mapper objectFromDictionary:dict class:[BOOTestClass class]];
//        NSLog(@"%@", testClass.getTheString);
        
        BOOImportTest *importTest = [[BOOImportTest alloc] init];
        [importTest runImportTest];
    }
    return 0;
}


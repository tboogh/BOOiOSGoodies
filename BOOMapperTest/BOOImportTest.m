//
//  BOOImportTest.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOImportTest.h"
#import "StructureNode.h"
#import "BOOTestCoreDataService.h"
#import "StructureNode+CatalogImport.h"
#import "CatalogImportDelegate.h"
#import "StructureNode.h"
#import "Product.h"
#import "Usp.h"

@implementation BOOImportTest
-(void)runImportTest{

    NSDictionary *dictionary = nil;
    @autoreleasepool {
        NSData *data = [NSData dataWithContentsOfFile:@"/Users/tobiasboogh/Projects/Boogh/BOOiOSGoodies/TestData/JsonData"];
        NSError *error = nil;
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        data = nil;
        if (error){
            NSLog(@"%@", error);
            return;
        }
        
    }
    
    if (dictionary != nil){
        [self importWithDicitonary:dictionary];
        dictionary = nil;
        getchar();
    }
}

-(void)importWithDicitonary:(NSDictionary *)dictionary{
    if ([[dictionary valueForKey:@"success"] boolValue] == YES){
        [[BOOTestCoreDataService sharedInstance] reset];
        NSManagedObjectContext *context = [[BOOTestCoreDataService sharedInstance] managedObjectContext];
//        context.undoManager = nil;
        NSDictionary *dataDict = [dictionary valueForKey:@"data"];
        NSDictionary *catalogDict = [dataDict valueForKey:@"CmCatalog"];
        NSLog(@"Begin import");
        [StructureNode createStructureNodeWithDictionary:catalogDict parentStructureUUID:nil inContext:context inLanguage:@"en" withDelegate:self];
        NSLog(@"End import");
        
        NSLog(@"Begin save");
        NSArray *objArr = [[context registeredObjects] allObjects];
        BOOL result = [context obtainPermanentIDsForObjects:objArr error:nil];
        if(result == NO){
            NSLog(@"WARNING: Was not able to obtain permanent ids for all objects.");
        }
        [context performBlockAndWait:^{
            NSError *error = nil;
            if (![context save:&error]){
                NSLog(@"Save error: %@", error);
            }
            [BOOTestCoreDataService recreateStoreInContext:context];
        }];
        
        NSLog(@"End save");
    }
}

-(void)didFinishParsingNode:(id)node inContext:(NSManagedObjectContext *)context{
    if ([node isKindOfClass:[StructureNode class]] || [node isKindOfClass:[Product class]] || [node isKindOfClass:[Usp class]]){
        NSArray *objArr = [[context registeredObjects] allObjects];
        BOOL result = [context obtainPermanentIDsForObjects:objArr error:nil];
        if(result == NO){
            NSLog(@"WARNING: Was not able to obtain permanent ids for all objects.");
        }
        NSError *error = nil;
        if (![context save:&error]){
            NSLog(@"%@", error);
        }
        [context reset];
    }
}

//
//-(Class)mapper:(BOOMapper *)mapper classForPropertyWithName:(NSString *)propertyName{
//    NSLog(@"Unhandled propertyName: %@", propertyName);
//    return nil;
//}
//
//-(id)mapper:(BOOMapper *)mapper instanceForClass:(Class)class{
//    if (mapper == self.importMapper){
//        NSString *entityName = NSStringFromClass(class);
//        NSEntityDescription *description = [NSEntityDescription entityForName:entityName inManagedObjectContext:[[BOOTestCoreDataService sharedInstance] managedObjectContext]];
//        return [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:[[BOOTestCoreDataService sharedInstance] managedObjectContext]];
//    }
//    return nil;
//}
@end

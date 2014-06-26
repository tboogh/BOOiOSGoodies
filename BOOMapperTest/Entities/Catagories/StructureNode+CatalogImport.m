//
//  StructureNode+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "StructureNode+CatalogImport.h"
#import "CatalogImportConstansts.h"

#import "Product+CatalogImport.h"
#import "Usp+CatalogImport.h"
#import "Image+CatalogImport.h"
#import "Document+CatalogImport.h"
#import "Characteristics+CatalogImport.h"

@implementation StructureNode (CatalogImport)

+(void)createStructureNodeWithDictionary:(NSDictionary *)dictionary parentStructureUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"StructureNode" inManagedObjectContext:context];

    StructureNode *node = [[StructureNode alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    node.uuid = uuid;
    node.id = dictionary[kId];
    node.cmStructDescr = dictionary[kCmStructDescr];
    node.cmHeader = dictionary[kCmHeader];
    node.type = dictionary[kType];
    node.cmStructTypeKey = dictionary[kCmStructTypeKey];
    node.cmStructName = dictionary[kCmStructName];
    node.cmStructDescr = dictionary[kCmDescr];
    node.unique = dictionary[kUnique];
    node.language = language;
    
    NSArray *article_characteristics = dictionary[kArticleCharacteristics];
    NSMutableSet *articleCharacteristicsSet =[[NSMutableSet alloc] init];
    for (NSDictionary *characteristicsDict in article_characteristics){
        Characteristics *characteristic = [Characteristics characteristicsNodeWithDictionary:characteristicsDict inContext:context inLanguage:language withDelegate:delegate];
        [articleCharacteristicsSet addObject:characteristic];
    }
    node.article_characteristics = articleCharacteristicsSet;
    
//    NSArray *docs = dictionary[kCmDocs];
//    NSMutableSet *docSet =[[NSMutableSet alloc] init];
//    for (NSDictionary *docDict in docs){
//        Document *document = [Document documentNodeWithDictionary:docDict inContext:context inLanguage:language withDelegate:delegate];
//        [docSet addObject:document];
//    }
//    node.cmDocs = docSet;
//    
//    NSArray *images = dictionary[kCmImages];
//    NSMutableSet *imagesSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *imageDict in images) {
//        Image *image = [Image imageNodeWithDictionary:imageDict inContext:context inLanguage:language withDelegate:delegate];
//        [imagesSet addObject:image];
//    }
//    node.cmImages = imagesSet;
//    
//    NSArray *usps = dictionary[kCmUsps];
//    NSMutableSet *uspOrderedSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *uspDict in usps){
//        Usp *usp = [Usp uspNodeWithDictionary:uspDict inContext:context inLanguage:language withDelegate:delegate];
//        [uspOrderedSet addObject:usp];
//    }
//    node.cmUsps = uspOrderedSet;
    
    if (parentUUID != nil){
        NSPredicate *parentStructurePredicate = [NSPredicate predicateWithFormat:@"uuid == %@", parentUUID];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StructureNode"];
        fetchRequest.predicate = parentStructurePredicate;
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if (error){
            NSLog(@"%@", error);
            abort();
        }
        
        StructureNode *parentStructure = [result firstObject];
        NSMutableOrderedSet *orderedSet = [parentStructure.cmStructures mutableCopy];
        [orderedSet addObject:node];
        parentStructure.cmStructures = orderedSet;
        [context refreshObject:parentStructure mergeChanges:YES];
    }
    
    if (delegate != nil){
        if ([delegate respondsToSelector:@selector(didFinishParsingNode:inContext:)]){
            [delegate didFinishParsingNode:node inContext:context];
        }
    }
    NSArray *structures = dictionary[kCmStructures];
    for (NSDictionary *structureDict in structures) {
        [StructureNode createStructureNodeWithDictionary:structureDict parentStructureUUID:uuid inContext:context inLanguage:language withDelegate:delegate];
    }
    
    NSArray *products = dictionary[kCmProducts];
    for (NSDictionary *productDict in products){
        [Product productWithParentStructureNodeWithDictionary:productDict parentStructureUUID:uuid inContext:context inLanguage:language withDelegate:delegate];
    }
    
}
@end

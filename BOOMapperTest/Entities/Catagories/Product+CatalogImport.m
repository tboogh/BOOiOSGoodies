//
//  Product+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Product+CatalogImport.h"
#import "CatalogImportConstansts.h"
#import "Document+CatalogImport.h"
#import "Image+CatalogImport.h"
#import "Certificate+CatalogImport.h"
#import "Article+CatalogImport.h"
#import "CharsetP+CatalogImport.h"

#import "StructureNode.h"

@implementation Product (CatalogImport)
+(void)productWithParentStructureNodeWithDictionary:(NSDictionary *)dictionary parentStructureUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    Product *product = [Product productNodeWithDictionary:dictionary inContext:context inLanguage:language withDelegate:delegate];
    
    if (parentUUID != nil){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", parentUUID];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StructureNode"];
        fetchRequest.predicate = predicate;
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if (error){
            NSLog(@"%@", error);
            abort();
        }
        
        StructureNode *parentStructure = [result firstObject];
        NSMutableOrderedSet *orderedSet = [parentStructure.cmProducts mutableCopy];
        [orderedSet addObject:product];
        parentStructure.cmProducts = orderedSet;
        
        [context refreshObject:parentStructure mergeChanges:YES];
    }
    [Product notifyDelegateAndProcessRelatedProductsWithDictionary:dictionary parentProductUUID:parentUUID inContext:context inLanguage:language withDelegate:delegate];
}

+(void)productWithParentProductNode:(NSDictionary *)dictionary parentProductUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    Product *product = [Product productNodeWithDictionary:dictionary inContext:context inLanguage:language withDelegate:delegate];
    if (parentUUID != nil){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", parentUUID];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
        fetchRequest.predicate = predicate;
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
        if (error){
            NSLog(@"%@", error);
            abort();
        }
        
        Product *parent = [result firstObject];
        NSMutableSet *orderedSet = [parent.cmProducts mutableCopy];
        [orderedSet addObject:product];
        parent.cmProducts = orderedSet;
        
        [context refreshObject:parent mergeChanges:YES];
    }
    
    [Product notifyDelegateAndProcessRelatedProductsWithDictionary:dictionary parentProductUUID:parentUUID inContext:context inLanguage:language withDelegate:delegate];
}

+(void)notifyDelegateAndProcessRelatedProductsWithDictionary:(NSDictionary *)dictionary parentProductUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    if (delegate != nil){
        if ([delegate respondsToSelector:@selector(didFinishParsingNode:inContext:)]){
            [delegate didFinishParsingNode:self inContext:context];
        }
    }
    
    NSArray *products = dictionary[kCmProducts];
    for (NSDictionary *productDict in products){
        [Product productWithParentProductNode:productDict parentProductUUID:parentUUID inContext:context inLanguage:language withDelegate:delegate];
    }
}

+(Product *)productNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    Product *node = [[Product alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    
    node.uuid = [[NSUUID UUID] UUIDString];
    node.cmProdType = dictionary[kCmProdType];
    node.cmMaterial = dictionary[kCmMaterial];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    node.minWidth = [numberFormatter numberFromString:dictionary[kMinWidth]];
    node.maxWidth = [numberFormatter numberFromString:dictionary[kMaxWidth]];

    node.minHeight = [numberFormatter numberFromString:dictionary[kMinHeight]];
    node.maxHeight = [numberFormatter numberFromString:dictionary[kMaxHeight]];
    
    node.minDepth = [numberFormatter numberFromString:dictionary[kMinDepth]];
    node.maxDepth = [numberFormatter numberFromString:dictionary[kMaxDepth]];
    
    node.cmShortDescr = dictionary[kCmShortDescr];
    node.type = dictionary[kType];
    node.id = dictionary[kId];
    node.unique = dictionary[kUnique];
    node.cmProdName = dictionary[kCmProdName];
    node.language = language;
    
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
//    NSArray *certificates = dictionary[kCmCertificates];
//    NSMutableSet *certificatesSet = [[NSMutableSet alloc] init];
//    for (NSString *certificateString in certificates) {
//        Certificate *certificate = [Certificate certificateNodeWithString:certificateString inContext:context];
//        [certificatesSet addObject:certificate];
//    }
//    node.cmCertificates = certificatesSet;
//    
//    NSArray *articles = dictionary[kCmArticles];
//    NSMutableSet *articleSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *articleDict in articles) {
//        Article *article = [Article articleNodeWithDictionary:articleDict inContext:context inLanguage:language withDelegate:delegate];
//        [articleSet addObject:article];
//    }
//    node.cmArticles = articleSet;
//    
//    NSArray *charsetps = dictionary[kCmCharsetP];
//    NSMutableSet *charsetpSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *charsetpDict in charsetps) {
//        CharsetP *charsetp = [CharsetP charsetPNodeWithDictionary:charsetpDict inContext:context inLanguage:language withDelegate:delegate];
//        [charsetpSet addObject:charsetp];
//    }
//    node.cmCharsetP = charsetpSet;
    
    return node;
}

@end

//
//  Usp+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Usp+CatalogImport.h"
#import "CatalogImportConstansts.h"
#import "Image+CatalogImport.h"
#import "Characteristics+CatalogImport.h"

@implementation Usp (CatalogImport)
+(Usp *)uspNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Usp" inManagedObjectContext:context];
    Usp *node = [[Usp alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    node.unique = dictionary[kUnique];
    node.id = dictionary[kId];
    node.type = dictionary[kType];
    node.cmHeader = dictionary[kCmHeader];
    node.language = language;
    
//    NSArray *images = dictionary[kCmImages];
//    NSMutableSet *imagesSet = [[NSMutableSet alloc] init];
//    for (NSDictionary *imageDict in images) {
//        Image *image = [Image imageNodeWithDictionary:imageDict inContext:context inLanguage:language withDelegate:delegate];
//        [imagesSet addObject:image];
//    }
//    node.cmImages = imagesSet;
//    
//    NSArray *article_characteristics = dictionary[kArticleCharacteristics];
//    NSMutableSet *articleCharacteristicsSet =[[NSMutableSet alloc] init];
//    for (NSDictionary *characteristicsDict in article_characteristics){
//        Characteristics *characteristic = [Characteristics characteristicsNodeWithDictionary:characteristicsDict inContext:context inLanguage:language withDelegate:delegate];
//        [articleCharacteristicsSet addObject:characteristic];
//    }
//    node.article_characteristics = articleCharacteristicsSet;
    
    return node;
}
@end

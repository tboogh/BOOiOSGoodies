//
//  Article+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Article+CatalogImport.h"
#import "Document+CatalogImport.h"
#import "Image+CatalogImport.h"
#import "CatalogImportConstansts.h"
#import "Characteristics+CatalogImport.h"

@implementation Article (CatalogImport)
+(Article *)articleNodeWithDictionary :(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    Article *node = [[Article alloc] initWithEntity:description insertIntoManagedObjectContext:context];

    node.id = dictionary[kId];
    node.mvxMMITDS = dictionary[kMvxMMITDS];
    node.mvxMMITNO = dictionary[kMvxMMITNO];
    node.type = dictionary[kType];
    node.unique = dictionary[kUnique];
    node.language = language;
    
    NSArray *cmRelated = dictionary[kCmRelatedArticles];
    NSMutableSet *articleSet = [[NSMutableSet alloc] init];
    for (NSDictionary *articleDict in cmRelated) {
        Article *article = [Article articleNodeWithDictionary:articleDict inContext:context inLanguage:language withDelegate:delegate];
        [articleSet addObject:article];
    }
    node.cmRelated = articleSet;
    
    NSArray *article_characteristics = dictionary[kArticleCharacteristics];
    NSMutableSet *articleCharacteristicsSet =[[NSMutableSet alloc] init];
    for (NSDictionary *characteristicsDict in article_characteristics){
        Characteristics *characteristic = [Characteristics characteristicsNodeWithDictionary:characteristicsDict inContext:context inLanguage:language withDelegate:delegate];
        [articleCharacteristicsSet addObject:characteristic];
    }
    node.article_characteristics = articleCharacteristicsSet;
    
    NSArray *docs = dictionary[kCmDocs];
    NSMutableSet *docSet =[[NSMutableSet alloc] init];
    for (NSDictionary *docDict in docs){
        Document *document = [Document documentNodeWithDictionary:docDict inContext:context inLanguage:language withDelegate:delegate];
        [docSet addObject:document];
    }
    node.cmDocs = docSet;
    
    NSArray *images = dictionary[kCmImages];
    NSMutableSet *imagesSet = [[NSMutableSet alloc] init];
    for (NSDictionary *imageDict in images) {
        Image *image = [Image imageNodeWithDictionary:imageDict inContext:context inLanguage:language withDelegate:delegate];
        [imagesSet addObject:image];
    }
    node.cmImages = imagesSet;
    
    return node;
}
@end

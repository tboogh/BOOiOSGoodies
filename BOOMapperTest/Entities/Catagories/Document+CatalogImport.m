//
//  Document+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Document+CatalogImport.h"
#import "CatalogImportConstansts.h"

@implementation Document (CatalogImport)
+(Document *)documentNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:context];
    Document *node = [[Document alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    
    node.cmName = dictionary[kCmName];
    node.unique = dictionary[kUnique];
    node.cmFileTypeCD = dictionary[kCmFileTypeCD];
    node.cmCategoryKey = dictionary[kCmCategoryKey];
    node.id = dictionary[kId];
    node.cmFileTypeKey = dictionary[kCmFileTypeKey];
    node.type = dictionary[kType];
    node.language = language;
    return node;
}
@end

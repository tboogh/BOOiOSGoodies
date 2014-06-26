//
//  Image+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Image+CatalogImport.h"
#import "CatalogImportConstansts.h"

@implementation Image (CatalogImport)
+(Image *)imageNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
    Image *node = [[Image alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    
    node.cmName = dictionary[kCmName];
    node.cmImageClassKey = dictionary[kCmImageClassKey];
    node.unique = dictionary[kUnique];
    node.cmCategoryKey = dictionary[kCmCategoryKey];
    node.id = dictionary[kId];
    node.cmImageTypeKey = dictionary[kCmImageTypeKey];
    node.cmDescr = dictionary[kCmDescr];
    node.type = dictionary[kType];
    node.cmHeader = dictionary[kCmHeader];
    node.language = language;
    return node;
}


@end

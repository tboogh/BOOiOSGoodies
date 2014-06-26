//
//  Characteristics+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Characteristics+CatalogImport.h"
#import "CatalogImportConstansts.h"

@implementation Characteristics (CatalogImport)
+(Characteristics *)characteristicsNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Characteristics" inManagedObjectContext:context];
    Characteristics *node = [[Characteristics alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    
    node.label = dictionary[kLabel];
    node.key = dictionary[kKey];
    node.pos = dictionary[kPos];
    node.unit = dictionary[kUnit];
    node.text = dictionary[kText];
    node.language = language;
    
    return node;
}
@end

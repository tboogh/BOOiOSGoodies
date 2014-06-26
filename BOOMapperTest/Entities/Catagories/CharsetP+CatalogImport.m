//
//  CharsetP+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "CharsetP+CatalogImport.h"
#import "CatalogImportConstansts.h"

@implementation CharsetP (CatalogImport)
+(CharsetP *)charsetPNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"CharsetP" inManagedObjectContext:context];
    CharsetP *node = [[CharsetP alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    node.value = dictionary[kValue];
    node.header = dictionary[kHeader];
    node.smdkey = dictionary[kSmdkey];
    node.smdid = dictionary[kSmdid];
    node.language = language;
    return node;
}
@end

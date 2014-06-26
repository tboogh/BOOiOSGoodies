//
//  Product+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Product.h"
#import "CatalogImportDelegate.h"

@interface Product (CatalogImport)
+(void)productWithParentStructureNodeWithDictionary:(NSDictionary *)dictionary parentStructureUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
+(void)productWithParentProductNode:(NSDictionary *)dictionary parentProductUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
@end

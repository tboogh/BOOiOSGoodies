//
//  StructureNode+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "StructureNode.h"
#import "CatalogImportDelegate.h"

@interface StructureNode (CatalogImport)
+(void)createStructureNodeWithDictionary:(NSDictionary *)dictionary parentStructureUUID:(NSString *)parentUUID inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
@end

//
//  Image+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Image.h"
#import "CatalogImportDelegate.h"

@interface Image (CatalogImport)
+(Image *)imageNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
@end

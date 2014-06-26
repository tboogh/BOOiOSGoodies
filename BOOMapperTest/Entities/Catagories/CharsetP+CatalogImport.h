//
//  CharsetP+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "CharsetP.h"
#import "CatalogImportDelegate.h"

@interface CharsetP (CatalogImport)
+(CharsetP *)charsetPNodeWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
@end

//
//  Article+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Article.h"
#import "CatalogImportDelegate.h"

@interface Article (CatalogImport)
+(Article *)articleNodeWithDictionary :(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context inLanguage:(NSString *)language withDelegate:(id<CatalogImportDelegate>)delegate;
@end

//
//  Certificate+CatalogImport.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Certificate.h"
#import "CatalogImportDelegate.h"

@interface Certificate (CatalogImport)
+(Certificate *)certificateNodeWithString:(NSString *)string inContext:(NSManagedObjectContext *)context;
@end

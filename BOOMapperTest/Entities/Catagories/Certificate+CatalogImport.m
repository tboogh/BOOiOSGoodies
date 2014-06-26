//
//  Certificate+CatalogImport.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "Certificate+CatalogImport.h"

@implementation Certificate (CatalogImport)
+(Certificate *)certificateNodeWithString:(NSString *)string inContext:(NSManagedObjectContext *)context{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Certificate" inManagedObjectContext:context];
    Certificate *node = [[Certificate alloc] initWithEntity:description insertIntoManagedObjectContext:context];
    node.value = string;
    return node;
}
@end

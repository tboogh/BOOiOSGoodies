//
//  CatalogImportDelegate.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@protocol CatalogImportDelegate <NSObject>
@optional
-(void)didFinishParsingNode:(id)node inContext:(NSManagedObjectContext *)context;
@end

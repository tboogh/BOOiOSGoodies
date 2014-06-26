//
//  BOOImportTest.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 16/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOOMapper.h"
#import "CatalogImportDelegate.h"
@interface BOOImportTest : NSObject <BOOMapperDelegate, CatalogImportDelegate>
@property (nonatomic, strong) BOOMapper *importMapper;
-(void)runImportTest;
@end

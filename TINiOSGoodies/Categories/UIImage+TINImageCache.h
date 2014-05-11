//
//  UIImage+TINImageCache.h
//  Catalog
//
//  Created by Tobias Boogh on 12/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TINImageCache.h"
@interface UIImage (TINImageCache)
+(void)thumbnailForImageWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;
+(void)thumbnailForPdfWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;
+(void)thumbnailForVideoWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;
@end

//
//  UIImage+BOOImageCache.h
//  Catalog
//
//  Created by Tobias Boogh on 12/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOOImageCache.h"
@interface UIImage (BOOImageCache)
+(void)thumbnailForImageWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion;
+(void)thumbnailForPdfWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion;
+(void)thumbnailForVideoWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion;
@end

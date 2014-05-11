//
//  TINImageCache.h
//
//  Created by Tobias Boogh on 12-08-15.
//  Copyright (c) 2012 ByBrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Resize.h"

typedef void(^TINImageCacheCompletion)(UIImage *image);

@interface TINImageCache : NSCache

+(TINImageCache *)getInstance;

-(void)getThumbnailForImage:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;
-(void)getThumbnailForPdf:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;
-(void)getThumbnailForVideo:(NSString *)filePath withSize:(CGSize)size withCompletion:(TINImageCacheCompletion)completion;

-(void)emptyCache;
@end

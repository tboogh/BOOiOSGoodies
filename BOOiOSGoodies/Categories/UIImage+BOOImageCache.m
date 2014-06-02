//
//  UIImage+BOOImageCache.m
//  Catalog
//
//  Created by Tobias Boogh on 12/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "UIImage+BOOImageCache.h"

@implementation UIImage (TINImageCache)
+(void)thumbnailForImageWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    [[BOOImageCache getInstance] getThumbnailForImage:filePath withSize:size withCompletion:^(UIImage *image) {
        if(completion){
            completion(image);
        }
    }];
}

+(void)thumbnailForPdfWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    [[BOOImageCache getInstance] getThumbnailForPdf:filePath withSize:size withCompletion:^(UIImage *image) {
        if(completion){
            completion(image);
        }
    }];
}

+(void)thumbnailForVideoWithFilepath:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    [[BOOImageCache getInstance] getThumbnailForVideo:filePath withSize:size withCompletion:^(UIImage *image) {
        if(completion){
            completion(image);
        }
    }];
}

@end

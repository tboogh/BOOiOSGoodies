//
//  ThumbnailGenerator.m
//  Cargotec
//
//  Created by Tobias Boogh on 12-08-15.
//  Copyright (c) 2012 ByBrick. All rights reserved.
//

#import "BOOImageCache.h"
#import <AVFoundation/AVFoundation.h>
#import <math.h>
#import <ImageIO/ImageIO.h>

@interface BOOImageCache(){
    dispatch_semaphore_t video_semaphore;
}
@property (nonatomic, strong) AVAssetImageGenerator *generator;
@property (nonatomic) dispatch_queue_t fetch_image_queue;
@property (nonatomic, strong) NSString *fileCacheDirectory;
@end

@implementation BOOImageCache

+(BOOImageCache *)getInstance{
    static BOOImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[BOOImageCache alloc] init];
    });
    return imageCache;
}

- (id)init {
    self = [super init];
    if (self) {
        _fetch_image_queue = dispatch_queue_create("com.booimagecache.processimagequeue", DISPATCH_QUEUE_CONCURRENT);
        [self setFileCacheDirectory:[@"~/tmp/TINImageCache" stringByExpandingTildeInPath]];
        video_semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

-(void)emptyCache{
    [self removeAllObjects];
}

-(void)setFileCacheDirectory:(NSString *)cacheDirectory{
    _fileCacheDirectory = cacheDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_fileCacheDirectory]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:_fileCacheDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        if (error){
            NSLog(@"TINImageCache: Error creating directory at %@", _fileCacheDirectory);
        }
    };
}

-(NSString *)keyForFilePath:(NSString *)filePath withSize:(CGSize)size{
    NSString *key = filePath;
    if (!CGSizeEqualToSize(size, CGSizeZero)){
        CGFloat scale = [[UIScreen mainScreen] scale];
        NSString *imageName = [[filePath pathComponents] lastObject];
        if (scale > 1.0f){
            key = [NSString stringWithFormat:@"%@/tn_%d_%d_%@_/@%dx.png", _fileCacheDirectory, (int)size.width, (int)size.height, imageName, (int)scale];
        } else {
            key = [NSString stringWithFormat:@"%@/tn_%d_%d_%@.png", _fileCacheDirectory, (int)size.width, (int)size.height, imageName];
        }
    }
    return key;
}

-(UIImage *)getThumbnailForFilePath:(NSString *)filePath withSize:(CGSize)size{
    if (filePath == nil){
        return nil;
    }
    NSString *key = [self keyForFilePath:filePath withSize:size];
    UIImage *image = [self objectForKey:key];
    return image;
}

-(void)writeImageToFilePath:(UIImage *)image filePath:(NSString *)filePath{
    // Resized images are saved as thumbnails
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
}

-(UIImage *)resizeAndWriteImage:(UIImage *)image withFilePath:(NSString *)filePath andSize:(CGSize)size{
    NSString *key = [self keyForFilePath:filePath withSize:size];
    UIImage *resizedImage = nil;
    if (!CGSizeEqualToSize(size, CGSizeZero)){
        CGFloat scale = [[UIScreen mainScreen] scale];
        size.width *= scale;
        size.height *= scale;
        resizedImage = [self resizeImage:image withSize:size];
        [self writeImageToFilePath:resizedImage filePath:key];
    }
    if (resizedImage != nil){
        [self setObject:resizedImage forKey:key];
    }
    return resizedImage;
}

-(UIImage *)getThumbnailForImage:(NSString *)filePath withSize:(CGSize)size{
    UIImage *thumbnailImage = [self getThumbnailForFilePath:filePath withSize:size];
    if (thumbnailImage == nil){
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image == nil){
            return nil;
        }
        thumbnailImage = [self resizeAndWriteImage:image withFilePath:filePath andSize:size];
    }
    return thumbnailImage;
}

-(UIImage *)getThumbnailForVideo:(NSString *)filePath withSize:(CGSize)size{
    UIImage *thumbnail = [self getThumbnailForFilePath:filePath withSize:size];
    if (thumbnail == nil){
        UIImage *image = nil;
        [self createThumbnailForVideo:filePath withSize:size withCompletion:^(UIImage *image) {
            
        }];
        if (image != nil){
            NSString *key = [self keyForFilePath:filePath withSize:size];
            [self writeImageToFilePath:image filePath:key];
        }
        thumbnail = image;
    }
    return thumbnail;
}

-(UIImage *)getThumbnailForPdf:(NSString *)filePath withSize:(CGSize)size{
    UIImage *thumbnail = [self getThumbnailForFilePath:filePath withSize:size];
    if (thumbnail == nil){
        UIImage *image = [self createThumbnailForPdf:filePath withSize:size];
        if (image != nil){
            NSString *key = [self keyForFilePath:filePath withSize:size];
            [self writeImageToFilePath:image filePath:key];
        }
        thumbnail = image;
    }
    return thumbnail;
}

-(void)getThumbnailForPdf:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    dispatch_async(self.fetch_image_queue, ^{
        UIImage *image = [self getThumbnailForPdf:filePath withSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

-(void)getThumbnailForVideo:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    dispatch_async(self.fetch_image_queue, ^{
        UIImage *thumbnail = [self getThumbnailForFilePath:filePath withSize:size];
        if (thumbnail != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(thumbnail);
            });
        } else {
            [self createThumbnailForVideo:filePath withSize:size withCompletion:^(UIImage *image) {
                if (image != nil){
                    NSString *key = [self keyForFilePath:filePath withSize:size];
                    [self writeImageToFilePath:image filePath:key];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }];
        }
    });
}

-(void)getThumbnailForImage:(NSString *)filePath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    dispatch_async(self.fetch_image_queue, ^{
        UIImage *image = [self getThumbnailForImage:filePath withSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

-(id)objectForKey:(id)key{
    id object = [super objectForKey:key];
    if (object == nil){
        object = [UIImage imageWithContentsOfFile:key];
    }
    return object;
}

-(UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)newImageSize{
    CGSize newSize;
    float widthRatio = newImageSize.width / image.size.width;
    float heightRatio = newImageSize.height / image.size.height;
    
    float scale = MIN(widthRatio, heightRatio);
    
    newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)createThumbnailForPdf:(NSString *)filepath withSize:(CGSize)size{
    UIImage* thumbnailImage;
    // Find the path to the documents directory
    
    NSURL* pdfFileUrl = [NSURL fileURLWithPath:filepath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfFileUrl);
    CGPDFPageRef page;
    
    CGRect aRect = CGRectMake(0, 0, size.width, size.height); // thumbnail size
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, aRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, aRect);
    
    // Grab the first PDF page
    page = CGPDFDocumentGetPage(pdf, 1);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    
    CGContextDrawPDFPage(context, page);
    
    // Create the new UIImage from the context
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Use thumbnailImage (e.g. drawing, saving it to a file, etc)
    
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(pdf);
    return thumbnailImage;
}

-(void)createThumbnailForVideo:(NSString *)filepath withSize:(CGSize)size withCompletion:(BOOImageCacheCompletion)completion{
    NSURL *fileUrl = [NSURL fileURLWithPath:filepath];
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:fileUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(9,1);
    
    CGSize maxSize = CGSizeMake(size.width, size.height);
    generator.maximumSize = maxSize;

    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
        if (error){
            NSLog(@"%@", [error description]);
            completion(nil);
        } else {
            UIImage *uiImage = [[UIImage alloc] initWithCGImage:image];
            completion(uiImage);
        }
    }];
    self.generator = generator;
}

-(CGSize)sizeForImageFromFilePath:(NSString *)filePath{
    NSURL *imageFileURL = [NSURL fileURLWithPath:filePath];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageFileURL, NULL);
    if (imageSource == NULL) {
        // Error loading image
        return CGSizeZero;
    }
    
    CGFloat width = 0.0f, height = 0.0f;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    if (imageProperties != NULL) {
        CFNumberRef widthNum  = (CFNumberRef)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberFloatType, &width);
        }
        
        CFNumberRef heightNum = (CFNumberRef)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberFloatType, &height);
        }
        
        CFRelease(imageProperties);
    }
    
    return CGSizeMake(width, height);
}

-(CGSize)sizeForImageFromFilePath:(NSString *)filePath constrainedToTargetSize:(CGSize)targetSize{
    CGSize size = [self sizeForImageFromFilePath:filePath];
    CGSize newSize;
    float widthRatio = targetSize.width / size.width;
    float heightRatio = targetSize.height / size.height;
    
    float scale = MIN(widthRatio, heightRatio);
    
    newSize = CGSizeMake(size.width * scale, size.height * scale);
    return newSize;
}
@end

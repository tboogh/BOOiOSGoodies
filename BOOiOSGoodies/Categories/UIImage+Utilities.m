//
//  UIImage+Utilities.m
//  Cargotec
//
//  Created by Tobias Boogh on 12-08-31.
//  Copyright (c) 2012 ByBrick. All rights reserved.
//

#import "UIImage+Utilities.h"
#import <ImageIO/ImageIO.h>
@implementation UIImage (Utilities)
+(CGSize)dimensionsOfImageAtFilePath:(NSString *)filepath{
    
    NSURL *imageFileURL = [NSURL fileURLWithPath:filepath];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageFileURL, NULL);
    if (imageSource == NULL) {
        // Error loading image
        NSLog(@"ERROR :dimensionsOfImageAtFilePath could not load file at %@", filepath);
        return CGSizeZero;
    }
    
    CGFloat width = 0.0f, height = 0.0f;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    if (imageProperties != NULL) {
        CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberFloatType, &width);
        }
        
        CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberFloatType, &height);
        }
        
        CFRelease(imageProperties);
    }
    return CGSizeMake(width, height);
}
@end

//
//  UIImage+ReflectedImage.h
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 11/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReflectedImage)
- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;
@end

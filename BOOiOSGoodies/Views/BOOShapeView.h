//
//  BOOShapeView.h
//  Catalog
//
//  Created by Tobias Boogh on 22/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BOOShapeViewShape) {
    BOOShapeViewShapeTriangleUp,
    BOOShapeViewShapeTriangleDown,
    BOORoundedRectCornersTop,
    BOORoundedRectCornersBottom
};

@interface BOOShapeView : UIView
@property (nonatomic) BOOShapeViewShape shape;
@property (nonatomic, strong) UIColor *fillColor;
-(id)initWithFrame:(CGRect)frame andShape:(BOOShapeViewShape)shape;
@end

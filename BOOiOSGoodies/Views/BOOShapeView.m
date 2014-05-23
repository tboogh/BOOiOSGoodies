//
//  BOOShapeView.m
//  Catalog
//
//  Created by Tobias Boogh on 22/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOShapeView.h"

@implementation BOOShapeView

-(id)initWithFrame:(CGRect)frame andShape:(BOOShapeViewShape)shape {
    self = [super initWithFrame:frame];
    if (self) {
        _shape = shape;
        self.fillColor = [UIColor blueColor];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    switch (self.shape) {
        case BOOShapeViewShapeTriangleDown:
        case BOOShapeViewShapeTriangleUp:{
            CGPoint points[] = {
                CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)),
                CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)),
                CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
            };

            if (self.shape == BOOShapeViewShapeTriangleDown){
                for (int i=0; i < sizeof(points) / sizeof(CGPoint); ++i){
                    points[i].y = rect.size.height - points[i].y;
                }
            }
            [path moveToPoint:points[0]];
            for (int i=1; i < sizeof(points) / sizeof(CGPoint); ++i){
                [path addLineToPoint:points[i]];
            }
            [self.fillColor setFill];
            [path fill];
        } break;
    }
    
}


@end

//
//  BOOShapeViewControl.m
//  Catalog
//
//  Created by Tobias Boogh on 05/06/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOShapeViewControl.h"

@implementation BOOShapeViewControl

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}

-(void)commonInit{
    BOOShapeView *shapeView = [[BOOShapeView alloc] initWithFrame:self.bounds];
    shapeView.userInteractionEnabled = NO;
    [self addSubview:shapeView];
    self.shapeView = shapeView;
    self.backgroundColor = [UIColor clearColor];
    self.shapeView.backgroundColor = [UIColor clearColor];
}

@end

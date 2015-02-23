//
//  ELDGradientBackground.m
//  Catalog
//
//  Created by Tobias Boogh on 11/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOGradientBackgroundView.h"

@interface BOOGradientBackgroundView()
@property (nonatomic, strong) NSMutableArray *colors;
@end

@implementation BOOGradientBackgroundView

+(Class)layerClass{
    return [CAGradientLayer class];
}

-(NSUInteger)numberOfColors{
    return self.colors.count;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.colors = [[NSMutableArray alloc] init];
}

-(void)drawRect:(CGRect)rect{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in self.colors) {
        [cgColors addObject:(id)[color CGColor]];
    }
    [gradientLayer setColors:cgColors];
    [super drawRect:rect];
}

-(void)addColors:(NSArray *)colors{
    [self.colors addObjectsFromArray:colors];
    [self setNeedsDisplay];
}

-(void)addColor:(UIColor *)color{
    [self.colors addObject:color];
    [self setNeedsDisplay];
}

-(void)insertColor:(UIColor *)color atIndex:(int)index{
    [self.colors insertObject:color atIndex:index];
    [self setNeedsDisplay];
}

-(void)removeColorAtIndex:(int)index{
    [self.colors removeObjectAtIndex:index];
    [self setNeedsDisplay];
}
@end

//
//  ELDGradientBackground.h
//  Catalog
//
//  Created by Tobias Boogh on 11/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOOGradientBackgroundView : UIView
-(void)addColor:(UIColor *)color;
-(void)insertColor:(UIColor *)color atIndex:(int)index;
-(void)removeColorAtIndex:(int)index;

-(int)numberOfColors;
@end

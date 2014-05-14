//
//  BOOBreadCrumbButton.h
//  Catalog
//
//  Created by Tobias Boogh on 14/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BOOBreadCrumbButtonState) {
    kBOOBreadCrumbButtonStateNormal,
    kBOOBreadCrumbButtonStateCurrent,
    kBOOBreadCrumbButtonStateCount
};

@interface BOOBreadCrumbButton : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, readonly) BOOBreadCrumbButtonState currentState;

-(void)setTitle:(NSString *)title forState:(BOOBreadCrumbButtonState)state;
-(void)setTitleColor:(UIColor *)color forState:(BOOBreadCrumbButtonState)state;

-(void)setBackgroundColor:(UIColor *)color forState:(BOOBreadCrumbButtonState)state;
-(UIColor *)backgroundColorForState:(BOOBreadCrumbButtonState)state;

-(void)setState:(BOOBreadCrumbButtonState)state;
@end

//
//  BOOBreadCrumbButton.m
//  Catalog
//
//  Created by Tobias Boogh on 14/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOBreadCrumbButton.h"

@interface BOOBreadCrumbButtonStateConfiguration : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@end

@implementation BOOBreadCrumbButtonStateConfiguration
-(id)init{
    self = [super init];
    if (self){
        
    }
    return self;
}
@end

@interface BOOBreadCrumbButton()
@property (nonatomic, strong) NSMutableDictionary *stateDictionary;
@property (nonatomic) BOOBreadCrumbButtonState currentState;
@end

@implementation BOOBreadCrumbButton
- (id)init{
    self = [super init];
    if (self) {
        [self commmonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self commmonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commmonInit];
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:label];
        self.titleLabel = label;
    }
    return self;
}

-(void)commmonInit{
    self.stateDictionary = [[NSMutableDictionary alloc] init];
    BOOBreadCrumbButtonStateConfiguration *state = [[BOOBreadCrumbButtonStateConfiguration alloc] init];
    self.stateDictionary[@(kBOOBreadCrumbButtonStateNormal)] = state;
    state.title = @"";
    state.titleColor = [UIColor whiteColor];
    state.backgroundColor = [UIColor clearColor];
}

-(BOOBreadCrumbButtonStateConfiguration *)configurationForState:(BOOBreadCrumbButtonState)state{
    BOOBreadCrumbButtonStateConfiguration *configuration = self.stateDictionary[@(state)];
    if (configuration == nil){
        configuration = [[BOOBreadCrumbButtonStateConfiguration alloc] init];
        self.stateDictionary[@(state)] = configuration;
    }
    return configuration;
}

-(void)setTitle:(NSString *)title forState:(BOOBreadCrumbButtonState)state{
    BOOBreadCrumbButtonStateConfiguration *configuration = [self configurationForState:state];
    configuration.title = title;
}

-(void)setTitleColor:(UIColor *)color forState:(BOOBreadCrumbButtonState)state{
    BOOBreadCrumbButtonStateConfiguration *configuration = [self configurationForState:state];
    configuration.titleColor = color;
}

-(void)setBackgroundColor:(UIColor *)color forState:(BOOBreadCrumbButtonState)state{
    BOOBreadCrumbButtonStateConfiguration *configuration = [self configurationForState:state];
    configuration.backgroundColor = color;
}

-(void)setState:(BOOBreadCrumbButtonState)state{
    self.currentState = state;
    BOOBreadCrumbButtonStateConfiguration *configuration = [self configurationForState:state];
    if (configuration.titleColor != nil){
        self.titleLabel.textColor = configuration.titleColor;
    } else {
        BOOBreadCrumbButtonStateConfiguration *normalConfiguration = self.stateDictionary[@(kBOOBreadCrumbButtonStateNormal)];
        self.titleLabel.textColor = normalConfiguration.titleColor;
    }
    
    if (configuration.backgroundColor != nil){
        self.backgroundColor = configuration.backgroundColor;
    } else {
        BOOBreadCrumbButtonStateConfiguration *normalConfiguration = self.stateDictionary[@(kBOOBreadCrumbButtonStateNormal)];
        self.backgroundColor = normalConfiguration.backgroundColor;
    }
    
    if (configuration.title != nil){
        self.titleLabel.text = configuration.title;
    } else {
        BOOBreadCrumbButtonStateConfiguration *normalConfiguration = self.stateDictionary[@(kBOOBreadCrumbButtonStateNormal)];
        self.titleLabel.text = normalConfiguration.title;
    }
}

-(UIColor *)backgroundColorForState:(BOOBreadCrumbButtonState)state{
    BOOBreadCrumbButtonStateConfiguration *configuration = self.stateDictionary[@(state)];
    if (configuration == nil){
        return nil;
    }
    return configuration.backgroundColor;
}
@end

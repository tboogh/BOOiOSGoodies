//
//  ABBBreadCrumbNavigation.m
//  ABB Power Products and Systems
//
//  Created by Tobias Boogh on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BOOBreadCrumbView.h"

@interface BOOBreadCrumbView()
@property (nonatomic, copy) NSString *homeButtonTitle;
@end

@implementation BOOBreadCrumbView

- (id)init{
    self = [super init];
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
    self.buttons = [[NSMutableArray alloc] init];
}

-(void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    if (animated){
        if (self.hidden){
            self.alpha = 0.0f;
            [super setHidden:NO];
        } else {
            self.alpha = 1.0f;
        }
        [UIView animateWithDuration:0.3f animations:^{
            if (hidden){
                self.alpha = 0.0;
            } else {
                self.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    } else {
        [super setHidden:hidden];
    }
}

-(void)buttonPressed:(id)sender{
    int index = [self.subviews indexOfObject:sender];
    if (index == self.subviews.count - 1){
        return;
    }
    if ([_breadCrumbDelegate shouldSelectAtIndex:index]){
        [self removeButtonsAfterIndex:index];
        [_breadCrumbDelegate buttonSelectedAtIndex:index];
    }
}

-(void)removeButtonsAfterIndex:(uint)index{
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    [UIView animateWithDuration:0.3 animations:^{
        for (int i=1; i < self.subviews.count; i++){
            UIView *view = (self.subviews)[i];
            
            if (i > index){
                CGRect arrowFrame = [(self.subviews)[i-1] frame];
                view.frame = arrowFrame;
                view.alpha = 0.0;
                [removeArray addObject:view];
            }
        }
    } completion:^(BOOL finished) {
        for (UIView *view in removeArray){
            [view removeFromSuperview];
            [self.buttons removeObject:view];
        }
    }];
}

-(void)setHomeButtonTitle:(NSString *)title{
    _homeButtonTitle = title;
    [self addButtonWithTitle:_homeButtonTitle];
}

-(void)clearButtons{
    for (UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    [self addButtonWithTitle:_homeButtonTitle];
}

-(BOOBreadCrumbPosition)positionForNextItem{
    if (self.buttons.count == 0){
        return kBOOBreadCrumpPositionFirst;
    } else {
        return kBOOBreadCrumpPositionLast;
    }
}

-(void)addButtonWithTitle:(NSString*)title{
    CGRect buttonFrame;
    CGRect targetFrame;
    if (![self.breadCrumbDelegate respondsToSelector:@selector(controlForButtonAtIndex:withPosition:)]){
        @throw [NSException exceptionWithName:@"BOOBreadCrumbDelegateNotImplemented" reason:@"Missing implementation for viewForButtonAtIndex:withPosition:" userInfo:nil];
    }
    
    UIControl *buttonView = [self.breadCrumbDelegate controlForButtonAtIndex:self.buttons.count withPosition:[self positionForNextItem]];
    
    buttonFrame = targetFrame = buttonView.bounds;
    buttonFrame.origin.x = self.contentSize.width;
    if (self.buttons.count > 0){
        buttonFrame.origin.x += self.buttonSpacing;
    }
    
    CGSize contentSize = self.contentSize;
    contentSize.height = MAX(buttonFrame.size.height, contentSize.height);
    contentSize.width = buttonFrame.origin.x + buttonFrame.size.width;
    
    targetFrame = buttonFrame;
    buttonFrame.origin.x = MAX(self.contentSize.width, self.bounds.size.width);

    [self.buttons addObject:buttonView];
    
    [buttonView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonView];
    
    [UIView animateWithDuration:0.3 animations:^{
        buttonView.frame = targetFrame;
    }];
    
}

@end

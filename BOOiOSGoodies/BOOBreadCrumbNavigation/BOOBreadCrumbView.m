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
    self.delegate = self;
    self.buttons = [[NSMutableArray alloc] init];
}

-(void)buttonPressed:(id)sender{
    NSUInteger index = [self.buttons indexOfObject:sender];
    if (index == self.buttons.count - 1){
        return;
    }
    if ([self.breadCrumbDelegate respondsToSelector:@selector(breadCrumbView:shouldSelectAtIndex:)]){
        if (![_breadCrumbDelegate breadCrumbView:self shouldSelectAtIndex:index]){
            return;
        }
    }
    [self removeButtonsAfterIndex:index];
    if ([self.breadCrumbDelegate respondsToSelector:@selector(breadCrumbView:didSelectedButtonAtIndex:)]){
        [_breadCrumbDelegate breadCrumbView:self didSelectedButtonAtIndex:index];
    }
}

-(void)removeButtonsAfterIndex:(uint)index{
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    if (index+1 >= self.buttons.count){
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        for (int i=index+1; i < self.buttons.count; i++){
            UIView *view = (self.buttons)[i];
            
            if (i > index){
                CGRect arrowFrame = [(self.buttons)[i-1] frame];
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
        BOOBreadCrumbButton *lastButton = [self.buttons lastObject];
        CGSize contentSize = self.contentSize;
        contentSize.height = MAX(lastButton.frame.size.height, contentSize.height);
        contentSize.width = lastButton.frame.origin.x + lastButton.frame.size.width;
        self.contentSize = contentSize;
        [self updateButtons];
        [self scrollRectToVisible:lastButton.frame animated:YES];
    }];
}

-(void)addButton{
    CGRect buttonFrame;
    CGRect targetFrame;
    if (![self.breadCrumbDataSource respondsToSelector:@selector(breadCrumbView:controlForButtonAtIndex:)]){
        @throw [NSException exceptionWithName:@"BOOBreadCrumbDelegateNotImplemented" reason:@"Missing implementation for controlForButtonAtIndex:withPosition:" userInfo:nil];
    }
    
    BOOBreadCrumbButton *buttonView = [self.breadCrumbDataSource breadCrumbView:self controlForButtonAtIndex:self.buttons.count];
    
    buttonFrame = targetFrame = buttonView.bounds;
    
    if (self.buttons.count > 0){
        buttonFrame.origin.x = self.contentSize.width + self.buttonSpacing;
    }
    
    targetFrame = buttonFrame;
    
    CGSize contentSize = self.contentSize;
    contentSize.height = MAX(buttonFrame.size.height, contentSize.height);
    contentSize.width = buttonFrame.origin.x + buttonFrame.size.width;
    self.contentSize = contentSize;
    
    buttonFrame.origin.x = MAX(self.contentSize.width, self.bounds.size.width);
    buttonView.frame = buttonFrame;
    [self.buttons addObject:buttonView];
    
    [buttonView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonView];
    [self updateButtons];
    [UIView animateWithDuration:0.3 animations:^{
        buttonView.frame = targetFrame;
    } completion:^(BOOL finished) {
        
        [self scrollRectToVisible:buttonView.frame animated:YES];
    }];
}

-(void)updateButtons{
    for (BOOBreadCrumbButton *button in self.buttons) {
        if ([self.buttons lastObject] == button){
            [button setState:kBOOBreadCrumbButtonStateCurrent];
        } else {
            [button setState:kBOOBreadCrumbButtonStateNormal];
        }
    }
}

@end

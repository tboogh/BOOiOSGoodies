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

//-(void)setHomeButtonTitle:(NSString *)title{
//    _homeButtonTitle = title;
//    [self addButtonWithTitle:_homeButtonTitle];
//}

-(void)clearButtons{
    for (UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
//    [self addButtonWithTitle:_homeButtonTitle];
}

-(void)addButton{
    CGRect buttonFrame;
    CGRect targetFrame;
    if (![self.breadCrumbDataSource respondsToSelector:@selector(controlForButtonAtIndex:)]){
        @throw [NSException exceptionWithName:@"BOOBreadCrumbDelegateNotImplemented" reason:@"Missing implementation for controlForButtonAtIndex:withPosition:" userInfo:nil];
    }
    
    BOOBreadCrumbButton *buttonView = [self.breadCrumbDataSource controlForButtonAtIndex:self.buttons.count];
    
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

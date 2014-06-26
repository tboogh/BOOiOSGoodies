//
//  ABBBreadCrumbNavigation.h
//  ABB Power Products and Systems
//
//  Created by Tobias Boogh on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BOOBreadCrumbButton.h"

@class BOOBreadCrumbView;

@protocol BOOBreadCrumbDataSource <NSObject>
-(BOOBreadCrumbButton *)breadCrumbView:(BOOBreadCrumbView *)breadCrumbView controlForButtonAtIndex:(NSUInteger)index;
@end

@protocol BOOBreadCrumbDelegate <NSObject>
@optional
-(bool)breadCrumbView:(BOOBreadCrumbView *)breadCrumbView shouldSelectAtIndex:(NSUInteger)index;
-(void)breadCrumbView:(BOOBreadCrumbView *)breadCrumbView didSelectedButtonAtIndex:(NSUInteger)index;
@end

@interface BOOBreadCrumbView : UIScrollView <UIScrollViewDelegate>{
}
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) IBOutlet id <BOOBreadCrumbDelegate> breadCrumbDelegate;
@property (nonatomic, weak) IBOutlet id <BOOBreadCrumbDataSource> breadCrumbDataSource;
@property (nonatomic) CGFloat buttonSpacing;
-(void)setHomeButtonTitle:(NSString *)title;
-(void)addButton;
-(void)removeButtonsAfterIndex:(NSUInteger)index;
@end

//
//  ABBBreadCrumbNavigation.h
//  ABB Power Products and Systems
//
//  Created by Tobias Boogh on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BOOBreadCrumbButton.h"

@protocol BOOBreadCrumbDataSource <NSObject>
-(BOOBreadCrumbButton *)controlForButtonAtIndex:(int)index;
@end

@protocol BOOBreadCrumbDelegate <NSObject>
@optional
-(bool)shouldSelectAtIndex:(int)index;
-(void)buttonSelectedAtIndex:(int)index;
@end

@interface BOOBreadCrumbView : UIScrollView <UIScrollViewDelegate>{
}
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) IBOutlet id <BOOBreadCrumbDelegate> breadCrumbDelegate;
@property (nonatomic, weak) IBOutlet id <BOOBreadCrumbDataSource> breadCrumbDataSource;
@property (nonatomic) CGFloat buttonSpacing;
-(void)setHomeButtonTitle:(NSString *)title;
-(void)addButton;
-(void)removeButtonsAfterIndex:(uint)index;
-(void)clearButtons;
-(void)setHidden:(BOOL)hidden animated:(BOOL)animated;
@end

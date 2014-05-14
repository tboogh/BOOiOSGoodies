//
//  ABBBreadCrumbNavigation.h
//  ABB Power Products and Systems
//
//  Created by Tobias Boogh on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BOOBreadCrumbPosition) {
    kBOOBreadCrumpPositionFirst,
    kBOOBreadCrumpPositionLast
};

@protocol BOOBreadCrumbDelegate <NSObject>
-(bool)shouldSelectAtIndex:(int)index;
-(void)buttonSelectedAtIndex:(int)index;
-(UIControl *)controlForButtonAtIndex:(int)index withPosition:(BOOBreadCrumbPosition)position;
@end

@interface BOOBreadCrumbView : UIScrollView{
}
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) IBOutlet id <BOOBreadCrumbDelegate> breadCrumbDelegate;
@property (nonatomic) CGFloat buttonSpacing;
-(void)setHomeButtonTitle:(NSString *)title;
-(void)addButtonWithTitle:(NSString*)title;
-(void)removeButtonsAfterIndex:(uint)index;
-(void)clearButtons;
-(void)setHidden:(BOOL)hidden animated:(BOOL)animated;
@end

//
//  TINBaseCollectionViewLayout.h
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 05/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kBOOBaseCollectionViewLayoutBackground;

@interface BOOBaseCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic) CGSize totalSize;
@property (nonatomic, strong) NSArray *layoutSections;
@property (nonatomic) UIEdgeInsets margins;
@property (nonatomic) CGSize cellSize;
@property (nonatomic) float falloffDistance;
-(void)prepareLayoutForHorizontalLayout;
@end

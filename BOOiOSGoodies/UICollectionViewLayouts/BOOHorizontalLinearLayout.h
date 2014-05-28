//
//  TINHorizontalLinearLayout.h
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOOBaseCollectionViewLayout.h"
#define DEG2RAD(x) return (x / 180 * M_PI)
// Const for SupplementaryViewOfKind
UIKIT_EXTERN NSString * const kBOOCollectionViewElementKindReflection;
UIKIT_EXTERN NSString * const kBOOCollectionViewElementKindNavigationBackground;
UIKIT_EXTERN NSString * const kBOOCollectionViewElementKindNavigationSectionBackground;
UIKIT_EXTERN NSString * const kBOOCollectionViewElementKindNavigationCell;
UIKIT_EXTERN NSString * const kBOOCollectionViewElementKindNavigationIndicator;

@interface BOOHorizontalLinearLayout : BOOBaseCollectionViewLayout<UICollectionViewDelegateFlowLayout>
@property (nonatomic) BOOL displayNavigation;
@property (nonatomic) BOOL displayBackground;
@property (nonatomic) float zoomScale;
@property (nonatomic) CGFloat navigationHeight;
@property (nonatomic) UIEdgeInsets navigationMargins;
@property (nonatomic) CGSize navigationItemSize;
@end

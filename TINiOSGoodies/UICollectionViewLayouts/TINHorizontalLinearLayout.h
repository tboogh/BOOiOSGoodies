//
//  TINHorizontalLinearLayout.h
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TINBaseCollectionViewLayout.h"
#define DEG2RAD(x) return (x / 180 * M_PI)
@interface TINHorizontalLinearLayout : TINBaseCollectionViewLayout<UICollectionViewDelegateFlowLayout>
@property (nonatomic) float zoomScale;
@end

//
//  TINHorizontalLinearLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOHorizontalLinearLayout.h"
#include "BOOCGUtilites.h"

@interface BOOHorizontalLinearLayout()
@property (nonatomic, strong) UICollectionViewLayoutAttributes *backgroundAttribute;
@end

@implementation BOOHorizontalLinearLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.zoomScale = 1.0f;
        self.falloffDistance = 240;
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayoutForHorizontalLayout];
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kBOOBaseCollectionViewLayoutBackground withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect bounds = self.collectionView.bounds;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    attr.bounds = bounds;
    self.backgroundAttribute = attr;
}

-(CGSize)collectionViewContentSize{
    return self.totalSize;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *intersectingArray = [[NSMutableArray alloc] init];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributes) {
        if (CGRectIntersectsRect(rect, attr.frame)){
            CATransform3D transform;
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attr.center.x;
            CGFloat normalizedDistance = distance / self.falloffDistance;
            
            attr.zIndex = 1;
            CGFloat zoom = self.zoomScale;
            
            if (ABS(distance) < self.falloffDistance){
                float factor = (1 - ABS(normalizedDistance));
                zoom = self.zoomScale + ((1.0f - self.zoomScale) * factor);
                attr.zIndex = 2;
            }
            
            transform = CATransform3DMakeScale(zoom, zoom, 1.0);
            attr.transform3D = transform;
            [intersectingArray addObject:attr];
        }
    }
    CGRect frame = self.backgroundAttribute.frame;
    frame.origin =self.collectionView.contentOffset;
    self.backgroundAttribute.frame = frame;
    [intersectingArray addObject:self.backgroundAttribute];
    return intersectingArray;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.layoutAttributes objectAtIndex:indexPath.row];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    if ([decorationViewKind isEqualToString:kBOOBaseCollectionViewLayoutBackground]){
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kBOOBaseCollectionViewLayoutBackground withIndexPath:indexPath];
        
        CGRect bounds = self.collectionView.bounds;
        bounds.origin = CGPointZero;
        attr.bounds = bounds;
        attr.zIndex = 0;
        return attr;
    }
    return nil;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect offsetRect = self.collectionView.bounds;
    offsetRect.origin = proposedContentOffset;
    CGPoint closestPoint = CGPointMake(INFINITY, INFINITY);
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributes) {
        if (CGRectIntersectsRect(offsetRect, attr.frame)){
            float offsetRectMidX = CGRectGetMidX(offsetRect);
            if (ABS(offsetRectMidX - attr.center.x) < ABS(offsetRectMidX - closestPoint.x)){
                closestPoint = attr.center;
            }
        }
    };
    closestPoint.x -= (self.collectionView.bounds.size.width * 0.5f);
    return closestPoint;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    return proposedContentOffset;
}

@end

//
//  TINHorizontalLinearLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "TINHorizontalLinearLayout.h"
#include "TINCGUtilites.h"

@interface TINHorizontalLinearLayout()
@property (nonatomic, strong) UICollectionViewLayoutAttributes *backgroundAttribute;
@property (nonatomic, strong) NSMutableArray *reflectionAttributes;
@end

@implementation TINHorizontalLinearLayout

NSString * const kTINHorizontalLinearLayoutViewReflectionKind = @"kTINHorizontalLinearLayoutViewReflectionKind";

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
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kTINBaseCollectionViewLayoutBackground withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect bounds = self.collectionView.bounds;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    attr.bounds = bounds;
    self.backgroundAttribute = attr;
    
    NSMutableArray *reflectedSections = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSArray *rowArray in self.layoutSections) {
        NSMutableArray *reflectionRows = [[NSMutableArray alloc] initWithCapacity:1];
        [reflectedSections addObject:reflectionRows];
        for (UICollectionViewLayoutAttributes *attributes in rowArray){
            UICollectionViewLayoutAttributes *reflectedAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTINHorizontalLinearLayoutViewReflectionKind withIndexPath:[NSIndexPath indexPathForRow:attributes.indexPath.row inSection:attributes.indexPath.section]];
            reflectedAttribute.frame = attributes.frame;
            reflectedAttribute.zIndex = 1;
            [reflectionRows addObject:reflectedAttribute];
        }
    }
    self.reflectionAttributes = reflectedSections;
}

-(CGSize)collectionViewContentSize{
    return self.totalSize;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(UICollectionViewLayoutAttributes *)adjustedAttributeForAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    CATransform3D transform;
    
    CGFloat distance = CGRectGetMidX(visibleRect) - attribute.center.x;
    CGFloat normalizedDistance = distance / self.falloffDistance;
    
    attribute.zIndex = 2;
    CGFloat zoom = self.zoomScale;
    
    if (ABS(distance) < self.falloffDistance){
        float factor = (1 - ABS(normalizedDistance));
        zoom = self.zoomScale + ((1.0f - self.zoomScale) * factor);
        attribute.zIndex = 3;
    }
    
    transform = CATransform3DMakeScale(zoom, zoom, 1.0);
    attribute.transform3D = transform;
    return attribute;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *intersectingArray = [[NSMutableArray alloc] init];
    
    for (NSArray *rows in self.layoutSections) {
        for (UICollectionViewLayoutAttributes *attr in rows) {
            if (CGRectIntersectsRect(rect, attr.frame)){
                UICollectionViewLayoutAttributes *attribute = [self adjustedAttributeForAttribute:attr];
                [intersectingArray addObject:attribute];
                
                UICollectionViewLayoutAttributes *reflectedAttribute = [self adjustedAttributeForAttribute:[[self.reflectionAttributes objectAtIndex:attr.indexPath.section] objectAtIndex:attr.indexPath.row]];
                
                CATransform3D transform = reflectedAttribute.transform3D;
                transform = CATransform3DScale(transform, 1.0, -1.0, 1.0);
                transform = CATransform3DTranslate(transform, 0.0f, -reflectedAttribute.bounds.size.height, 0.0f);
                reflectedAttribute.transform3D = transform;
                [intersectingArray addObject:reflectedAttribute];
            }
        }
    }
    CGRect frame = self.backgroundAttribute.frame;
    frame.origin =self.collectionView.contentOffset;
    self.backgroundAttribute.frame = frame;
    [intersectingArray addObject:self.backgroundAttribute];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return intersectingArray;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self adjustedAttributeForAttribute:[[self.layoutSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    if ([decorationViewKind isEqualToString:kTINBaseCollectionViewLayoutBackground]){
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kTINBaseCollectionViewLayoutBackground withIndexPath:indexPath];
        
        CGRect bounds = self.collectionView.bounds;
        bounds.origin = CGPointZero;
        attr.bounds = bounds;
        attr.zIndex = 0;
        return attr;
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:kTINHorizontalLinearLayoutViewReflectionKind]){
        UICollectionViewLayoutAttributes *reflectedAttribute = [self adjustedAttributeForAttribute:[[self.reflectionAttributes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        CATransform3D transform = reflectedAttribute.transform3D;
        transform = CATransform3DScale(transform, 1.0, -1.0, 1.0);
        transform = CATransform3DTranslate(transform, 0.0f, -reflectedAttribute.bounds.size.height, 0.0f);
        reflectedAttribute.transform3D = transform;
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, reflectedAttribute);
        return reflectedAttribute;
    }
    return nil;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGRect offsetRect = self.collectionView.bounds;
    offsetRect.origin = proposedContentOffset;
    CGPoint closestPoint = CGPointMake(INFINITY, INFINITY);
    for (NSArray *rows in self.layoutSections) {
        for (UICollectionViewLayoutAttributes *attr in rows) {
            if (CGRectIntersectsRect(offsetRect, attr.frame)){
                float offsetRectMidX = CGRectGetMidX(offsetRect);
                if (ABS(offsetRectMidX - attr.center.x) < ABS(offsetRectMidX - closestPoint.x)){
                    closestPoint = attr.center;
                }
            }
        }
    };
    closestPoint.x -= (self.collectionView.bounds.size.width * 0.5f);
    return closestPoint;
}

-(void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)finalizeLayoutTransition{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end

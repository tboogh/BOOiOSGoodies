//
//  TINHorizontalLinearLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOHorizontalLinearLayout.h"
#include "BOOUtilities.h"

@interface BOOHorizontalLinearLayout()
@property (nonatomic, strong) UICollectionViewLayoutAttributes *backgroundAttribute;
@property (nonatomic, strong) NSMutableArray *reflectionAttributes;
@property (nonatomic, strong) NSMutableArray *navigationAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *navigationIndiciatorAttribute;
@property (nonatomic) CGRect navigationRect;
@end

@implementation BOOHorizontalLinearLayout

NSString * const kBOOCollectionViewElementKindReflection = @"kBOOCollectionViewElementKindReflection";
NSString * const kBOOCollectionViewElementKindNavigationBackground = @"kBOOCollectionViewElementKindNavigationBackground";
NSString * const kBOOCollectionViewElementKindNavigationCell = @"kBOOCollectionViewElementKindNavigationCell";
NSString * const kBOOCollectionViewElementKindNavigationIndicator = @"kBOOCollectionViewElementKindNavigationIndicator";
NSString * const kBOOCollectionViewElementKindNavigationSectionBackground = @"kBOOCollectionViewElementKindNavigationSectionBackground";

- (id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib{
    [self commonInit];
}

-(void)commonInit{
    self.zoomScale = 1.0f;
    self.falloffDistance = 240;
    self.displayBackground = NO;
    self.displayNavigation = NO;
    self.navigationMargins = UIEdgeInsetsMake(20, 20, 20, 20);
    self.navigationItemSize = CGSizeMake(40, 40);
    self.navigationHeight = 60.0f;
}

-(void)prepareLayout{
    [super prepareLayoutForHorizontalLayout];
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kBOOBaseCollectionViewLayoutBackground withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
            UICollectionViewLayoutAttributes *reflectedAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kBOOCollectionViewElementKindReflection withIndexPath:[NSIndexPath indexPathForRow:attributes.indexPath.row inSection:attributes.indexPath.section]];
            reflectedAttribute.frame = attributes.frame;
            reflectedAttribute.zIndex = 1;
            [reflectionRows addObject:reflectedAttribute];
        }
    }
    self.reflectionAttributes = reflectedSections;
    
    
    if (self.displayNavigation){
        NSMutableArray *navigationSectionAttributes = [[NSMutableArray alloc] init];
        
        CGSize itemSize = self.navigationItemSize;
        CGFloat itemSpacing = 0;
        UIEdgeInsets sectionEdgeInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        CGRect previousSectionRect = CGRectZero;
        NSUInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
        
        
        for (int sectionIndex=0; sectionIndex < sections; ++sectionIndex){
            NSUInteger itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionIndex];
            NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            
            UICollectionViewLayoutAttributes *sectionLayoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kBOOCollectionViewElementKindNavigationSectionBackground withIndexPath:sectionIndexPath];
            CGSize sectionSize  = CGSizeMake((itemSize.width * itemCount) + (itemSpacing * (itemCount - 1)) + sectionEdgeInset.left + sectionEdgeInset.right, self.navigationHeight + sectionEdgeInset.top + sectionEdgeInset.bottom);
            CGRect sectionFrame = CGRectMake(CGRectGetMaxX(previousSectionRect), 0, sectionSize.width, sectionSize.height);
            
            sectionLayoutAttribute.frame = sectionFrame;
            previousSectionRect = sectionFrame;
            
            BOOCollectionViewLayoutAttributeSection *attributeSection = [[BOOCollectionViewLayoutAttributeSection alloc] init];
            attributeSection.sectionAttribute = sectionLayoutAttribute;
            [navigationSectionAttributes addObject:attributeSection];
            
            for (int itemIndex=0; itemIndex < itemCount; ++itemIndex){
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
                UICollectionViewLayoutAttributes *itemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kBOOCollectionViewElementKindNavigationCell withIndexPath:itemIndexPath];
                CGRect itemFrame;
                itemFrame.size = itemSize;
                itemFrame.origin = CGPointMake(sectionEdgeInset.left + (itemIndex * (itemSize.width + itemSpacing)), sectionFrame.origin.y + sectionEdgeInset.top);
                itemAttribute.frame = itemFrame;
                [attributeSection.sectionAttributes addObject:itemAttribute];
            }
        }
        
        CGRect navigationFrame;
        UICollectionViewLayoutAttributes *lastNavigationAttribute = [[navigationSectionAttributes lastObject] sectionAttribute];
        CGRect frame = lastNavigationAttribute.frame;
        CGFloat maxX = CGRectGetMaxX(frame);
        navigationFrame = CGRectMake(0, 0, maxX, frame.size.height);
        
        for (BOOCollectionViewLayoutAttributeSection *attribute in navigationSectionAttributes) {
            CGRect attributeFrame = attribute.sectionAttribute.frame;
            attributeFrame.origin.x = self.collectionView.bounds.size.width - maxX + attributeFrame.origin.x;
            attribute.sectionAttribute.frame = attributeFrame;
            
            for (UICollectionViewLayoutAttributes *itemAttribute in attribute.sectionAttributes){
                CGRect itemFrame = itemAttribute.frame;
                itemFrame.size = itemSize;
                itemFrame.origin.x += attributeFrame.origin.x;
                itemAttribute.frame = itemFrame;
            }
        }
        UICollectionViewLayoutAttributes *firstNaviationAttribute = [[navigationSectionAttributes firstObject] sectionAttribute];
        navigationFrame.origin = firstNaviationAttribute.frame.origin;
        self.navigationRect = navigationFrame;
        
        UICollectionViewLayoutAttributes *indicatorAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kBOOCollectionViewElementKindNavigationIndicator withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        indicatorAttribute.frame = CGRectMake(0, 0, 8, 8);
        indicatorAttribute.zIndex = 5;
        self.navigationIndiciatorAttribute = indicatorAttribute;
        
        self.navigationAttributes = navigationSectionAttributes;
    }
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
    
    if (self.displayBackground){
        CGRect frame = self.backgroundAttribute.frame;
        frame.origin =self.collectionView.contentOffset;
        self.backgroundAttribute.frame = frame;
        [intersectingArray addObject:self.backgroundAttribute];
    }
    
    if (self.displayNavigation){
        for (BOOCollectionViewLayoutAttributeSection *attribute in self.navigationAttributes) {
            UICollectionViewLayoutAttributes *attr = [attribute.sectionAttribute copy];
            CGRect frame = attr.frame;
            frame.origin.x += self.collectionView.contentOffset.x;
            attr.zIndex = 2;
            attr.frame = frame;
            [intersectingArray addObject:attr];
            for (UICollectionViewLayoutAttributes *itemAttribute in attribute.sectionAttributes){
                UICollectionViewLayoutAttributes *itemAttributeCopy = [itemAttribute copy];
                itemAttributeCopy.zIndex = 3;
                CGRect itemFrame = itemAttributeCopy.frame;
                itemFrame.origin.x += self.collectionView.contentOffset.x;
                itemAttributeCopy.frame = itemFrame;
                [intersectingArray addObject:itemAttributeCopy];
            }
        }
        
        UICollectionViewLayoutAttributes *indiciatorAttribute = [self.navigationIndiciatorAttribute copy];
        CGRect indiciatorFrame = indiciatorAttribute.frame;
        
        CGPoint contentOffset = self.collectionView.contentOffset;
        CGFloat fraction = contentOffset.x / (self.collectionView.contentSize.width - self.collectionView.bounds.size.width);
        CGFloat navigationX = ((self.navigationRect.size.width - self.navigationItemSize.width) * fraction) + self.navigationRect.origin.x + contentOffset.x + ((self.navigationItemSize.width * 0.5) - (indiciatorFrame.size.width * 0.5));
        
        
        indiciatorFrame.origin.x = navigationX;
        indiciatorFrame.origin.y = self.navigationRect.origin.y + self.navigationRect.size.height - 1 - indiciatorFrame.size.height;
        indiciatorAttribute.frame = indiciatorFrame;
        [intersectingArray addObject:indiciatorAttribute];
    }
    return intersectingArray;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self adjustedAttributeForAttribute:[[self.layoutSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    if ([decorationViewKind isEqualToString:kBOOBaseCollectionViewLayoutBackground]){
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kBOOBaseCollectionViewLayoutBackground withIndexPath:indexPath];
        
        CGRect bounds = self.collectionView.bounds;
        bounds.origin = CGPointZero;
        attr.bounds = bounds;
        attr.zIndex = 0;
        return attr;
    } else if ([decorationViewKind isEqualToString:kBOOCollectionViewElementKindNavigationBackground]){
        if (self.displayNavigation){
            CGRect frame = self.backgroundAttribute.frame;
            frame.origin = self.collectionView.contentOffset;
            CGSize navigationSize = frame.size;
            navigationSize.height = self.navigationHeight;
            
            frame.origin.x = CGRectGetMaxX(frame) - navigationSize.width - self.navigationMargins.right;
            frame.origin.y = self.navigationMargins.top;
            
            UICollectionViewLayoutAttributes *navigationBackgroundAttribute = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kBOOCollectionViewElementKindNavigationBackground withIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            navigationBackgroundAttribute.frame = frame;
            return navigationBackgroundAttribute;
        }
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:kBOOCollectionViewElementKindReflection]){
        UICollectionViewLayoutAttributes *reflectedAttribute = [self adjustedAttributeForAttribute:[[self.reflectionAttributes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        CATransform3D transform = reflectedAttribute.transform3D;
        transform = CATransform3DScale(transform, 1.0, -1.0, 1.0);
        transform = CATransform3DTranslate(transform, 0.0f, -reflectedAttribute.bounds.size.height, 0.0f);
        reflectedAttribute.transform3D = transform;
        return reflectedAttribute;
    } else if ([kind isEqualToString:kBOOCollectionViewElementKindNavigationSectionBackground]){
        UICollectionViewLayoutAttributes *attribute = [[self.navigationAttributes[indexPath.section] sectionAttribute] copy];
        CGRect frame = attribute.frame;
        frame.origin.x += self.collectionView.contentOffset.x;
        attribute.frame = frame;
        return attribute;
    } else if ([kind isEqualToString:kBOOCollectionViewElementKindNavigationCell]){
        BOOCollectionViewLayoutAttributeSection *attribute = self.navigationAttributes[indexPath.section];
        UICollectionViewLayoutAttributes *itemAttribute = attribute.sectionAttributes[indexPath.row];
        UICollectionViewLayoutAttributes *itemAttributeCopy = [itemAttribute copy];
        itemAttributeCopy.zIndex = 3;
        CGRect itemFrame = itemAttributeCopy.frame;
        itemFrame.origin.x += self.collectionView.contentOffset.x;
        itemAttributeCopy.frame = itemFrame;
        return itemAttributeCopy;
    } else if ([kind isEqualToString:kBOOCollectionViewElementKindNavigationIndicator]){
        UICollectionViewLayoutAttributes *indiciatorAttribute = [self.navigationIndiciatorAttribute copy];
        CGRect rect = self.collectionView.frame;
        rect.origin = self.collectionView.contentOffset;
        indiciatorAttribute.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        return indiciatorAttribute;
    }
    return nil;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
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

@end

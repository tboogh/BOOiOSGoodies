//
//  TINVerticalCollectionViewLayout.m
//  Catalog
//
//  Created by Tobias Boogh on 11/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOVerticalCollectionViewLayout.h"

@implementation BOOVerticalCollectionViewLayout

-(CGSize)collectionViewContentSize{
    return self.totalSize;
}

-(void)prepareLayout{
    [super prepareLayout];
    id<UICollectionViewDelegateFlowLayout> flowLayoutDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    NSUInteger numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGSize totalSize = CGSizeZero;
    
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSUInteger sectionIndex=0; sectionIndex < numberOfSections; ++sectionIndex){
        NSUInteger numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionIndex];
        CGSize headerSize = CGSizeZero;
        if ([flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]){
            headerSize = [flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:sectionIndex];
        }
        UICollectionViewLayoutAttributes *sectionAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
        sectionAttribute.frame = CGRectMake(0, totalSize.height, headerSize.width, headerSize.height);
        totalSize.width = MAX(headerSize.width, totalSize.width);
        totalSize.height += headerSize.height;
        
        BOOCollectionViewLayoutAttributeSection *layoutAttributeSection = [[BOOCollectionViewLayoutAttributeSection alloc] init];
        layoutAttributeSection.sectionAttribute = sectionAttribute;
        [sectionArray addObject:layoutAttributeSection];
        CGRect lastItemRect = CGRectZero;
        for (NSUInteger itemIndex=0; itemIndex < numberOfItems; ++itemIndex){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            CGSize itemSize = CGSizeMake(100, 100);
            if ([flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]){
                itemSize = [flowLayoutDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            }
            
            CGRect itemFrame;
            if ((CGRectGetMaxX(lastItemRect) + itemSize.width) > collectionViewSize.width){
                itemFrame.origin.x = 0;
                itemFrame.origin.y = totalSize.height;
            } else {
                itemFrame.origin.x = CGRectGetMaxX(lastItemRect);
                itemFrame.origin.y = lastItemRect.origin.y;
            }
            itemFrame.size = itemSize;
            
            lastItemRect = itemFrame;
            totalSize.height = lastItemRect.origin.y + lastItemRect.size.height;
            UICollectionViewLayoutAttributes *itemAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttribute.frame = itemFrame;
            
            [layoutAttributeSection.sectionAttributes addObject:itemAttribute];
        }
    }
    self.layoutSections = sectionArray;
    self.totalSize = totalSize;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *intersectingArray = [[NSMutableArray alloc] init];
    for (BOOCollectionViewLayoutAttributeSection *section in self.layoutSections) {
        if (CGRectIntersectsRect(rect, section.sectionAttribute.frame)){
            [intersectingArray addObject:section.sectionAttribute];
        }
        for (UICollectionViewLayoutAttributes *attribute in section.sectionAttributes){
            if (CGRectIntersectsRect(rect, attribute.frame)){
                [intersectingArray addObject:attribute];
            }
        }
    }
    return intersectingArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    BOOCollectionViewLayoutAttributeSection *sectionAttributes = self.layoutSections[indexPath.section];
    UICollectionViewLayoutAttributes *itemAttribute = sectionAttributes.sectionAttributes[indexPath.row];
    return itemAttribute;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        BOOCollectionViewLayoutAttributeSection *sectionAttributes = self.layoutSections[indexPath.section];
        return sectionAttributes.sectionAttribute;
    }
    return nil;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end

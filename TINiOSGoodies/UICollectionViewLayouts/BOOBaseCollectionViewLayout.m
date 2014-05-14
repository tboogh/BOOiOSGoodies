//
//  TINBaseCollectionViewLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 05/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOBaseCollectionViewLayout.h"

NSString *const kBOOBaseCollectionViewLayoutBackground = @"TINBaseCollectionViewLayoutBackground";

@implementation BOOBaseCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellSize = CGSizeMake(100, 100);
    }
    return self;
}

-(void)prepareLayoutForHorizontalLayout{
    BOOL dynamicCellSize = [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
    NSMutableArray *attributeArray = [[NSMutableArray alloc] initWithCapacity:1];
    CGSize totalSize = CGSizeZero;

    long sectionCount = [self.collectionView numberOfSections];
    for (int section=0; section < sectionCount; ++section){
        long rowsInSection = [self.collectionView numberOfItemsInSection:section];
        for (int row=0; row < rowsInSection; ++row) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize cellSize = self.cellSize;
            if (dynamicCellSize){
                cellSize = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            }
            
            int x = self.margins.left + totalSize.width;
            int y = (self.collectionView.frame.size.height * 0.5f) - (cellSize.height * 0.5f) - self.margins.top;
            CGRect cellFrame = CGRectMake(x, y, cellSize.width, cellSize.height);
            
            if (CGSizeEqualToSize(totalSize, CGSizeZero)){
                cellFrame.origin.x += (self.collectionView.bounds.size.width * 0.5f) - CGRectGetMidX(cellFrame);
            }
            
            attr.frame = cellFrame;
            
            [attributeArray addObject:attr];
            
            totalSize.height = MAX(totalSize.height, y + cellSize.height + self.margins.bottom);
            totalSize.width = cellFrame.origin.x + cellFrame.size.width + self.margins.right;
        }
    }
    UICollectionViewLayoutAttributes *lastAttribute = [attributeArray lastObject];
    totalSize.width += (self.collectionView.bounds.size.width * 0.5f) - (lastAttribute.frame.size.width * 0.5f);
    
    
    self.totalSize = totalSize;
    self.layoutAttributes = attributeArray;
}
@end

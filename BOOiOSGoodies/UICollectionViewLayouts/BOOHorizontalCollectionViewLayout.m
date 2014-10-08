//
//  TINHorizontalCollectionViewLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOOHorizontalCollectionViewLayout.h"

@implementation BOOHorizontalCollectionViewLayout
-(id)init{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    BOOL foundHeader = NO;
    for (UICollectionViewLayoutAttributes *attribute in attributes){
        if ([attribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
            [self modifyAttribute:attribute];
            foundHeader = YES;
        }
    }
    if (!foundHeader && self.stickHeader){
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self modifyAttribute:attribute];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:attributes];
        [array addObject:attribute];
        attributes = array;
    }
    return attributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(void)modifyAttribute:(UICollectionViewLayoutAttributes *)attribute{
    CGRect frame = attribute.frame;
    frame.origin.x = self.collectionView.contentOffset.x;
    attribute.frame = frame;
    attribute.zIndex = NSIntegerMax;
//    NSLog(@"%@", attribute);
}
@end

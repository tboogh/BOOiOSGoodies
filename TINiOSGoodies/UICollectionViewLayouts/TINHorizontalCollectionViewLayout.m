//
//  TINHorizontalCollectionViewLayout.m
//  TINCollectionViewLayoutDemo
//
//  Created by Tobias Boogh on 25/04/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "TINHorizontalCollectionViewLayout.h"

@implementation TINHorizontalCollectionViewLayout
-(id)init{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
@end

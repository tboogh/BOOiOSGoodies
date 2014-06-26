//
//  BOODemoCollectionViewController.h
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 18/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BOODemoCollectionViewLayouts) {
    kBOODemoCollectionViewHorizontalLayout,
    kBOODemoCollectionViewVerticalLayout,
    kBOODemoCollectionViewLinearLayout
};

@interface BOODemoCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *collectionViewSectionData;
-(void)setLayout:(BOODemoCollectionViewLayouts)layout;
@end

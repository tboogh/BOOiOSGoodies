//
//  BOODemoCollectionViewController.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 18/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOODemoCollectionViewController.h"
#import "BOODemoCollectionViewCell.h"

#import "BOOImageCache.h"
#import "UIImage+BOOImageCache.h"
#import "BOOHorizontalCollectionViewLayout.h"
#import "BOOVerticalCollectionViewLayout.h"
#import "BOOHorizontalLinearLayout.h"


@interface BOODemoCollectionViewController ()
@property (nonatomic) BOODemoCollectionViewLayouts currentLayout;
@end

@implementation BOODemoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestImages" ofType:nil];
    NSArray *filePathContents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    if (filePathContents == nil){
        return;
    }
    NSMutableArray *imageFileArray = [[NSMutableArray alloc] init];
    [filePathContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *fileName = (NSString *)obj;
        NSDictionary *dataDict = @{@"title": [[fileName lastPathComponent] stringByDeletingPathExtension], @"imageName": [path stringByAppendingPathComponent:fileName]};
        [imageFileArray addObject:dataDict];
    }];
    self.collectionViewSectionData = @[
                                           @{
                                               @"title": @"section1",
                                               @"rowData": imageFileArray
                                           },
                                           @{
                                               @"title": @"section1",
                                               @"rowData": imageFileArray
                                           },
                                           @{
                                               @"title": @"section1",
                                               @"rowData": imageFileArray
                                           }
                                           ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout:(BOODemoCollectionViewLayouts)layout{
    UICollectionViewLayout *collectionViewLayout = nil;
    switch (layout) {
        case kBOODemoCollectionViewHorizontalLayout:
            collectionViewLayout = [[BOOHorizontalCollectionViewLayout alloc] init];
            break;
        case kBOODemoCollectionViewLinearLayout:
            collectionViewLayout = [[BOOHorizontalLinearLayout alloc] init];
            break;
        case kBOODemoCollectionViewVerticalLayout:
            collectionViewLayout = [[BOOVerticalCollectionViewLayout alloc] init];
            break;
    }
    [self.collectionView setCollectionViewLayout:collectionViewLayout animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionViewSectionData.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *sectionDict = [self.collectionViewSectionData objectAtIndex:section];
    NSArray *rowData = [sectionDict valueForKey:@"rowData"];
    return rowData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BOODemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"demoCell" forIndexPath:indexPath];
    NSDictionary *sectionDict = [self.collectionViewSectionData objectAtIndex:indexPath.section];
    NSArray *rowData = [sectionDict valueForKey:@"rowData"];
    NSDictionary *itemDict = [rowData objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = itemDict[@"title"];
    [UIImage thumbnailForImageWithFilepath:itemDict[@"imageName"] withSize:cell.imageView.bounds.size withCompletion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(200, 220);
}

@end

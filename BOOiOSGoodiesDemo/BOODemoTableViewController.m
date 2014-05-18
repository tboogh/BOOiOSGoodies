//
//  BOODemoTableViewController.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 18/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOODemoTableViewController.h"
#import "BOODemoCollectionViewController.h"
#import "BOODemoDetailViewController.h"

typedef NS_ENUM(NSUInteger, BooDemoViewControllers) {
    kBOODemoCollectionViewController,
};

@interface BOODemoTableViewController ()

@end

@implementation BOODemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.tableData == nil){
    self.tableData = @[
                       @{@"title" : @"CollectionViewLayouts",
                       @"tableData" : @[
                                 @{
                                     @"title": @"Vertical",
                                     @"controller": @(kBOODemoCollectionViewController),
                                     @"data": @(kBOODemoCollectionViewVerticalLayout)
                                    },
                                 @{
                                     @"title": @"Horizontal",
                                     @"controller": @(kBOODemoCollectionViewController),
                                     @"data": @(kBOODemoCollectionViewHorizontalLayout)
                                    },
                                 @{
                                     @"title": @"Linear",
                                     @"controller": @(kBOODemoCollectionViewController),
                                     @"data": @(kBOODemoCollectionViewLinearLayout)
                                     }
                                 ]
                         }
                       ];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.tableData[indexPath.row] valueForKey:@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *controller = [self.tableData[indexPath.row] valueForKey:@"controller"];
    UIViewController *presentController = nil;
    UIViewController *dataController = nil;
    UINavigationController *detailNavController = self.splitViewController.childViewControllers[1];
    if (controller != nil){
        switch ([controller unsignedIntegerValue]) {
            case kBOODemoCollectionViewController:{
                if ([[detailNavController topViewController] isKindOfClass:[BOODemoCollectionViewController class]
                     ]){
                    dataController = [detailNavController topViewController];
                } else {
                    BOODemoCollectionViewController *collectionViewController = [[UIStoryboard storyboardWithName:@"BOOCollectionViewDemoStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                    presentController = collectionViewController;
                    dataController = collectionViewController;
                }
                NSNumber *data = [self.tableData[indexPath.row] valueForKey:@"data"];
                [(BOODemoCollectionViewController *)dataController setLayout:[data unsignedIntegerValue]];
                
            } break;
        }
        
        if (presentController != nil){
            UINavigationController *otherViewController = self.splitViewController.childViewControllers[1];
            if (otherViewController.childViewControllers.count >= 1){
                [otherViewController popToRootViewControllerAnimated:NO];
            }
            [otherViewController popToRootViewControllerAnimated:NO];
            [otherViewController pushViewController:presentController animated:YES];
        }
    }
    
    NSArray *tableData = [self.tableData[indexPath.row] valueForKey:@"tableData"];
    if (tableData != nil){
        BOODemoTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"booDemoTableViewController"];
        tableViewController.tableData = tableData;
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
}

@end

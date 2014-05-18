//
//  BOODemoCollectionViewController.m
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 18/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOODemoCollectionViewController.h"

@interface BOODemoCollectionViewController ()
@property (nonatomic) BOODemoCollectionViewLayouts currentLayout;
@end

@implementation BOODemoCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout:(BOODemoCollectionViewLayouts)layout{
    NSLog(@"new layout: %d", layout);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

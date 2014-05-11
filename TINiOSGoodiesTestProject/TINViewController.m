//
//  TINViewController.m
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 11/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "TINViewController.h"

@interface TINViewController ()

@end

@implementation TINViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.gradientBackground addColor:[UIColor blueColor]];
    [self.gradientBackground addColor:[UIColor yellowColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

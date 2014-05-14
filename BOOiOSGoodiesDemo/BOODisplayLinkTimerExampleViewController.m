//
//  BOODisplayLinkTimerExampleViewController.m
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 13/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOODisplayLinkTimerExampleViewController.h"
#import "BOODisplayLinkTimer.h"
@interface BOODisplayLinkTimerExampleViewController ()

@end

@implementation BOODisplayLinkTimerExampleViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startTimer:(id)sender {
    self.timerTextView.text = @"";
    [BOODisplayLinkTimer timerWithLength:60.0f withIntervalBlock:^(CGFloat delta, CGFloat target) {
       dispatch_async(dispatch_get_main_queue(), ^{
           self.timerTextView.text = [NSString stringWithFormat:@"delta: %f end: %f\n%@", delta, target, self.timerTextView.text];
       });
    } withCompletion:^{
        NSLog(@"Done!");
    }];
}
@end

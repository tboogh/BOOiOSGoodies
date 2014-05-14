//
//  BOODisplayLinkTimerExampleViewController.h
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 13/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOODisplayLinkTimerExampleViewController : UIViewController
- (IBAction)startTimer:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *timerTextView;

@end

//
//  TINDisplayLinkTimer.h
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 13/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BOODisplayLinkTimerIntervalBlock)(CGFloat current, CGFloat end);
typedef void(^BOODisplayLinkCompletion)();

@interface BOODisplayLinkTimer : NSObject
+(BOODisplayLinkTimer *)timerWithLength:(CGFloat)length withIntervalBlock:(BOODisplayLinkTimerIntervalBlock)block withCompletion:(BOODisplayLinkCompletion)completion;
-(void)removeTimer;
@end

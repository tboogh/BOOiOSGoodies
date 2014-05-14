//
//  TINDisplayLinkTimer.m
//  TINiOSGoodies
//
//  Created by Tobias Boogh on 13/05/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

#import "BOODisplayLinkTimer.h"

@interface BOODisplayLinkTimerManager : NSObject
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *timerInstances;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) CFTimeInterval lastTime;
@end

@interface BOODisplayLinkTimer()

@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat current;
@property (nonatomic) CGFloat delta;
@property (nonatomic, strong) BOODisplayLinkTimerIntervalBlock block;
@property (nonatomic, strong) BOODisplayLinkCompletion completion;

@end

@implementation BOODisplayLinkTimerManager

+(BOODisplayLinkTimerManager *)sharedInstance{
    static BOODisplayLinkTimerManager *displayLinkTimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayLinkTimer = [[BOODisplayLinkTimerManager alloc] init];
    });
    return displayLinkTimer;
}

-(void)addTimer:(BOODisplayLinkTimer *)timer{
    BOODisplayLinkTimerManager *manager = [BOODisplayLinkTimerManager sharedInstance];
    [manager.timerInstances addObject:timer];
    if (manager.displayLink == nil){
        [manager startTimer];
    }
}

-(id)init{
    self = [super init];
    if (self){
        self.timerInstances = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)startTimer{
    if (self.displayLink != nil){
        [self stopTimer];
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate:)];
    self.displayLink.frameInterval = 1.0f;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.startTime = -54321;
}

-(void)stopTimer{
    if (self.displayLink != nil){
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(void)removeTimer:(BOODisplayLinkTimer *)timer{
    [self.timerInstances removeObject:timer];
    if (self.timerInstances.count == 0){
        [self stopTimer];
    }
}

- (void)displayLinkUpdate:(CADisplayLink *)sender{
    if (self.startTime == -54321){
        self.startTime = sender.timestamp;
        self.lastTime = sender.timestamp;
    }
    [self.timerInstances enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOODisplayLinkTimer *timerInstance = (BOODisplayLinkTimer *)obj;
        timerInstance.current += sender.timestamp - self.startTime;
        timerInstance.delta = (sender.timestamp - self.lastTime);
        timerInstance.block(timerInstance.delta, timerInstance.length);
        if (timerInstance.current >= timerInstance.length){
            if (timerInstance.completion != nil){
                timerInstance.completion();
            }
            [self.timerInstances removeObjectAtIndex:idx];
            if (self.timerInstances.count == 0){
                [self stopTimer];
            }
        }
    }];
    self.lastTime = sender.timestamp;
}
@end

@implementation BOODisplayLinkTimer

- (id)init{
    self = [super init];
    if (self) {
        _current = 0.0f;
        _length = 0.0f;
        _delta = 0.0f;
    }
    return self;
}

+(BOODisplayLinkTimer *)timerWithLength:(CGFloat)length withIntervalBlock:(BOODisplayLinkTimerIntervalBlock)block withCompletion:(BOODisplayLinkCompletion)completion{
    BOODisplayLinkTimer *timerInstance = [[BOODisplayLinkTimer alloc] init];
    timerInstance.length = length;
    timerInstance.block = block;
    timerInstance.completion = completion;
    [[BOODisplayLinkTimerManager sharedInstance] addTimer:timerInstance];
    return timerInstance;
}

-(void)removeTimer{
    BOODisplayLinkTimerManager *manager = [BOODisplayLinkTimerManager sharedInstance];
    [manager.timerInstances removeObject:self];
}
@end

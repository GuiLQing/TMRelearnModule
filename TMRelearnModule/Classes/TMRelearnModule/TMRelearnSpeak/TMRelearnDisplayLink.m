//
//  TMRelearnDisplayLink.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnDisplayLink.h"

@interface TMRelearnDisplayLink ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation TMRelearnDisplayLink

- (void)displayLinkAction {
    _counter ++;
    _currentTime += 1.0 / 60;
    
    CGFloat progress = _counter / 60 / _duration;
    if (self.progressCallback) self.progressCallback(progress);
    
    NSTimeInterval remaindTimeInterval = _duration * (1.0 - progress);
    if (self.remaindTimeIntervalCallback) self.remaindTimeIntervalCallback(remaindTimeInterval);
    
    if (_currentTime >= _duration) { //倒计时结束
        [self stopDisplayLink];
        if (self.completeCallback) self.completeCallback();
    }
}

- (void)restartDisplayLinkWithDuration:(NSTimeInterval)duration {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    
    self.currentTime = 0;
    self.counter = 0;
    self.duration = duration;
    
    [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink {
    [self.displayLink invalidate];
    self.displayLink.paused = YES;
}

@end

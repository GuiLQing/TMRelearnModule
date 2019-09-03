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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return self;
}

- (void)displayLinkAction {
    _counter ++;
    _currentTime += 1.0 / 60;
    
    CGFloat progress = _counter / 60 / _duration;
    if (self.progressCallback) self.progressCallback(progress);
    
    NSTimeInterval remaindTimeInterval = _duration * (1.0 - progress);
    if (self.remaindTimeIntervalCallback) self.remaindTimeIntervalCallback(remaindTimeInterval);
    
    if (_currentTime >= _duration) { //倒计时结束
        _displayLink.paused = YES;
        if (self.completeCallback) self.completeCallback();
    }
}

- (void)restartDisplayLinkWithDuration:(NSTimeInterval)duration {
    self.currentTime = 0;
    self.counter = 0;
    self.duration = duration;
    
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink {
    self.displayLink.paused = YES;
}

@end

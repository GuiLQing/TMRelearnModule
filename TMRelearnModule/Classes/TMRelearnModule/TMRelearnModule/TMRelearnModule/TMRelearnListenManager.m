//
//  TMRelearnListenManager.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnListenManager.h"
#import <SGTools/SGAudioPlayer.h>
#import <LGAlertHUD/LGAlertHUD.h>

@interface TMRelearnListenManager () <SGAudioPlayerDelegate>

@property (nonatomic, strong) SGAudioPlayer *audioPlayer;

@property (nonatomic, strong) CADisplayLink *answerDisplayLink;

@property (nonatomic, assign) NSInteger currentAnswerTime;
@property (nonatomic, assign) NSInteger answerDuration;
@property (nonatomic, assign) NSInteger answerCounter;

@end

@implementation TMRelearnListenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioPlayer = [[SGAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
        
        _answerDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(answerDisplayLinkAction)];
        [_answerDisplayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
        _answerDisplayLink.paused = YES;
        
    }
    return self;
}

- (void)dealloc {
    [self removeAudioPlayer];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)removeAudioPlayer {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        [self.audioPlayer invalidate];
        self.audioPlayer = nil;
    }
}

/** 开始听写训练 */
- (void)restartDictationTraining {
    _currentTopicIndex = 0;
    _currentPlayCount = 0;
    
    [self enterTrainingAtIndex:_currentTopicIndex];
}

/** 暂停训练 */
- (void)pauseDictationTraining {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatCurrentSectionTraining) object:nil];
    
    if (_dictationMode == TMDictationTrainingModeAnswering) {
        self.answerDisplayLink.paused = YES;
    } else {
        [self.audioPlayer pause];
    }
}

/** 继续训练 */
- (void)continueDictationTraining {
    if (_dictationMode == TMDictationTrainingModeAnswering) {
        self.answerDisplayLink.paused = NO;
    } else {
        [self enterTrainingAtIndex:_currentTopicIndex];
    }
}

/** 重复当前分段训练 */
- (void)repeatCurrentSectionTraining {
    _currentPlayCount ++;
    [self enterTrainingAtIndex:_currentTopicIndex];
}

/** 进入下一分段训练 */
- (void)enterNextSectionTraining {
    /** 重置当前播放次数 */
    _currentPlayCount = 0;
    
    [self enterTrainingAtIndex:++ _currentTopicIndex];
}

/** 跳转到index分段训练 */
- (void)moveToSectionTraining:(NSInteger)index {
    _currentPlayCount = 0;
    _currentTopicIndex = index;
    
    [self enterTrainingAtIndex:index];
}

- (void)enterTrainingAtIndex:(NSInteger)index {
    if (_currentTopicIndex >= _totalTopicCount) {
        [self trainingCompletion];
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeatCurrentSectionTraining) object:nil];
    self.answerDisplayLink.paused = YES;
    
    self.audioPlayer.audioUrl = self.knowledgeDataSource[_currentTopicIndex].usPVoice;
    [self.audioPlayer play];
    
    NSLog(@"%ld...%ld", _currentPlayCount, _currentTopicIndex);
    
    _dictationMode = TMDictationTrainingModeAudioPlaying;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPlayAudioAtIndex:)]) {
        [self.delegate willPlayAudioAtIndex:_currentTopicIndex];
    }
}

/** 开启听写作答倒计时 */
- (void)startDictationAnswerTime {
    self.answerDisplayLink.paused = NO;
    _currentAnswerTime = 0;
    _answerDuration = MAX(6, self.knowledgeDataSource[_currentTopicIndex].cwName.length * 2);
    _answerCounter = 0;
    
    _dictationMode = TMDictationTrainingModeAnswering;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willAnswerCountDownAtIndex:)]) {
        [self.delegate willAnswerCountDownAtIndex:_currentTopicIndex];
    }
}

- (void)answerDisplayLinkAction {
    _answerCounter ++;
    
    if (_answerCounter % 60 == 0) {
        _currentAnswerTime ++;
        if (_currentAnswerTime >= _answerDuration) {
            self.answerDisplayLink.paused = YES;
            if (self.currentTopicIndex < self.totalTopicCount - 1) {
                NSLog(@"下一句");
                [self enterNextSectionTraining];
            } else {
                NSLog(@"提交");
                [self trainingCompletion];
            }
        }
    }
    
    CGFloat countDownProgress = _answerCounter * 1.0 / 60 / _answerDuration;
    CGFloat remaindSeconds = _answerDuration * (1.0 - countDownProgress);
    if (self.delegate && [self.delegate respondsToSelector:@selector(answerCountDownProgress:remaindSeconds:)]) {
        [self.delegate answerCountDownProgress:countDownProgress remaindSeconds:remaindSeconds];
    }
}

- (void)trainingCompletion {
    [self removeAudioPlayer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManagerDidFinishTraining)]) {
        [self.delegate audioManagerDidFinishTraining];
    }
}

#pragma mark - SGAudioPlayerDelegate

/** 音频解码发生错误 */
- (void)audioPlayerDecodeError {
    [LGAlert showErrorWithStatus:@"音频解码失败，进入下一个单词"];
}

- (void)audioPlayerDidPlayFailed {
    [LGAlert showErrorWithStatus:@"音频播放失败，进入下一个单词"];
}

/** 音频播放完成 */
- (void)audioPlayerDidPlayComplete {
    if (self.currentPlayCount < self.totalPlayCount - 1) {
        NSLog(@"重复播放");
        [self performSelector:@selector(repeatCurrentSectionTraining) withObject:nil afterDelay:1.0];
    } else {
        NSLog(@"作答");
        [self startDictationAnswerTime];
    }
}

- (void)audioPlayerCurrentPlaySeconds:(NSTimeInterval)timeSeconds progress:(CGFloat)progress {
    
}

/** 音频播放中断 */
- (void)audioPlayerBeginInterruption {
    [self pauseDictationTraining];
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManagerDidBeginInterruption)]) {
        [self.delegate audioManagerDidBeginInterruption];
    }
}

/** 音频播放结束中断 */
- (void)audioPlayerEndInterruption {
    [self pauseDictationTraining];
}

@end

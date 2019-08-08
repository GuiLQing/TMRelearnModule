//
//  TMRelearnSpeakManager.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnSpeakManager.h"
#import <SGTools/SGSingleAudioPlayer.h>
#import <SGTools/SGSpeechSynthesizerManager.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TMRelearnDisplayLink.h"
#import <YJTaskMark/YJSpeechManager.h>
#import <LGAlertHUD/LGAlertHUD.h>

@interface TMRelearnSpeakManager ()

@property (nonatomic, strong) TMRelearnKnowledgeModel *model;

@property (nonatomic, assign) NSInteger currentPlayCount;

@property (nonatomic, assign) NSInteger totalPlayCount;

@property (nonatomic, strong) SGSingleAudioPlayer *audioPlayer;

@property (nonatomic, strong) TMRelearnDisplayLink *recordDisplayLink;

@property (nonatomic, strong) TMRelearnDisplayLink *resultDisplayLink;

@property (nonatomic, strong) TMRelearnDisplayLink *waitingDisplayLink;

@end

@implementation TMRelearnSpeakManager

+ (instancetype)defaultManager {
    static TMRelearnSpeakManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TMRelearnSpeakManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _totalPlayCount = 2;
        if (!YJSpeechManager.defaultManager.microphoneAuthorization) {
            [YJSpeechManager.defaultManager setMicrophoneAuthorization];
        }
        
        _recordDisplayLink = TMRelearnDisplayLink.alloc.init;
        _resultDisplayLink = TMRelearnDisplayLink.alloc.init;
        _waitingDisplayLink = TMRelearnDisplayLink.alloc.init;
    }
    return self;
}

- (void)updateStudyStatus:(TMWordsStudyStatus)status {
    _studyStatus = status;
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordsStudyStatusDidChanged:)]) {
        [self.delegate wordsStudyStatusDidChanged:status];
    }
}

- (void)stopWordsStudy {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(restartWordsAudioPlay) object:nil];
    [self.audioPlayer invalidate];
    self.audioPlayer = nil;
    [SGSpeechDefaultManager cancelSpeech];
    
    [self.recordDisplayLink stopDisplayLink];
    [YJSpeechManager.defaultManager cancelEngine];
    
    [self.resultDisplayLink stopDisplayLink];
    
    [self.waitingDisplayLink stopDisplayLink];
}

- (void)restartWordsStudyWithWordsModel:(TMRelearnKnowledgeModel *)wordsModel {
    _model = wordsModel;
    
    _currentPlayCount = 0;
    [self restartWordsAudioPlay];
}

- (void)restartWordsAudioPlay {
    [self updateStudyStatus:TMWordsStudyStatusAudio];
    @weakify(self);
    self.audioPlayer = [SGSingleAudioPlayer audioPlayWithUrl:[NSURL URLWithString:[self.model.usPVoice stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] playProgress:nil completionHandle:^(NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [SGSpeechDefaultManager speechWithEnglishText:self.model.cwName completion:^{
                @strongify(self);
                [self audioCompletionHandle];
            }];
        } else {
            [self audioCompletionHandle];
        }
    }];
}

- (void)audioCompletionHandle {
    if (_currentPlayCount < _totalPlayCount - 1) {
        _currentPlayCount ++;
        /** 重复播放 */
        [self performSelector:@selector(restartWordsAudioPlay) withObject:nil afterDelay:1.0f];
    } else {
        self.audioPlayer = nil;
        [self restartRecordDisplayLink];
    }
}

- (void)restartRecordDisplayLink {
    [self updateStudyStatus:TMWordsStudyStatusRecord];
    @weakify(self);
    [YJSpeechManager.defaultManager speechEngineResult:^(YJSpeechResultModel *resultModel) {
        @strongify(self);
        if (resultModel.isError) {
            [LGAlert showErrorWithStatus:resultModel.errorMsg];
        }
        [self.recordDisplayLink stopDisplayLink];
        [self restartResultDisplayLink];
        if (self.delegate && [self.delegate respondsToSelector:@selector(sentenceSpeechEngineResult:)]) {
            [self.delegate sentenceSpeechEngineResult:resultModel.mj_JSONObject];
        }
    }];
    [YJSpeechManager.defaultManager startEngineAtRefText:self.model.cwName markType:YJSpeechMarkTypeParagraph];
    
    self.recordDisplayLink.completeCallback = ^(void) {
        @strongify(self);
        [self updateStudyStatus:TMWordsStudyStatusSpeech];
        [YJSpeechManager.defaultManager stopEngine];
    };
    self.recordDisplayLink.remaindTimeIntervalCallback = ^(NSTimeInterval timeInterval) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordRemaindSeconds:)]) {
            [self.delegate recordRemaindSeconds:timeInterval];
        }
    };
    [self.recordDisplayLink restartDisplayLinkWithDuration:3];
}

- (void)restartResultDisplayLink {
    [self updateStudyStatus:TMWordsStudyStatusResult];
    @weakify(self);
    self.resultDisplayLink.completeCallback = ^(void) {
        @strongify(self);
        [self restartWaitingDisplayLink];
    };
    [self.resultDisplayLink restartDisplayLinkWithDuration:3];
}

- (void)restartWaitingDisplayLink {
    [self updateStudyStatus:TMWordsStudyStatusWaiting];
    @weakify(self);
    self.waitingDisplayLink.completeCallback = ^(void) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(wordsStudyDidCompletion)]) {
            [self.delegate wordsStudyDidCompletion];
        }
    };
    [self.waitingDisplayLink restartDisplayLinkWithDuration:1];
}

@end

//
//  TMRelearnSpeakManager.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMWordsStudyStatus) {
    TMWordsStudyStatusDefault,
    TMWordsStudyStatusAudio,
    TMWordsStudyStatusRecord,
    TMWordsStudyStatusSpeech,
    TMWordsStudyStatusResult,
    TMWordsStudyStatusWaiting,
};

@protocol TMRelearnSpeakManagerDelegate <NSObject>

@optional

/** 学习状态改变 */
- (void)wordsStudyStatusDidChanged:(TMWordsStudyStatus)status;
/** 语音评测结果回调 */
- (void)sentenceSpeechEngineResult:(NSDictionary *)result;
/** 跟读录音倒计时 */
- (void)recordRemaindSeconds:(NSTimeInterval)remainSeconds;
/** 完成回调 */
- (void)wordsStudyDidCompletion;

@end

@interface TMRelearnSpeakManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, weak) id<TMRelearnSpeakManagerDelegate> delegate;

@property (nonatomic, assign) TMWordsStudyStatus studyStatus;

- (void)restartWordsStudyWithWordsModel:(TMRelearnKnowledgeModel *)wordsModel;

- (void)stopWordsStudy;

@end

NS_ASSUME_NONNULL_END

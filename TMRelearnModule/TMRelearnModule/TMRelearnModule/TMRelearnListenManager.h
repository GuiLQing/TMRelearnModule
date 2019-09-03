//
//  TMRelearnListenManager.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMDictationTrainingMode) {
    TMDictationTrainingModeDefault,
    TMDictationTrainingModeAudioPlaying,
    TMDictationTrainingModeAnswering,
};

@protocol TMRelearnListenManagerDelegate <NSObject>

/** 训练中断 */
- (void)audioManagerDidBeginInterruption;
/** 将要播放某一段音频 */
- (void)willPlayAudioAtIndex:(NSInteger)index;
/** 将要开始某一段作答计时 */
- (void)willAnswerCountDownAtIndex:(NSInteger)index;
/** 完成训练 */
- (void)audioManagerDidFinishTraining;
/** 音频播放总进度 */
- (void)audioPlayProgress:(CGFloat)progress;
/** 作答倒计时进度 */
- (void)answerCountDownProgress:(CGFloat)countDownProgress remaindSeconds:(NSTimeInterval)remainSeconds;

@end

@interface TMRelearnListenManager : NSObject

/** 播放次数 */
@property (nonatomic, assign) NSInteger totalPlayCount;
/** 总分段数 */
@property (nonatomic, assign) NSInteger totalTopicCount;
/** 当前播放次数 */
@property (nonatomic, assign, readonly) NSInteger currentPlayCount;
/** 当前题目下标 */
@property (nonatomic, assign, readonly) NSInteger currentTopicIndex;

@property (nonatomic, weak) id<TMRelearnListenManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *knowledgeDataSource;

@property (nonatomic, assign, readonly) TMDictationTrainingMode dictationMode;

/** 开始听写训练 */
- (void)restartDictationTraining;
/** 进入下一分段训练 */
- (void)enterNextSectionTraining;
/** 跳转到index分段训练 */
- (void)moveToSectionTraining:(NSInteger)index;
/** 暂停训练 */
- (void)pauseDictationTraining;
/** 继续训练 */
- (void)continueDictationTraining;
/** 移出音频播放器 */
- (void)removeAudioPlayer;

@end

NS_ASSUME_NONNULL_END

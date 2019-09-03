//
//  TMRelearnListenCountDownView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMDictationCountDownMode) {
    TMDictationCountDownModeDefault,
    TMDictationCountDownModeAudio,
    TMDictationCountDownModeAnswer,
};

@interface TMRelearnListenCountDownView : UIView

@property (nonatomic, assign) TMDictationCountDownMode countDownMode;

- (void)updateAudioProgress:(CGFloat)progress;

- (void)updateAnswerProgress:(CGFloat)progress remaindSeconds:(NSTimeInterval)remaindSeconds;

@end

NS_ASSUME_NONNULL_END

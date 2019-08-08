//
//  TMRelearnListenCountDownView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnListenCountDownView.h"
#import <SGTools/SGGradientProgress.h>
#import "TMRelearnMacros.h"
#import "UIImage+TMResource.h"

@interface TMRelearnListenCountDownView ()

@property (nonatomic, strong) UIImageView *audioProgressIV;
@property (nonatomic, strong) SGGradientProgress *audioProgressView;

@property (nonatomic, strong) SGGradientProgress *answerProgressBackView;
@property (nonatomic, strong) SGGradientProgress *answerProgressView;
@property (nonatomic, strong) UILabel *secondsLabel;

@end

@implementation TMRelearnListenCountDownView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect){CGPointZero, CGSizeMake(70.0f, 70.0f)};
        
        [self layoutUI];
        
        self.countDownMode = TMDictationCountDownModeDefault;
    }
    return self;
}

- (void)layoutUI {
    self.audioProgressIV = UIImageView.alloc.init;
    self.audioProgressIV.frame = (CGRect){self.audioProgressIV.frame.origin, CGSizeMake(CGRectGetWidth(self.frame) + 20.0f, CGRectGetHeight(self.frame) + 20.0f)};
    self.audioProgressIV.center = self.center;
    self.audioProgressIV.image = [UIImage tm_imageNamed:@"tm_dictation_icon_play_default"];
    self.audioProgressIV.animationImages = @[
                                             [UIImage tm_imageNamed:@"tm_dictation_icon_playGif_1"],
                                             [UIImage tm_imageNamed:@"tm_dictation_icon_playGif_2"],
                                             [UIImage tm_imageNamed:@"tm_dictation_icon_playGif_3"],
                                             ];
    self.audioProgressIV.animationDuration = 0.5;
    [self addSubview:self.audioProgressIV];
    
    [self addSubview:self.audioProgressView];
    
    [self addSubview:self.answerProgressBackView];
    
    [self addSubview:self.answerProgressView];
    
    [self addSubview:self.secondsLabel];
}

- (void)setCountDownMode:(TMDictationCountDownMode)countDownMode {
    _countDownMode = countDownMode;
    
    self.audioProgressIV.hidden = YES;
    self.audioProgressView.hidden = YES;
    self.answerProgressBackView.hidden = YES;
    self.answerProgressView.hidden = YES;
    self.secondsLabel.hidden = YES;
    [self.audioProgressIV stopAnimating];
    
    switch (countDownMode) {
            case TMDictationCountDownModeDefault: {
                self.audioProgressIV.hidden = NO;
            }
            break;
            case TMDictationCountDownModeAudio: {
                self.audioProgressIV.hidden = NO;
                self.audioProgressView.hidden = NO;
                [self.audioProgressIV startAnimating];
            }
            break;
            case TMDictationCountDownModeAnswer: {
                self.answerProgressBackView.hidden = NO;
                self.answerProgressView.hidden = NO;
                self.secondsLabel.hidden = NO;
            }
            break;
    }
}

- (void)updateAudioProgress:(CGFloat)progress {
    self.audioProgressView.progress = progress;
}

- (void)updateAnswerProgress:(CGFloat)progress remaindSeconds:(NSTimeInterval)remaindSeconds {
    self.answerProgressView.progress = progress;
    self.secondsLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)remaindSeconds];
}

#pragma mark - lazyLoading

- (SGGradientProgress *)audioProgressView {
    if (!_audioProgressView) {
        _audioProgressView = [[SGGradientProgress alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) startColor:TM_HexColor(0x0a8fa) endColor:TM_HexColor(0x0a8fa) startAngle:-90 reduceAngle:0 strokeWidth:2.0];
        _audioProgressView.notAnimated = YES;
        _audioProgressView.colorGradient = NO;
        _audioProgressView.backgroundColor = UIColor.clearColor;
        _audioProgressView.showProgressText = NO;
    }
    return _audioProgressView;
}

- (SGGradientProgress *)answerProgressView {
    if (!_answerProgressView) {
        _answerProgressView = [[SGGradientProgress alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) startColor:TM_HexColor(0xf5f7f9) endColor:TM_HexColor(0xf5f7f9) startAngle:-90 reduceAngle:0 strokeWidth:2.0];
        _answerProgressView.notAnimated = YES;
        _answerProgressView.colorGradient = NO;
        _answerProgressView.backgroundColor = UIColor.clearColor;
        _answerProgressView.showProgressText = NO;
    }
    return _answerProgressView;
}

- (SGGradientProgress *)answerProgressBackView {
    if (!_answerProgressBackView) {
        _answerProgressBackView = [[SGGradientProgress alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) startColor:TM_HexColor(0x0c2f6) endColor:TM_HexColor(0x0e5cc) startAngle:-90 reduceAngle:0 strokeWidth:2.0];
        _answerProgressBackView.progress = 1;
        _answerProgressBackView.notAnimated = YES;
        _answerProgressBackView.showProgressText = NO;
    }
    return _answerProgressBackView;
}

- (UILabel *)secondsLabel {
    if (!_secondsLabel) {
        _secondsLabel = UILabel.alloc.init;
        _secondsLabel.frame = self.bounds;
        _secondsLabel.textColor = TM_HexColor(0x0c2f6);
        _secondsLabel.font = [UIFont systemFontOfSize:30];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondsLabel;
}

@end

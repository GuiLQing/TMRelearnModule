//
//  TMRelearnListenCell.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnListenCell.h"
#import <SGTools/SGVocabularyDictationView.h>
#import <Masonry/Masonry.h>
#import "TMRelearnListenCountDownView.h"
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TMRelearnListenCell ()

@property (nonatomic, strong) TMRelearnListenCountDownView *countDownView;

@property (nonatomic, strong) SGVocabularyDictationView *dictationView;

@end

@implementation TMRelearnListenCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    TMRelearnListenCountDownView *countDownView = [[TMRelearnListenCountDownView alloc] init];
    self.countDownView = countDownView;
    [self.contentView addSubview:countDownView];
    [countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(countDownView.frame.size);
        make.top.equalTo(self.contentView.mas_top).offset(50.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    SGVocabularyDictationView *dictationView = [[SGVocabularyDictationView alloc] initWithFrame:CGRectMake(40.0f, 120.0f, UIScreen.mainScreen.bounds.size.width - 80.0f, 0)];
    self.dictationView = dictationView;
    dictationView.viewType = SGDictationViewTypeAnswer;
    dictationView.vocabulary = @" ";
    [self.contentView addSubview:dictationView];
    [dictationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countDownView.mas_bottom).offset(20.0f);
        make.left.equalTo(self.contentView).offset(40.0f);
        make.right.equalTo(self.contentView).offset(-40.0f);
    }];
    
    @weakify(self);
    dictationView.sg_dictationEnsureDidClicked = ^{
        @strongify(self);
        if (self.ensureDidClicked) {
            self.ensureDidClicked();
        }
    };
    
    dictationView.sg_dictationSpellAnswerCallback = ^(NSString * _Nonnull answer) {
        @strongify(self);
        NSString *rightAnswer = [self.model.cwName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *stuAnswer = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
        BOOL isSame = [rightAnswer caseInsensitiveCompare:stuAnswer] == NSOrderedSame;
        self.model.stuAnswer = stuAnswer;
        self.model.score = isSame ? 100 : 0;
    };
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countDownTap)];
    [self.countDownView addGestureRecognizer:tapGR];
}

- (void)setModel:(TMRelearnKnowledgeModel *)model {
    _model = model;
    self.dictationView.vocabulary = TM_IsStrEmpty(model.cwName) ? @" " : model.cwName;
}

- (void)updateCountDownViewProgress:(CGFloat)progress {
    self.countDownView.countDownMode = TMDictationCountDownModeAudio;
    [self.countDownView updateAudioProgress:progress];
}

- (void)resetCountDownView {
    self.countDownView.countDownMode = TMDictationCountDownModeDefault;
}

- (void)countDownTap {
    if (self.countDownDidClicked) {
        self.countDownDidClicked();
    }
}

@end

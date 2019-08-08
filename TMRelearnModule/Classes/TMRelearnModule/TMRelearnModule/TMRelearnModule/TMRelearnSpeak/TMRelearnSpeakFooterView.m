//
//  TMRelearnSpeakFooterView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnSpeakFooterView.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import "UIImage+TMResource.h"

@interface TMRelearnSpeakFooterView ()

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *paraphraseButton;

@end

@implementation TMRelearnSpeakFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    UIImageView *bgIV = UIImageView.alloc.init;
    bgIV.image = [UIImage tm_imageNamed:@"tm_icon_speak_bg"];
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.playButton = UIButton.alloc.init;
    [self.playButton setImage:[UIImage tm_imageNamed:@"tm_icon_speak_play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage tm_imageNamed:@"tm_icon_speak_pause"] forState:UIControlStateSelected];
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.paraphraseButton = UIButton.alloc.init;
    [self.paraphraseButton setTitle:@"听释义" forState:UIControlStateNormal];
    [self.paraphraseButton setTitleColor:TM_HexColor(0x0078b1) forState:UIControlStateNormal];
    [self.paraphraseButton setTitleColor:TM_HexColor(0x77c8df) forState:UIControlStateDisabled];
    [self addSubview:self.paraphraseButton];
    [self.paraphraseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(150.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.playButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.paraphraseButton addTarget:self action:@selector(paraphraseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.paraphraseButton.enabled = NO;
}

- (void (^)(BOOL))updateStartButtonSelected {
    return ^(BOOL isStarted) {
        self.playButton.selected = isStarted;
    };
}

- (void (^)(BOOL))updateStartButtonDisabled {
    return ^(BOOL isDisbaled) {
        self.playButton.selected = NO;
        self.playButton.enabled = !isDisbaled;
    };
}

- (void (^)(BOOL))updateParaphraseButtonDisabled {
    return ^(BOOL isDisbaled) {
        self.paraphraseButton.enabled = !isDisbaled;
    };
}

#pragma mark - Action

- (void)startAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(startButtonDidClicked:)]) {
        [self.delegate startButtonDidClicked:sender.selected];
    }
}

- (void)paraphraseAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(paraphraseButtonDidClicked)]) {
        [self.delegate paraphraseButtonDidClicked];
    }
}

@end

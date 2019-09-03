//
//  TMRelearnWordsListFooterView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnWordsListFooterView.h"
#import "TMRelearnMacros.h"
#import <Masonry/Masonry.h>

@interface TMRelearnWordsListFooterView ()

@end

@implementation TMRelearnWordsListFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        UIButton *speakButton = UIButton.alloc.init;
        speakButton.tag = TMRelearnWordsListFooterItemTypeSpeak;
        [speakButton setTitle:@"朗读" forState:UIControlStateNormal];
        [speakButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
        [self addSubview:speakButton];
        [speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
        }];
        
        UIButton *listenButton = UIButton.alloc.init;
        listenButton.tag = TMRelearnWordsListFooterItemTypeListen;
        [listenButton setTitle:@"听写" forState:UIControlStateNormal];
        [listenButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
        [self addSubview:listenButton];
        [listenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(speakButton.mas_right);
            make.width.equalTo(speakButton.mas_width);
            make.top.bottom.equalTo(self);
        }];
        
        UIButton *testButton = UIButton.alloc.init;
        testButton.tag = TMRelearnWordsListFooterItemTypeTest;
        [testButton setTitle:@"练习" forState:UIControlStateNormal];
        [testButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
        [self addSubview:testButton];
        [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(listenButton.mas_right);
            make.width.equalTo(listenButton.mas_width);
            make.top.bottom.right.equalTo(self);
        }];
        
        UIView *speakRightLine = UIView.alloc.init;
        speakRightLine.backgroundColor = UIColor.lightGrayColor;
        [speakButton addSubview:speakRightLine];
        [speakRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.5f);
            make.right.equalTo(speakButton.mas_right);
            make.top.equalTo(speakButton.mas_top).offset(10.0f);
            make.bottom.equalTo(speakButton.mas_bottom).offset(-10.0f);
        }];
        
        UIView *listenRightLine = UIView.alloc.init;
        listenRightLine.backgroundColor = UIColor.lightGrayColor;
        [listenButton addSubview:listenRightLine];
        [listenRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.5f);
            make.right.equalTo(listenButton.mas_right);
            make.top.equalTo(listenButton.mas_top).offset(10.0f);
            make.bottom.equalTo(listenButton.mas_bottom).offset(-10.0f);
        }];
        
        [speakButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [listenButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [testButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerItemDidClickedAtIndex:)]) {
        [self.delegate footerItemDidClickedAtIndex:sender.tag];
    }
}

@end

//
//  TMRelearnListenFooterView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnListenFooterView.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"

@interface TMRelearnListenFooterView ()

@end

@implementation TMRelearnListenFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        UIButton *speakButton = UIButton.alloc.init;
        speakButton.tag = TMRelearnListenFooterItemTypeLast;
        [speakButton setTitle:@"上一个" forState:UIControlStateNormal];
        [speakButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
        [self addSubview:speakButton];
        [speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
        }];
        
        UIButton *listenButton = UIButton.alloc.init;
        listenButton.tag = TMRelearnListenFooterItemTypeNext;
        [listenButton setTitle:@"下一个" forState:UIControlStateNormal];
        [listenButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
        [self addSubview:listenButton];
        [listenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(speakButton.mas_right);
            make.width.equalTo(speakButton.mas_width);
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
        
        [speakButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [listenButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerItemDidClickedAtIndex:)]) {
        [self.delegate footerItemDidClickedAtIndex:sender.tag];
    }
}

@end

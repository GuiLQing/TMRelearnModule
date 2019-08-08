//
//  TMRelearnResultDetailFooterView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnResultDetailFooterView.h"
#import "PSG_ChainFunction.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIImage+TMResource.h"

@implementation TMRelearnResultDetailFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.g_size(CGSizeMake(TM_SCREEN_WIDTH, 70.0f));
        self.layer
        .g_shadowOffset(CGSizeMake(0, -20))
        .g_shadowColor(UIColor.whiteColor.CGColor)
        .g_shadowOpacity(0.7);
        
        CGSize buttonSize = CGSizeMake(130.0f, 40.0f);
        
        @weakify(self);
        UIButton *exitButton = UIButton.g_init
        .g_titleColor(TM_HexColor(0x0baffb), UIControlStateNormal)
        .g_title(@"退出训练", UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"et_result_icon_left_button"], UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"et_result_icon_left_button"], UIControlStateHighlighted)
        .g_subscribeNext(UIControlEventTouchUpInside, ^(UIButton *button) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(exitButtonDidClicked)]) {
                [self.delegate exitButtonDidClicked];
            }
        });
        exitButton.g_size(buttonSize)
        .g_setPositionAtAnchorPoint(CGPointMake(TM_SCREEN_WIDTH / 2 - 10.0f, CGRectGetHeight(self.frame) - 25.0f), CGPointMake(1, 1));
        [self addSubview:exitButton];
        exitButton.layer.cornerRadius = 20.0;
        exitButton.layer.masksToBounds = YES;
        
        UIButton *reTrainingButton = UIButton.g_init
        .g_titleColor(UIColor.whiteColor, UIControlStateNormal)
        .g_title(@"重新训练", UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"et_result_icon_right_button"], UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"et_result_icon_right_button"], UIControlStateHighlighted)
        .g_subscribeNext(UIControlEventTouchUpInside, ^(UIButton *button) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(reTrainingButtonDidClicked)]) {
                [self.delegate reTrainingButtonDidClicked];
            }
        });
        reTrainingButton.g_size(buttonSize)
        .g_setPositionAtAnchorPoint(CGPointMake(TM_SCREEN_WIDTH / 2 + 10.0f, CGRectGetHeight(self.frame) - 25.0f), CGPointMake(0, 1));
        [self addSubview:reTrainingButton];
        reTrainingButton.layer.cornerRadius = 20.0;
        reTrainingButton.layer.masksToBounds = YES;
    }
    return self;
}

@end

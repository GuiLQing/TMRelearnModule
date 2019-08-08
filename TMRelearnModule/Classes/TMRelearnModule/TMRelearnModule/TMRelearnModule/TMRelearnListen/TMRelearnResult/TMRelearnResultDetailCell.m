//
//  TMRelearnResultDetailCell.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnResultDetailCell.h"
#import "PSG_ChainFunction.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TMRelearnResultDetailCell ()

@property (nonatomic, strong) UILabel *standardAnswerLabel;
@property (nonatomic, strong) UILabel *stuAnswerLabel;

@end

@implementation TMRelearnResultDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.g_size(CGSizeMake(TM_SCREEN_WIDTH, ETLTVocabularyResultCellHeight));
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    CGFloat backViewWidth = (TM_SCREEN_WIDTH - 12 * 2) / 2;
    
    UIView *backView = UIView.alloc.init;
    backView.layer.cornerRadius = 4.0f;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = TM_HexColor(0xf5f7f9).CGColor;
    backView.layer.borderWidth = 0.5;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
        make.left.equalTo(self.contentView.mas_left).offset(12.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
    }];
    
    UIView *standardBackView = UIView.g_init
    .g_backgroundColor(UIColor.whiteColor);
    [backView addSubview:standardBackView];
    [standardBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(backView.mas_bottom);
        make.left.equalTo(backView.mas_left);
        make.width.mas_equalTo(backViewWidth);
    }];
    
    UIView *stuAnswerBackView = UIView.g_init
    .g_backgroundColor(TM_HexColor(0xf5f7f9));
    [backView addSubview:stuAnswerBackView];
    [stuAnswerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(backView.mas_bottom);
        make.right.equalTo(backView.mas_right);
        make.width.mas_equalTo(backViewWidth);
    }];
    
    self.standardAnswerLabel = UILabel.g_init
    .g_text(@"")
    .g_font([UIFont systemFontOfSize:15.0])
    .g_textColor(TM_HexColor(0x111111))
    .g_lineBreakMode(NSLineBreakByTruncatingTail)
    .g_numberOfLines(1);
    [standardBackView addSubview:self.standardAnswerLabel];
    [self.standardAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(standardBackView);
        make.left.equalTo(standardBackView.mas_left).offset(10.0f);
        make.right.equalTo(standardBackView.mas_right).offset(-10.0f);
    }];
    
    self.stuAnswerLabel = UILabel.g_init
    .g_text(@"")
    .g_font([UIFont systemFontOfSize:15.0])
    .g_textColor(TM_HexColor(0x25c97c))
    .g_lineBreakMode(NSLineBreakByTruncatingTail)
    .g_numberOfLines(1);
    [stuAnswerBackView addSubview:self.stuAnswerLabel];
    [self.stuAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(stuAnswerBackView);
        make.left.equalTo(stuAnswerBackView.mas_left).offset(10.0f);
        make.right.equalTo(stuAnswerBackView.mas_right).offset(-10.0f);
    }];
    
}

- (void)setModel:(TMRelearnKnowledgeModel *)model {
    _model = model;
    
    BOOL isRight = model.score >= 60;
    
    self.standardAnswerLabel.text = model.cwName;
    self.stuAnswerLabel.text = TM_IsStrEmpty(model.stuAnswer) ? @"未作答" : model.stuAnswer;
    
    self.stuAnswerLabel.textColor = isRight ? TM_HexColor(0x25c97c) : TM_HexColor(0xfb4e4e);
}

@end

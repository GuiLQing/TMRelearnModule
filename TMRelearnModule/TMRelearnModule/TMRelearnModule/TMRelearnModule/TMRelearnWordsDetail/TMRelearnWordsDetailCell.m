//
//  TMRelearnWordsDetailCell.m
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnWordsDetailCell.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import "UIImage+TMResource.h"

@interface TMRelearnWordsDetailCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *voiceButton;

@end

@implementation TMRelearnWordsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    UILabel *tipsLabel = UILabel.alloc.init;
    tipsLabel.text = @"例句";
    tipsLabel.textColor = UIColor.lightGrayColor;
    tipsLabel.font = [UIFont systemFontOfSize:13.0f];
    tipsLabel.numberOfLines = 1;
    tipsLabel.backgroundColor = TM_HexColor(0xf5f7f9);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [tipsLabel sizeToFit];
    [self.contentView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(tipsLabel.bounds) + 8.0f, CGRectGetHeight(tipsLabel.bounds) + 4.0f));
        make.left.equalTo(self.contentView.mas_left).offset(12.0f);
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
    }];
    
    self.voiceButton = UIButton.alloc.init;
    [self.voiceButton setImage:[UIImage tm_imageNamed:@"tm_words_icon_voice_play_4"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage tm_imageNamed:@"tm_words_icon_voice_play_4"] forState:UIControlStateHighlighted];
    self.voiceButton.imageView.animationImages = @[
                                                   [UIImage tm_imageNamed:@"tm_words_icon_voice_play_1"],
                                                   [UIImage tm_imageNamed:@"tm_words_icon_voice_play_2"],
                                                   [UIImage tm_imageNamed:@"tm_words_icon_voice_play_3"],
                                                   [UIImage tm_imageNamed:@"tm_words_icon_voice_play_4"]
                                                   ];
    self.voiceButton.imageView.animationDuration = 0.5;
    [self.voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.voiceButton];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(tipsLabel.mas_centerY);
    }];
    
    UILabel *contentLabel = UILabel.alloc.init;
    self.contentLabel = contentLabel;
    contentLabel.textColor = TM_HexColor(0x111111);
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(tipsLabel.mas_height);
        make.left.equalTo(tipsLabel.mas_right).offset(10.0f);
        make.top.equalTo(tipsLabel.mas_top);
        make.right.equalTo(self.voiceButton.mas_left).offset(-10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
    }];
}

- (void)voiceAction:(UIButton *)sender {
    if (self.voiceItemDidClicked) {
        self.voiceItemDidClicked(self.indexPath);
    }
}

- (void)setIsVoiceAnimating:(BOOL)isVoiceAnimating {
    _isVoiceAnimating = isVoiceAnimating;
    if (isVoiceAnimating) {
        [self.voiceButton.imageView startAnimating];
    } else {
        [self.voiceButton.imageView stopAnimating];
    }
}

- (void)setSentenceModel:(TMRelearnKnowledgeExampleSentenceModel *)sentenceModel {
    _sentenceModel = sentenceModel;
    
    NSString *content = [NSString stringWithFormat:@"%@<br>%@", sentenceModel.sentenceEn, sentenceModel.sTranslation];
    self.contentLabel.attributedText = self.sentenceAttributedText(content);
}

- (NSAttributedString * (^)(NSString *sentence))sentenceAttributedText {
    return ^(NSString *sentence) {
        sentence = [sentence stringByReplacingOccurrencesOfString:@"<STRONG>" withString:@"<font style=\"color:#ff6600\">"];
        sentence = [sentence stringByReplacingOccurrencesOfString:@"</STRONG>" withString:@"</font>"];
        
        //转换参数
        NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
        //将html文本转换为正常格式的文本
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithData:[sentence dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, attributedText.string.length)];
        NSMutableParagraphStyle *style = NSMutableParagraphStyle.alloc.init;
        style.lineSpacing = 5.0f;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
        return attributedText;
    };
}

@end

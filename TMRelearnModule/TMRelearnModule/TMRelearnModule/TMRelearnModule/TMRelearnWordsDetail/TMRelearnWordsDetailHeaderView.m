//
//  TMRelearnWordsDetailHeaderView.m
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/7.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnWordsDetailHeaderView.h"
#import "TMRelearnMacros.h"
#import <Masonry/Masonry.h>
#import <MarqueeLabel/MarqueeLabel.h>
#import "UIImage+TMResource.h"

@interface APWordsDetailVoiceItem : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) void (^voiceItemDidClicked)(void);

- (instancetype)initWithText:(NSString *)text;

@end

@implementation APWordsDetailVoiceItem

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = (CGRect){CGPointZero, CGSizeMake(20.0f, 20.0f)};
        self.imageView.image = [UIImage tm_imageNamed:@"tm_words_icon_voice_play_3"];
        self.imageView.animationImages = @[
                                           [UIImage tm_imageNamed:@"tm_words_icon_voice_play_1"],
                                           [UIImage tm_imageNamed:@"tm_words_icon_voice_play_2"],
                                           [UIImage tm_imageNamed:@"tm_words_icon_voice_play_3"],
                                           [UIImage tm_imageNamed:@"tm_words_icon_voice_play_4"]
                                           ];
        self.imageView.animationDuration = 0.5;
        [self addSubview:self.imageView];
        
        self.textLabel = UILabel.alloc.init;
        self.textLabel.text = text;
        self.textLabel.textColor = UIColor.lightGrayColor;
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        [self addSubview:self.textLabel];
        
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 40.0f * 2 - 20.0f - 50.0f, MAXFLOAT)];
        self.textLabel.frame = (CGRect){self.textLabel.frame.origin, textLabelSize};
        self.frame = (CGRect){self.frame.origin, CGSizeMake(CGRectGetWidth(self.imageView.frame) + CGRectGetWidth(self.textLabel.frame), MAX(CGRectGetHeight(self.imageView.frame), CGRectGetHeight(self.textLabel.frame)))};
        self.imageView.center = self.center;
        self.textLabel.center = self.center;
        self.imageView.frame = (CGRect){CGPointMake(0, CGRectGetMinY(self.imageView.frame)), self.imageView.frame.size};
        self.textLabel.frame = (CGRect){CGPointMake(CGRectGetMaxX(self.imageView.frame), CGRectGetMinY(self.textLabel.frame)), self.textLabel.frame.size};
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    if (self.voiceItemDidClicked) {
        self.voiceItemDidClicked();
    }
}

@end

@interface TMRelearnWordsDetailHeaderView ()

@property (nonatomic, strong) MarqueeLabel *titleLabel;

@property (nonatomic, strong) TMRelearnKnowledgeModel *wordsModel;

@property (nonatomic, strong) APWordsDetailVoiceItem *unVoiceItem;

@property (nonatomic, strong) APWordsDetailVoiceItem *usVoiceItem;

@end

@implementation TMRelearnWordsDetailHeaderView

- (instancetype)initWithWordsModel:(TMRelearnKnowledgeModel *)wordsModel
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        _wordsModel = wordsModel;
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.titleLabel.text = self.wordsModel.cwName;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12.0f);
        make.right.equalTo(self.mas_right).offset(-12.0f);
        make.top.equalTo(self.mas_top).offset(10.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self layoutIfNeeded];
    APWordsDetailVoiceItem *unVoiceItem = [[APWordsDetailVoiceItem alloc] initWithText:[NSString stringWithFormat:@"英 %@", self.htmlStringToAttributedString(self.wordsModel.unPText).string]];
    self.unVoiceItem = unVoiceItem;
    [self addSubview:unVoiceItem];
    
    APWordsDetailVoiceItem *usVoiceItem = [[APWordsDetailVoiceItem alloc] initWithText:[NSString stringWithFormat:@"美 %@", self.htmlStringToAttributedString(self.wordsModel.usPText).string]];
    self.usVoiceItem = usVoiceItem;
    [self addSubview:usVoiceItem];
    
    unVoiceItem.frame = (CGRect){CGPointMake(12.0f, CGRectGetMaxY(self.titleLabel.frame) + 10.0f), unVoiceItem.frame.size};
    usVoiceItem.frame = (CGRect){CGRectGetMaxX(unVoiceItem.frame) + 40.0f, CGRectGetMinY(unVoiceItem.frame), usVoiceItem.frame.size};
    if (CGRectGetMaxX(usVoiceItem.frame) > UIScreen.mainScreen.bounds.size.width - 12.0f) {
        usVoiceItem.frame = (CGRect){CGPointMake(CGRectGetMinX(unVoiceItem.frame), CGRectGetMaxY(unVoiceItem.frame) + 10.0f), usVoiceItem.frame.size};
    }
    
    NSMutableString *contentText = [@"" mutableCopy];
    NSString *wordsTypeText = @"";
    for (TMRelearnKnowledgeParaphraseModel *paraphraseModel in self.wordsModel.cxCollection) {
        if (TM_IsStrEmpty(wordsTypeText)) wordsTypeText = paraphraseModel.cxEnglish;
        for (TMRelearnKnowledgeDetailParaphraseModel *detailModel in paraphraseModel.meanCollection) {
            [contentText appendString:self.htmlStringToAttributedString(detailModel.chineseMeaning).string];
        }
    }
    
    UILabel *wordsTypeLabel = UILabel.alloc.init;
    wordsTypeLabel.text = wordsTypeText;
    wordsTypeLabel.hidden = TM_IsStrEmpty(wordsTypeText);
    wordsTypeLabel.font = [UIFont systemFontOfSize:14.0];
    wordsTypeLabel.textColor = TM_HexColor(0x666666);
    [wordsTypeLabel sizeToFit];
    CGFloat wordsTypeLabelWidth = wordsTypeLabel.hidden ? 0 : CGRectGetWidth(wordsTypeLabel.frame) + 10.0f;
    wordsTypeLabel.frame = (CGRect){CGPointMake(12.0f, CGRectGetMaxY(usVoiceItem.frame) + 20.0f), CGSizeMake(wordsTypeLabelWidth, CGRectGetHeight(wordsTypeLabel.frame))};
    [self addSubview:wordsTypeLabel];
    
    UILabel *contentLabel = UILabel.alloc.init;
    contentLabel.text = contentText;
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    contentLabel.textColor = TM_HexColor(0x111111);
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(15.0f);
        make.top.equalTo(wordsTypeLabel.mas_top);
        make.left.equalTo(wordsTypeLabel.mas_right);
        make.right.equalTo(self.mas_right).offset(-12.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-20.0f);
    }];
    
    UIView *bottomLineView = UIView.alloc.init;
    bottomLineView.backgroundColor = TM_HexColor(0xf5f7f9);
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10.0f);
        make.left.bottom.right.equalTo(self);
    }];
    
    __weak typeof(self) weakSelf = self;
    unVoiceItem.voiceItemDidClicked = ^{
        if (weakSelf.unVoiceItemDidClicked) weakSelf.unVoiceItemDidClicked(weakSelf.wordsModel.unPVoice);
    };
    usVoiceItem.voiceItemDidClicked = ^{
        if (weakSelf.usVoiceItemDidClicked) weakSelf.usVoiceItemDidClicked(weakSelf.wordsModel.usPVoice);
    };
    
    [self layoutIfNeeded];
}

- (NSAttributedString * (^)(NSString *))htmlStringToAttributedString {
    return ^(NSString *string) {
        //转换参数
        NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
        //将html文本转换为正常格式的文本
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, attStr.string.length)];
        return attStr;
    };
}

- (void)updateUnVoiceAnimation:(BOOL)isAnimation {
    if (isAnimation) {
        [self.unVoiceItem.imageView startAnimating];
    } else {
        [self.unVoiceItem.imageView stopAnimating];
    }
}

- (void)updateUsVoiceAnimation:(BOOL)isAnimation {
    if (isAnimation) {
        [self.usVoiceItem.imageView startAnimating];
    } else {
        [self.usVoiceItem.imageView stopAnimating];
    }
}

#pragma mark - lazyloading

- (MarqueeLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectZero rate:10 andFadeLength:5];
        _titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        _titleLabel.textColor = TM_HexColor(0x111111);
        _titleLabel.marqueeType = MLContinuous;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
}

@end

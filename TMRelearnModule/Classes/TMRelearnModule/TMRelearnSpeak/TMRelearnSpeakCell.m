//
//  TMRelearnSpeakCell.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnSpeakCell.h"
#import <objc/runtime.h>
#import <MarqueeLabel/MarqueeLabel.h>
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface UIView (TMGradient)

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation UIView (TMGradient)

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer {
    objc_setAssociatedObject(self, &@selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)gradientLayer {
    return objc_getAssociatedObject(self, &@selector(gradientLayer));
}

- (void)tm_setGradientWithColors:(NSArray<UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    void (^tm_setGradient)(CAGradientLayer *layer) = ^(CAGradientLayer *layer) {
        [self layoutIfNeeded];
        NSMutableArray *colorArray = [NSMutableArray array];
        for (UIColor *color in colors) {
            [colorArray addObject:(id)color.CGColor];
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer.frame = self.bounds;
        [CATransaction commit];
        
        layer.colors = colorArray;
        layer.startPoint = startPoint;
        layer.endPoint = endPoint;
    };
    
    if (self.gradientLayer) {
        tm_setGradient(self.gradientLayer);
    } else {
        self.gradientLayer = CAGradientLayer.layer;
        tm_setGradient(self.gradientLayer);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
}

@end

@interface TMRelearnSpeakCell ()

@property (nonatomic, strong) MarqueeLabel *titleLabel;

@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, strong) UIView *horizontalLine;

@end

@implementation TMRelearnSpeakCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    self.horizontalLine = UIView.alloc.init;
    [self.contentView addSubview:self.horizontalLine];
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.0f);
    }];
    
    self.verticalLine = UIView.alloc.init;
    [self.contentView addSubview:self.verticalLine];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(1.0f);
    }];
    
    @weakify(self);
    [[RACObserve(self.horizontalLine, frame) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.horizontalLine tm_setGradientWithColors:@[UIColor.whiteColor, UIColor.lightGrayColor, UIColor.whiteColor] startPoint:CGPointZero endPoint:CGPointMake(1, 0)];
    }];
    [[RACObserve(self.verticalLine, frame) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.verticalLine tm_setGradientWithColors:@[UIColor.whiteColor, UIColor.lightGrayColor, UIColor.whiteColor] startPoint:CGPointZero endPoint:CGPointMake(0, 1)];
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.verticalLine.hidden = indexPath.row % 2 == 1;
}

- (void)setKnowledgeModel:(TMRelearnKnowledgeModel *)knowledgeModel {
    _knowledgeModel = knowledgeModel;
    
    self.titleLabel.text = knowledgeModel.cwName;
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    switch (knowledgeModel.status) {
            case TMWordsStatusNormal: {
                self.titleLabel.textColor = TM_HexColor(0x111111);
            }
            break;
            case TMWordsStatusPassed: {
                self.titleLabel.textColor = TM_HexColor(0x009801);
            }
            break;
            case TMWordsStatusNotPass: {
                self.titleLabel.textColor = UIColor.redColor;
            }
            break;
    }
}

- (void)setIsHighlight:(BOOL)isHighlight {
    _isHighlight = isHighlight;
    if (isHighlight) {
        self.titleLabel.font = [UIFont systemFontOfSize:30.0f];
        self.titleLabel.textColor = TM_HexColor(0xff6628);
    }
}

#pragma mark - lazyloading

- (MarqueeLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectZero rate:10 andFadeLength:5];
        _titleLabel.animationDelay = 0.1;
        _titleLabel.trailingBuffer = 24;
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = TM_HexColor(0x111111);
        _titleLabel.marqueeType = MLContinuous;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
}

@end

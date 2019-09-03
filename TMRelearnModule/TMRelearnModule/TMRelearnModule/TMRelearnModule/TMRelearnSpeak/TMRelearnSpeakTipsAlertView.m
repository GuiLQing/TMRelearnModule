//
//  TMRelearnSpeakTipsAlertView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnSpeakTipsAlertView.h"
#import <SGTools/SGTriangleView.h>
#import <Masonry/Masonry.h>

@implementation UIView (TM_Frame)

- (void)ap_setPosition:(CGPoint)point atAnchorPoint:(CGPoint)anchorPoint
{
    CGFloat x = point.x - anchorPoint.x * CGRectGetWidth(self.bounds);
    CGFloat y = point.y - anchorPoint.y * CGRectGetHeight(self.bounds);
    self.frame = (CGRect){CGPointMake(x, y), self.frame.size};
}

@end

static NSInteger const TMWordsStudyTipsViewTag = 1563775814;

@interface TMRelearnSpeakTipsAlertView ()

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) SGTriangleView *triangleView;

@property (nonatomic, copy) NSString *text;

@end

@implementation TMRelearnSpeakTipsAlertView

+ (TMRelearnSpeakTipsAlertView *)showWordsStudyTipsAlertViewInView:(UIView *)superView tips:(NSString *)tips triangleMode:(TMWordsStudyTipsTriangleMode)triangleMode position:(CGPoint)position anchorPoint:(CGPoint)anchorPoint {
    [[superView viewWithTag:TMWordsStudyTipsViewTag] removeFromSuperview];
    TMRelearnSpeakTipsAlertView *alertView = TMRelearnSpeakTipsAlertView.alloc.init;
    alertView.tag = TMWordsStudyTipsViewTag;
    alertView.text = tips;
    if (triangleMode == TMWordsStudyTipsTriangleModeLeft) {
        [alertView.triangleView ap_setPosition:CGPointMake(10.0f, CGRectGetMaxY(alertView.frame)) atAnchorPoint:CGPointMake(0, 1)];
    } else if (triangleMode == TMWordsStudyTipsTriangleModeRight) {
        [alertView.triangleView ap_setPosition:CGPointMake(CGRectGetWidth(alertView.frame) - 10.0f, CGRectGetMaxY(alertView.frame)) atAnchorPoint:CGPointMake(1, 1)];
    }
    [alertView ap_setPosition:position atAnchorPoint:anchorPoint];
    [superView addSubview:alertView];
    return alertView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.numberOfLines = 1;
        self.tipsLabel.textColor = UIColor.whiteColor;
        self.tipsLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.tipsLabel];
        
        UIView *tipsBackView = UIView.alloc.init;
        tipsBackView.backgroundColor = [UIColor colorWithRed:0 green:165/255.0f blue:246/255.0f alpha:1];
        tipsBackView.layer.cornerRadius = 4.0f;
        tipsBackView.layer.masksToBounds = YES;
        [self insertSubview:tipsBackView belowSubview:self.tipsLabel];
        [tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-6.0f);
        }];
        
        SGTriangleView *triangleView = [[SGTriangleView alloc] sg_initWithColor:[UIColor colorWithRed:0 green:165/255.0f blue:246/255.0f alpha:1] style:SGTriangleViewIsoscelesBottom];
        self.triangleView = triangleView;
        triangleView.frame = (CGRect){triangleView.frame.origin, CGSizeMake(10.0f, 6.0f)};
        [self addSubview:triangleView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    self.tipsLabel.text = text;
    [self.tipsLabel sizeToFit];
    self.frame = CGRectMake(0, 0, self.tipsLabel.frame.size.width + 20.0f, self.tipsLabel.frame.size.height + 30.0f);
    self.tipsLabel.frame = (CGRect){CGPointMake(10.0f, 10.0f), self.tipsLabel.frame.size};
}

@end

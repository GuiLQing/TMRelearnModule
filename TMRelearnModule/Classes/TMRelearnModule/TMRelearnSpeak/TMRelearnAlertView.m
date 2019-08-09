//
//  TMRelearnAlertView.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnAlertView.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TMRelearnAlertView ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *ensureButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) void (^ensureBlock)(void);
@property (nonatomic, strong) void (^cancelBlock)(void);

@end

@implementation TMRelearnAlertView

+ (TMRelearnAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message ensure:(void (^)(void))ensure cancel:(void (^)(void))cancel {
    TMRelearnAlertView *alertView = [[TMRelearnAlertView alloc] init];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    alertView.cancelBlock = cancel;
    alertView.ensureBlock = ensure;
    [alertView show];
    return alertView;
}

+ (TMRelearnAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message ensureTitle:(NSString *)ensureTitle cancelTitle:(NSString *)cancelTitle ensure:(void (^)(void))ensure cancel:(void (^)(void))cancel {
    TMRelearnAlertView *alertView = [[TMRelearnAlertView alloc] init];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    alertView.cancelBlock = cancel;
    alertView.ensureBlock = ensure;
    [alertView.ensureButton setTitle:ensureTitle forState:UIControlStateNormal];
    [alertView.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [alertView show];
    return alertView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.window = UIApplication.sharedApplication.keyWindow;
    self.frame = self.window.bounds;
    self.backgroundColor = UIColor.clearColor;
    
    self.backView = UIView.alloc.init;
    self.backView.backgroundColor = UIColor.blackColor;
    self.backView.frame = self.bounds;
    self.backView.alpha = 0.0f;
    [self addSubview:self.backView];
    
    self.contentView = UIView.alloc.init;
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(40.0f);
        make.right.equalTo(self.mas_right).offset(-40.0f);
    }];
    
    self.titleLabel = UILabel.alloc.init;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.textColor = TM_HexColor(0x111111);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.contentView.layer.cornerRadius = 12.0f;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
        make.left.equalTo(self.contentView.mas_left).offset(20.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0f);
    }];
    
    self.messageLabel = UILabel.alloc.init;
    self.messageLabel.font = [UIFont systemFontOfSize:15.0];
    self.messageLabel.textColor = TM_HexColor(0x666666);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30.0f);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    self.cancelButton = UIButton.alloc.init;
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:TM_HexColor(0x0baffb) forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = UIColor.whiteColor;
    self.cancelButton.layer.cornerRadius = 20.0f;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderColor = TM_HexColor(0x0baffb).CGColor;
    self.cancelButton.layer.borderWidth = 1.0f;
    [self.contentView addSubview:self.cancelButton];
    
    self.ensureButton = UIButton.alloc.init;
    self.ensureButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.ensureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.ensureButton.backgroundColor = TM_HexColor(0x0baffb);
    self.ensureButton.layer.cornerRadius = 20.0f;
    self.ensureButton.layer.masksToBounds = YES;
    [self.contentView addSubview:self.ensureButton];
    
    NSArray *array = @[self.cancelButton, self.ensureButton];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:25 leadSpacing:25 tailSpacing:25];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40.0f);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(30.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.0f);
    }];
    
    self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0f, 0.0f);
    
    @weakify(self);
    [[[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self hide];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
    [[[self.ensureButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self hide];
        if (self.ensureBlock) {
            self.ensureBlock();
        }
    }];
}

- (void)show {
    [self.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.5;
        self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        }];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.0f;
        self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 0.1f);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end

//
//  TMRelearnBaseViewController.m
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnBaseViewController.h"
#import "TMRelearnMacros.h"
#import <Masonry/Masonry.h>
#import "UIImage+TMResource.h"

@interface TMRelearnBaseViewController ()

@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) UIView *loadErrorView;

@end

@implementation TMRelearnBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setLoadingViewShow:(BOOL)show {
    if (self.noDataView) [self.noDataView removeFromSuperview];
    if (self.loadErrorView) [self.loadErrorView removeFromSuperview];
    [self setView:self.loadingView show:show];
}

- (void)setNoDataViewShow:(BOOL)show {
    if (self.loadingView) [self.loadingView removeFromSuperview];
    if (self.loadErrorView) [self.loadErrorView removeFromSuperview];
    [self setView:self.noDataView show:show];
}

- (void)setLoadErrorViewShow:(BOOL)show {
    if (self.loadingView) [self.loadingView removeFromSuperview];
    if (self.noDataView) [self.loadingView removeFromSuperview];
}

- (void)setView:(UIView *)view show:(BOOL)show {
    if (!view) return;
    if (show) {
        if (view) [view removeFromSuperview];
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [view removeFromSuperview];
    }
}

#pragma mark - lazyLoading

- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = UIView.alloc.init;
        _loadingView.backgroundColor = UIColor.whiteColor;
        
        UIView *view = UIView.alloc.init;
        [_loadingView addSubview:view];
        __weak typeof(self) weakSelf = self;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.loadingView);
        }];
        
        UIImageView *loadingIV = UIImageView.alloc.init;
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < 64; i ++) {
            UIImage *image = [UIImage tm_imagePathName:[NSString stringWithFormat:@"et_icon_loading_%ld.jpg", i]];
            if (image) {
                [images addObject:image];
            }
        }
        loadingIV.animationImages = images;
        [loadingIV startAnimating];
        [_loadingView addSubview:loadingIV];
        [view addSubview:loadingIV];
        [loadingIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
            make.width.height.mas_equalTo(100);
        }];
        
        UILabel *tipsLabel = UILabel.alloc.init;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor =  TM_HexColor(0x666666);
        tipsLabel.text = @"努力加载中...";
        [view addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loadingIV.mas_bottom).offset(10.0f);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
            make.bottom.equalTo(view.mas_bottom);
        }];
    }
    return _loadingView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = UIView.alloc.init;
        _noDataView.backgroundColor = UIColor.whiteColor;
        
        UIView *view = UIView.alloc.init;
        [_noDataView addSubview:view];
        __weak typeof(self) weakSelf = self;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.noDataView);
        }];
        
        UIImageView *noDataIV = UIImageView.alloc.init;
        UIImage *noDataImage = [UIImage tm_imageNamed:@"tm_icon_loading_empty"];
        noDataIV.image = noDataImage;
        [_loadingView addSubview:noDataIV];
        [view addSubview:noDataIV];
        [noDataIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(noDataImage.size);
            make.top.equalTo(view.mas_top);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
        }];
        
        UILabel *tipsLabel = UILabel.alloc.init;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor =  TM_HexColor(0x666666);
        tipsLabel.text = @"暂无内容";
        [view addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noDataIV.mas_bottom).offset(10.0f);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
            make.bottom.equalTo(view.mas_bottom);
        }];
    }
    return _noDataView;
}

- (UIView *)loadErrorView {
    if (!_loadErrorView) {
        _loadErrorView = UIView.alloc.init;
        _loadErrorView.backgroundColor = UIColor.whiteColor;
        
        UIView *view = UIView.alloc.init;
        [_loadErrorView addSubview:view];
        __weak typeof(self) weakSelf = self;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.loadErrorView);
        }];
        
        UIImageView *loadingErrorIV = UIImageView.alloc.init;
        UIImage *noDataImage = [UIImage tm_imageNamed:@"tm_icon_loading_error"];
        loadingErrorIV.image = noDataImage;
        [_loadingView addSubview:loadingErrorIV];
        [view addSubview:loadingErrorIV];
        [loadingErrorIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(noDataImage.size);
            make.top.equalTo(view.mas_top);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
        }];
        
        UILabel *tipsLabel = UILabel.alloc.init;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor =  TM_HexColor(0x666666);
        tipsLabel.text = @"加载失败，轻触刷新";
        [view addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loadingErrorIV.mas_bottom).offset(10.0f);
            make.left.mas_greaterThanOrEqualTo(view.mas_left);
            make.right.mas_lessThanOrEqualTo(view.mas_right);
            make.bottom.equalTo(view.mas_bottom);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againLoadData)];
        [_loadErrorView addGestureRecognizer:tap];
    }
    return _loadErrorView;
}

- (void)againLoadData {
    
}

@end

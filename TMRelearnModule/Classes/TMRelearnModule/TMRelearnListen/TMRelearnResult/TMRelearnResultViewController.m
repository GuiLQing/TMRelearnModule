//
//  TMRelearnResultViewController.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnResultViewController.h"
#import "PSG_ChainFunction.h"
#import "UIImage+TMResource.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TMRelearnResultDetailViewController.h"

static CGFloat const startImageSize = 60.0f;
static NSInteger const D_MINUTE = 60;

@implementation NSDate (TMDate)

+ (NSString *)secondsTommss:(NSInteger)seconds {
    if (seconds < 0 || seconds == 0) {
        return @"00:00";
    }
    
    NSString *minute = [NSString stringWithFormat:@"%ld",(seconds/D_MINUTE)%D_MINUTE];
    if ([minute length] == 1) {
        minute = [NSString stringWithFormat:@"0%@",minute];
    }
    NSString *second = [NSString stringWithFormat:@"%ld",seconds%D_MINUTE];
    if ([second length] == 1) {
        second = [NSString stringWithFormat:@"0%@",second];
    }
    NSString *mmss = [NSString stringWithFormat:@"%@:%@",minute,second];
    return mmss;
}

@end

@interface TMResultStarView : UIView

@property (nonatomic, strong) NSMutableArray *stars;

@property (nonatomic, assign) NSInteger starCount;

@end

@implementation TMResultStarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.g_size(CGSizeMake(UIScreen.mainScreen.bounds.size.width - 30.0f * 2, startImageSize * 2));
        
        CGFloat horizontalSpace = (CGRectGetWidth(self.frame) - 5 * startImageSize) / 4;
        CGFloat verticalSpace = startImageSize / 3 * 2;
        
        CGFloat bottom = CGRectGetHeight(self.frame);
        CGFloat left = 0;
        self.stars = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i ++) {
            UIImageView *imageView = UIImageView.alloc.init;
            imageView.image = [UIImage tm_imageNamed:@"tm_result_icon_star_normal"];
            imageView.g_size(CGSizeMake(startImageSize, startImageSize));
            [self addSubview:imageView];
            [self.stars addObject:imageView];
            
            imageView.g_setPositionAtAnchorPoint(CGPointMake(left, bottom), CGPointMake(0, 1));
            if (i == 2) verticalSpace = -verticalSpace;
            bottom -= verticalSpace;
            left += startImageSize + horizontalSpace;
        }
    }
    return self;
}

- (void)setStarCount:(NSInteger)starCount {
    _starCount = starCount;
    for (NSInteger i = 0; i < starCount; i ++) {
        if (i >= self.stars.count) break;
        
        UIImageView *imageView = self.stars[i];
        imageView.image = [UIImage tm_imageNamed:@"tm_result_icon_star_highlight"];
    }
}

@end

@interface TMResultScoreView : UIView

@property (nonatomic, strong) UIButton *scoreButton;
@property (nonatomic, strong) UIButton *timeButton;

@end

@implementation TMResultScoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat buttonSize = 60.0f;
        
        self.scoreButton = UIButton.g_init
        .g_titleColor(UIColor.whiteColor, UIControlStateNormal)
        .g_titleFont([UIFont systemFontOfSize:25.0f])
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_score"], UIControlStateNormal)
        .g_title(@"100", UIControlStateNormal);
        self.scoreButton.userInteractionEnabled = NO;
        [self addSubview:self.scoreButton];
        [self.scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
        }];
        
        self.timeButton = UIButton.g_init
        .g_titleColor(UIColor.whiteColor, UIControlStateNormal)
        .g_titleFont([UIFont systemFontOfSize:20.0f])
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_time"], UIControlStateNormal)
        .g_title(@"00:00", UIControlStateNormal);
        self.timeButton.userInteractionEnabled = NO;
        [self addSubview:self.timeButton];
        [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
            make.left.equalTo(self.scoreButton.mas_right).offset(buttonSize);
        }];
        
        UILabel *scoreLabel = UILabel.g_init
        .g_text(@"得分")
        .g_textColor(TM_HexColor(0x111111))
        .g_font([UIFont systemFontOfSize:15.0])
        .g_textAlignment(NSTextAlignmentCenter)
        .g_numberOfLines(1);
        [self addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scoreButton);
            make.top.equalTo(self.scoreButton.mas_bottom).offset(10.0f);
            make.bottom.equalTo(self);
        }];
        
        UILabel *timeLabel = UILabel.g_init
        .g_text(@"时间")
        .g_textColor(TM_HexColor(0x111111))
        .g_font([UIFont systemFontOfSize:15.0])
        .g_textAlignment(NSTextAlignmentCenter)
        .g_numberOfLines(1);
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.timeButton);
            make.top.equalTo(self.timeButton.mas_bottom).offset(10.0f);
        }];
    }
    return self;
}

@end

@interface TMResultFunctionView : UIView

@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) void (^detailDidClicked)(void);
@property (nonatomic, strong) void (^exitDidClicked)(void);

@end

@implementation TMResultFunctionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGSize buttonSize = CGSizeMake(130.0f, 40.0f);
        
        @weakify(self);
        self.detailButton = UIButton.g_init
        .g_titleColor(TM_HexColor(0x0baffb), UIControlStateNormal)
        .g_title(@"查看详情", UIControlStateNormal)
        .g_title(@"查看详情", UIControlStateHighlighted)
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_left_button"], UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_left_button"], UIControlStateHighlighted)
        .g_subscribeNext(UIControlEventTouchUpInside, ^(UIButton *button) {
            @strongify(self);
            if (self.detailDidClicked) {
                self.detailDidClicked();
            }
        });
        [self addSubview:self.detailButton];
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.size.mas_equalTo(buttonSize);
        }];
        self.detailButton.layer.cornerRadius = 20.0f;
        
        self.exitButton = UIButton.g_init
        .g_titleColor(UIColor.whiteColor, UIControlStateNormal)
        .g_title(@"我知道了", UIControlStateNormal)
        .g_title(@"我知道了", UIControlStateHighlighted)
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_right_button"], UIControlStateNormal)
        .g_backgroundImage([UIImage tm_imageNamed:@"tm_result_icon_right_button"], UIControlStateHighlighted)
        .g_subscribeNext(UIControlEventTouchUpInside, ^(UIButton *button) {
            @strongify(self);
            if (self.exitDidClicked) {
                self.exitDidClicked();
            }
        });
        [self addSubview:self.exitButton];
        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(buttonSize);
            make.left.equalTo(self.detailButton.mas_right).offset(20.0f);
        }];
        self.exitButton.layer.cornerRadius = 20.0f;
        
        UIImageView *bottomIV = UIImageView.alloc.init;
        bottomIV.image = [UIImage tm_imageNamed:@"tm_result_icon_button_shadow"];
        [self addSubview:bottomIV];
        [bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailButton.mas_bottom);
            make.left.right.equalTo(self.detailButton);
            make.height.mas_equalTo(3.0f);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        UIImageView *exitBottomIV = UIImageView.alloc.init;
        exitBottomIV.image = [UIImage tm_imageNamed:@"tm_result_icon_button_shadow"];
        [self addSubview:exitBottomIV];
        [exitBottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exitButton.mas_bottom);
            make.left.right.equalTo(self.exitButton);
            make.height.mas_equalTo(3.0f);
        }];
    }
    return self;
}

@end

@interface TMRelearnResultViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) UIImageView *bigFlowerIV;
@property (nonatomic, strong) UIImageView *smallFlowerIV;
@property (nonatomic, strong) TMResultStarView *starView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) TMResultScoreView *scoreView;
@property (nonatomic, strong) TMResultFunctionView *functionView;

@property (nonatomic, assign) dispatch_once_t onceToken;

@end

@implementation TMRelearnResultViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_once(&_onceToken, ^{
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        if (viewControllers.count >= 2) {
            [viewControllers removeObjectAtIndex:viewControllers.count - 2];
            self.navigationController.viewControllers = viewControllers;
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self resetDataSource];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:[viewController isKindOfClass:[self class]] animated:YES];
}

- (void)resetDataSource {
    CGFloat trainingScore = 0;
    for (TMRelearnKnowledgeModel *model in self.knowledgeDataSource) {
        trainingScore += model.score;
    }
    trainingScore = trainingScore / self.knowledgeDataSource.count;
    [self.scoreView.scoreButton setTitle:[NSString stringWithFormat:@"%ld", (NSInteger)trainingScore] forState:UIControlStateNormal];
    [self.scoreView.timeButton setTitle:[NSDate secondsTommss:self.timeLength] forState:UIControlStateNormal];
    self.starView.starCount = trainingScore >= 95 ? 5 : (trainingScore / 20);
    self.contentLabel.text = trainingScore >= 60 ? @"恭喜你完成本次训练\n请再接再厉" : @"很遗憾\n本次训练未通过";
    self.bigFlowerIV.hidden = trainingScore < 60;
    self.smallFlowerIV.hidden = trainingScore < 60;
}

- (void)layoutUI {
    
    self.bgIV = UIImageView.alloc.init;
    self.bgIV.image = [UIImage tm_imageNamed:@"tm_result_icon_bg"];
    self.bgIV.frame = CGRectMake(0, 0, TM_SCREEN_WIDTH, TM_SCREEN_WIDTH + TM_STATUS_NEAT_BANG_HEIGHT);
    [self.view addSubview:self.bgIV];
    
    self.bigFlowerIV = UIImageView.alloc.init;
    self.bigFlowerIV.image = [UIImage tm_imageNamed:@"tm_result_icon_flower_big"];
    self.bigFlowerIV.frame = self.bgIV.frame;
    [self.view addSubview:self.bigFlowerIV];
    
    self.starView = [[TMResultStarView alloc] init];
    self.starView.g_setPositionAtAnchorPoint(CGPointMake(TM_SCREEN_WIDTH / 2, TM_STATUS_AND_NAVIGATION_BAR_HEIGHT + 20.0f), CGPointMake(0.5, 0));
    [self.view addSubview:self.starView];
    
    UIView *contentView = UIView.alloc.init;
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.g_size(CGSizeMake(TM_SCREEN_WIDTH - 12.0f * 2, TM_SCREEN_HEIGHT - CGRectGetMaxY(self.starView.frame) - 30.0f));
    contentView.g_setPositionAtAnchorPoint(CGPointMake(TM_SCREEN_WIDTH / 2, TM_SCREEN_HEIGHT), CGPointMake(0.5, 1));
    contentView.layer.g_cornerRadius(12.0f)
    .g_shadowColor([UIColor colorWithRed:47/255.0 green:126/255.0 blue:229/255.0 alpha:0.3].CGColor)
    .g_shadowOffset(CGSizeMake(2, -2))
    .g_shadowOpacity(1)
    .g_shadowRadius(12.0f);
    [self.view addSubview:contentView];
    
    [self layoutContentSubviewsInView:contentView];
    
    self.smallFlowerIV = UIImageView.alloc.init;
    self.smallFlowerIV.image = [UIImage tm_imageNamed:@"tm_result_icon_flower_small"];
    self.smallFlowerIV.g_size(self.smallFlowerIV.image.size);
    self.smallFlowerIV.g_setPositionAtAnchorPoint(CGPointMake(TM_SCREEN_WIDTH / 2, CGRectGetMinY(contentView.frame)), CGPointMake(0.5, 0.5));
    [self.view addSubview:self.smallFlowerIV];
    
    @weakify(self);
    UIButton *backButton = UIButton.g_init
    .g_image([UIImage tm_imageNamed:@"tm_navi_icon_back"], UIControlStateNormal)
    .g_size(CGSizeMake(44.0f, 44.0f))
    .g_setPositionAtAnchorPoint(CGPointMake(0.0f, TM_STATUS_BAR_HEIGHT), CGPointZero)
    .g_buttonMaker
    .g_subscribeNext(UIControlEventTouchUpInside, ^(UIButton *button) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    });
    [self.view addSubview:backButton];
    
    self.functionView.detailDidClicked = ^{
        @strongify(self);
        TMRelearnResultDetailViewController *detailVC = [[TMRelearnResultDetailViewController alloc] init];
        detailVC.knowledgeDataSource = self.knowledgeDataSource;
        [self.navigationController pushViewController:detailVC animated:YES];
    };

    self.functionView.exitDidClicked = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)layoutContentSubviewsInView:(UIView *)contentView {
    UIView *contentLabelTopSpace = UIView.alloc.init;
    [contentView addSubview:contentLabelTopSpace];
    [contentLabelTopSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
    }];
    
    self.contentLabel = UILabel.g_init
    .g_text(@"")
    .g_font([UIFont systemFontOfSize:25.0f])
    .g_textColor(TM_HexColor(0x0baffb))
    .g_textAlignment(NSTextAlignmentCenter)
    .g_lineBreakMode(NSLineBreakByWordWrapping)
    .g_numberOfLines(0);
    [contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabelTopSpace.mas_bottom);
        make.left.equalTo(contentView.mas_left).offset(20.0f);
        make.right.equalTo(contentView.mas_right).offset(-20.0f);
    }];
    
    UIView *scoreViewTopSpace = UIView.alloc.init;
    [contentView addSubview:scoreViewTopSpace];
    [scoreViewTopSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(contentLabelTopSpace.mas_height);
    }];
    
    self.scoreView = [[TMResultScoreView alloc] init];
    [contentView addSubview:self.scoreView];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreViewTopSpace.mas_bottom);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    UIView *functionViewTopSpace = UIView.alloc.init;
    [contentView addSubview:functionViewTopSpace];
    [functionViewTopSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreView.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(contentLabelTopSpace.mas_height);
    }];
    
    self.functionView = [[TMResultFunctionView alloc] init];
    [contentView addSubview:self.functionView];
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(functionViewTopSpace.mas_bottom);
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(contentView.mas_bottom).offset(-40.0f);
    }];
    
}

@end

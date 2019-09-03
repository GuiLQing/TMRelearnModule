//
//  TMRelearnListenViewController.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnListenViewController.h"
#import "TMRelearnListenFooterView.h"
#import <Masonry/Masonry.h>
#import "TMRelearnListenCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <SGTools/SGSingleAudioPlayer.h>
#import <LGAlertHUD/LGAlertHUD.h>
#import "TMRelearnResultViewController.h"
#import <SGTools/SGSpeechSynthesizerManager.h>
#import "TMRelearnMacros.h"
#import <LGAlertHUD/LGAlertHUD.h>

static NSString * const TMRelearnListenCellIdentifier = @"TMRelearnListenCellIdentifier";

@interface TMRelearnListenViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TMRelearnListenFooterViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) CGPoint currentContentOffset;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) SGSingleAudioPlayer *audioPlayer;

@property (nonatomic, assign) dispatch_once_t onceToken;

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation TMRelearnListenViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isReTraining) {
        dispatch_once(&_onceToken, ^{
            NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
            if (viewControllers.count >= 2) {
                [viewControllers removeObjectAtIndex:viewControllers.count - 2];
                self.navigationController.viewControllers = viewControllers;
            }
        });
    }
    
    [self playAudio];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"听写(1/%li)",self.knowledgeDataSource.count];
    
    self.startDate = [NSDate date];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButtonItem)];
    [buttonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : UIColor.whiteColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[buttonItem, spaceItem];
    
    [self layoutUI];
    
    /** 进入后台 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)willResignActive:(NSNotification *)noti {
    [self.audioPlayer invalidate];
    [self resetCountView];
    [SGSpeechDefaultManager cancelSpeech];
}

- (void)clickBarButtonItem {
    NSTimeInterval timeLength = [NSDate.date timeIntervalSinceDate:self.startDate];
    TMRelearnResultViewController *resultVC = [[TMRelearnResultViewController alloc] init];
    resultVC.knowledgeDataSource = self.knowledgeDataSource;
    resultVC.timeLength = timeLength;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)layoutUI {
    @weakify(self);
    [[RACObserve(self.view, frame) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateCollectionView];
    }];
    [[RACObserve(self.collectionView, frame) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateCollectionView];
    }];
    
    TMRelearnListenFooterView *footerView = [[TMRelearnListenFooterView alloc] init];
    footerView.delegate = self;
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(footerView.mas_top);
    }];
    
    [self.view bringSubviewToFront:footerView];
    footerView.layer.shadowColor = [UIColor colorWithRed:47/255.0 green:126/255.0 blue:229/255.0 alpha:0.3].CGColor;
    footerView.layer.shadowOffset = CGSizeMake(0, -2);
    footerView.layer.shadowOpacity = 1;
}

- (void)updateCollectionView {
    [self.collectionView layoutIfNeeded];
    self.flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
}

- (void)scrollToItemAtIndex:(NSInteger)index {
    if (index >= self.knowledgeDataSource.count || index < 0) {
        [LGAlert showStatus: index < 0 ? @"没有上一个了！" : @"没有下一个了！"];
        return;
    }
     self.title = [NSString stringWithFormat:@"听写(%li/%li)",index+1,self.knowledgeDataSource.count];
    self.currentIndex = index;
    [self playAudio];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - TMRelearnListenFooterView

- (void)footerItemDidClickedAtIndex:(TMRelearnListenFooterItemType)type {
    if (type == TMRelearnListenFooterItemTypeLast) {
        [self scrollToItemAtIndex:self.currentIndex - 1];
    } else {
        [self scrollToItemAtIndex:self.currentIndex + 1];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.knowledgeDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMRelearnListenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TMRelearnListenCellIdentifier forIndexPath:indexPath];
    cell.model = self.knowledgeDataSource[indexPath.row];
    @weakify(self);
    cell.ensureDidClicked = ^{
        @strongify(self);
        if (self.currentIndex >= self.knowledgeDataSource.count - 1){
            [self clickBarButtonItem];
        }else{
            [self scrollToItemAtIndex:self.currentIndex + 1];
        };
    };
    cell.countDownDidClicked = ^{
        @strongify(self);
        [self playAudio];
    };
    return cell;
}

#pragma mark - UIScrollViewDelegate

/** 开始触发拖拽 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _currentContentOffset = scrollView.contentOffset;
}

/** 滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (self.currentIndex != pageIndex) {
        self.currentIndex = pageIndex;
        [self playAudio];
    }
}

/** 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self playAudio];
}

- (void)playAudio {
    [SGSpeechDefaultManager cancelSpeech];
    if (self.audioPlayer) [self.audioPlayer invalidate];
    NSURL *audioUrl = [NSURL URLWithString:[self.knowledgeDataSource[self.currentIndex].usPVoice stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    @weakify(self);
    self.audioPlayer = [SGSingleAudioPlayer audioPlayWithUrl:audioUrl playProgress:^(CGFloat progress, NSTimeInterval audioDuration, NSTimeInterval playSenconds) {
        @strongify(self);
        [self updateCountDownViewProgress:progress];
    } completionHandle:^(NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [LGAlert showStatus:@"音频资源错误，启用系统播放"];
            [SGSpeechDefaultManager speechWithEnglishText:TMFilterHTML(self.knowledgeDataSource[self.currentIndex].cwName) completion:^{
                @strongify(self);
                [self resetCountView];
            }];
        } else {
            [self resetCountView];
        }
    }];
}

- (void)updateCountDownViewProgress:(CGFloat)progress {
    TMRelearnListenCell *cell = (TMRelearnListenCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell updateCountDownViewProgress:progress];
}

- (void)resetCountView {
    TMRelearnListenCell *cell = (TMRelearnListenCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell resetCountDownView];
}

#pragma mark - lazyLoading

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:TMRelearnListenCell.class forCellWithReuseIdentifier:TMRelearnListenCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.alloc.init;
        _flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 10.0f);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end

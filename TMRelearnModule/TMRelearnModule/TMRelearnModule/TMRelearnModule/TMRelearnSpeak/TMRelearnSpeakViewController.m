//
//  TMRelearnSpeakViewController.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnSpeakViewController.h"
#import "TMRelearnSpeakCell.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "TMRelearnMacros.h"
#import "TMRelearnSpeakManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TMRelearnSpeakFooterView.h"
#import "TMRelearnSpeakTipsAlertView.h"
#import "TMRelearnAlertView.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import <SGTools/SGSpeechSynthesizerManager.h>

static NSString * const TMRelearnSpeakCellIdentifier = @"TMRelearnSpeakCellIdentifier";
static CGFloat const TMRelearnSpeakFooterViewHeight = 50.0f;

@interface TMRelearnSpeakViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TMRelearnSpeakFooterViewDelegate, TMRelearnSpeakManagerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger currentStudyIndex; //当前学习下标值

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *dataSource;

@property (nonatomic, assign) NSInteger pageIndex; //当前页码

@property (nonatomic, strong) TMRelearnSpeakFooterView *footerView;

@property (nonatomic, strong) TMRelearnSpeakTipsAlertView *tipsAlertView;

@end

@implementation TMRelearnSpeakViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TMRelearnSpeakManager.defaultManager stopWordsStudy];
    [self.tipsAlertView removeFromSuperview];
}

- (void)willResignActive:(NSNotification *)noti {
    [TMRelearnSpeakManager.defaultManager stopWordsStudy];
    self.footerView.updateStartButtonSelected(NO);
    self.footerView.updateParaphraseButtonDisabled(YES);
    [SGSpeechDefaultManager cancelSpeech];
}

- (void)didBecomeActive:(NSNotification *)noti {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朗读";
    
    [self layoutUI];
    
    [self loadDataSourceIsLoadMore:NO];
    
    TMRelearnSpeakManager.defaultManager.delegate = self;
    
    /** 进入后台 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    /** 返回前台 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)loadDataSourceIsLoadMore:(BOOL)isLoadMore {
    [self updatePageNumberIsLoadMore:isLoadMore];
    self.dataSource = [NSMutableArray array];
    for (NSInteger i = self.pageIndex * 20; i < (self.pageIndex + 1) * 20; i ++) {
        if (i < self.knowledgeDataSource.count) {
            [self.dataSource addObject:self.knowledgeDataSource[i]];
        }
    }
    [self.collectionView reloadData];
    
    if (self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
    if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
    if (self.dataSource.count < 20 || self.knowledgeDataSource.count <= (self.pageIndex + 1) * 20) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)updatePageNumberIsLoadMore:(BOOL)isLoadMore {
    if (!isLoadMore) {
        if (self.pageIndex > 0) {
            self.pageIndex --;
        } else {
            self.pageIndex = 0;
        }
    } else {
        self.pageIndex ++;
    }
    self.currentStudyIndex = 0;
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TMRelearnSpeakFooterViewHeight);
    }];
    
    self.footerView = TMRelearnSpeakFooterView.alloc.init;
    self.footerView.delegate = self;
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(TMRelearnSpeakFooterViewHeight);
    }];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf loadDataSourceIsLoadMore:NO];
    }];
    [normalHeader setTitle:@"加载上一页" forState:MJRefreshStateIdle];
    [normalHeader setTitle:@"松开加载上一页" forState:MJRefreshStatePulling];
    [normalHeader setTitle:@"正在拼命加载中 ..." forState:MJRefreshStateRefreshing];
    normalHeader.stateLabel.textColor = TM_HexColor(0x999999);
    normalHeader.stateLabel.font = [UIFont systemFontOfSize:12.0];
    normalHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0];
    normalHeader.lastUpdatedTimeLabel.textColor = TM_HexColor(0x999999);
    self.collectionView.mj_header = normalHeader;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadDataSourceIsLoadMore:YES];
    }];
    [footer setTitle:@"加载下一页" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载下一页" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在拼命加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = TM_HexColor(0x999999);
    footer.stateLabel.font = [UIFont systemFontOfSize:12.0];
    self.collectionView.mj_footer = footer;
}

- (void)updateCollectionView {
    [self.collectionView layoutIfNeeded];
    self.flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2.0f, CGRectGetHeight(self.collectionView.frame) / 10.0f);
    [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
}

- (void)showRecordTips:(NSString *)tips {
    TMRelearnSpeakCell *cell = (TMRelearnSpeakCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentStudyIndex inSection:0]];
    CGRect cellRectAtWindow = [self.collectionView convertRect:cell.frame toView:self.navigationController.view];
    TMWordsStudyTipsTriangleMode triangleMode = self.currentStudyIndex % 2;
    CGPoint position = CGPointMake(CGRectGetMidX(cellRectAtWindow), CGRectGetMinY(cellRectAtWindow) + 10.0f);
    CGPoint anchorPoint = triangleMode == TMWordsStudyTipsTriangleModeLeft ? CGPointMake(0, 1) : CGPointMake(1, 1);
    self.tipsAlertView = [TMRelearnSpeakTipsAlertView showWordsStudyTipsAlertViewInView:self.navigationController.view tips:tips triangleMode:triangleMode position:position anchorPoint:anchorPoint];
}

- (void)startCurrentIndexStudy {
    [SGSpeechDefaultManager cancelSpeech];
    [self.collectionView reloadData];
    self.footerView.updateParaphraseButtonDisabled(NO);
    [TMRelearnSpeakManager.defaultManager restartWordsStudyWithWordsModel:self.dataSource[self.currentStudyIndex]];
}

- (void)startNextAvailableIndexStudy {
    if (self.currentStudyIndex >= self.dataSource.count) {
        self.currentStudyIndex = 0;
        BOOL isAllLearned = YES;
        for (TMRelearnKnowledgeModel *model in self.dataSource) {
            if (model.status != TMWordsStatusNormal) {
                isAllLearned = NO;
                break;
            }
        }
        if (self.collectionView.mj_footer.state == MJRefreshStateNoMoreData) {
            if (!isAllLearned) {
                [self startNextAvailableIndexStudy];
            } else {
                self.footerView.updateStartButtonDisabled(YES);
                [LGAlert showStatus:@"本页单词已全部学习，可以通过点击单词继续学习！"];
            }
            return;
        }
        NSString *tipsTitle = isAllLearned ? @"本页单词已全部学习" : @"本页还有未学习单词";
        
        @weakify(self);
        [TMRelearnAlertView showAlertWithTitle:tipsTitle message:@"是否需要加载下一页？" ensure:^{
            @strongify(self);
            [self.collectionView.mj_footer beginRefreshing];
        } cancel:^{
        }];
        return ;
    }
    TMRelearnKnowledgeModel *model = self.dataSource[self.currentStudyIndex];
    if (model.status == TMWordsStatusPassed) {
        self.currentStudyIndex ++;
        [self startNextAvailableIndexStudy];
    } else {
        [self startCurrentIndexStudy];
    }
}

#pragma mark - TMRelearnSpeakManagerDelegate

/** 学习状态改变 */
- (void)wordsStudyStatusDidChanged:(TMWordsStudyStatus)status {
    if (status != TMWordsStudyStatusResult) [self.tipsAlertView removeFromSuperview];
    self.footerView.updateStartButtonSelected(status!=TMWordsStudyStatusDefault);
}

/** 语音评测结果回调 */
- (void)sentenceSpeechEngineResult:(NSDictionary *)result {
    self.dataSource[self.currentStudyIndex].status = [result[@"totalScore"] integerValue] >= 60 ? TMWordsStatusPassed : TMWordsStatusNotPass;;
    [self showRecordTips:[NSString stringWithFormat:@"得分%ld", [result[@"totalScore"] integerValue]]];
}

/** 跟读录音倒计时 */
- (void)recordRemaindSeconds:(NSTimeInterval)remainSeconds {
    [self showRecordTips:[NSString stringWithFormat:@"录音中，请跟读...%ld", (NSInteger)ceil(remainSeconds)]];
}

- (void)wordsStudyDidCompletion {
    [self.collectionView reloadData];
    self.footerView.updateParaphraseButtonDisabled(YES);
    self.currentStudyIndex ++;
    [self startNextAvailableIndexStudy];
}

#pragma mark - TMRelearnSpeakFooterViewDelegate

- (void)startButtonDidClicked:(BOOL)isToStart {
    if (isToStart) {
        [self startNextAvailableIndexStudy];
    } else {
        [TMRelearnSpeakManager.defaultManager stopWordsStudy];
    }
}

- (void)paraphraseButtonDidClicked {
    self.footerView.updateStartButtonSelected(NO);
    [TMRelearnSpeakManager.defaultManager stopWordsStudy];
    @weakify(self);
    [SGSpeechDefaultManager speechWithChineseText:self.dataSource[self.currentStudyIndex].cxSPmean completion:^{
        @strongify(self);
        [self startCurrentIndexStudy];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMRelearnSpeakCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TMRelearnSpeakCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.knowledgeModel = self.dataSource[indexPath.row];
    cell.isHighlight = self.currentStudyIndex == indexPath.row;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.currentStudyIndex = indexPath.row;
    [self startCurrentIndexStudy];
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
        [_collectionView registerClass:TMRelearnSpeakCell.class forCellWithReuseIdentifier:TMRelearnSpeakCellIdentifier];
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
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

@end

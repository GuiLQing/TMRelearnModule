//
//  TMRelearnWordsDetailViewController.m
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnWordsDetailViewController.h"
#import "TMRelearnMacros.h"
#import "TMRelearnRequest.h"
#import "TMRelearnWordsDetailCell.h"
#import "TMRelearnWordsDetailHeaderView.h"
#import <Masonry/Masonry.h>
#import <SGTools/SGSingleAudioPlayer.h>
#import <SGTools/SGSpeechSynthesizerManager.h>

static NSString * const TMRelearnWordsDetailCellIdentifier = @"TMRelearnWordsDetailCellIdentifier";

@interface TMRelearnWordsDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TMRelearnWordsDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeExampleSentenceModel *> *dataSource;

@property (nonatomic, strong) NSIndexPath *currentVoiceIndexPath;

@property (nonatomic, strong) SGSingleAudioPlayer *audioPlayer;

@end

@implementation TMRelearnWordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"单词释义";
    
    [self layoutUI];
    
    if (!self.wordsModel.cxCollection || self.wordsModel.cxCollection.count == 0) {
        [self againLoadData];
    }
}

- (void)againLoadData {
    [self setLoadingViewShow:YES];
    [TMRelearnRequest tm_requestSingleKnowledgeCoursewareWithKnowledge:self.wordsModel.cwName success:^(id  _Nonnull response) {
        self.wordsModel = [TMRelearnKnowledgeModel mj_objectWithKeyValues:response[@"Data"]];
        [self setLoadingViewShow:NO];
        [self updateTableHeaderView];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self setLoadErrorViewShow:YES];
    }];
}

- (void)layoutUI {
    self.tableView.estimatedRowHeight = 50.0f;
    [self.view addSubview:self.tableView];
    
    [self updateTableHeaderView];
    [self.tableView reloadData];
}

- (void)updateTableHeaderView {
    self.headerView = [[TMRelearnWordsDetailHeaderView alloc] initWithWordsModel:self.wordsModel];
    __weak typeof(self) weakSelf = self;
    self.headerView.unVoiceItemDidClicked = ^(NSString * _Nonnull voicePath) {
        [weakSelf stopAudio];
        [weakSelf.headerView updateUnVoiceAnimation:YES];
        [weakSelf playAudioWithUrlString:voicePath englishText:weakSelf.wordsModel.cwName];
    };
    self.headerView.usVoiceItemDidClicked = ^(NSString * _Nonnull voicePath) {
        [weakSelf stopAudio];
        [weakSelf.headerView updateUsVoiceAnimation:YES];
        [weakSelf playAudioWithUrlString:voicePath englishText:weakSelf.wordsModel.cwName];
    };
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tableView);
    }];
    
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}

- (void)setWordsModel:(TMRelearnKnowledgeModel *)wordsModel {
    _wordsModel = wordsModel;
    
    self.dataSource = [NSMutableArray array];
    for (TMRelearnKnowledgeParaphraseModel *paraphraseModel in wordsModel.cxCollection) {
        for (TMRelearnKnowledgeDetailParaphraseModel *detailModel in paraphraseModel.meanCollection) {
            for (TMRelearnKnowledgeExampleSentenceModel *sentenceModel in detailModel.senCollection) {
                [self.dataSource addObject:sentenceModel];
                if (self.dataSource.count == 3) return;
            }
        }
    }
}

- (void)playAudioWithUrlString:(NSString *)urlString englishText:(NSString *)englishText {
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer = [SGSingleAudioPlayer audioPlayWithUrl:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] playProgress:nil completionHandle:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            [SGSpeechDefaultManager speechWithEnglishText:TMFilterHTML(englishText) completion:^{
                [strongSelf stopVoiceAnimation];
            }];
        } else {
            [strongSelf stopVoiceAnimation];
        }
    }];
}

- (void)stopAudio {
    [self stopVoiceAnimation];
    [self.audioPlayer invalidate];
    [SGSpeechDefaultManager cancelSpeech];
}

- (void)stopVoiceAnimation {
    [self.headerView updateUnVoiceAnimation:NO];
    [self.headerView updateUsVoiceAnimation:NO];
    self.currentVoiceIndexPath = nil;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMRelearnWordsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TMRelearnWordsDetailCellIdentifier];
    if (!cell) {
        cell = [[TMRelearnWordsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TMRelearnWordsDetailCellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.sentenceModel = self.dataSource[indexPath.row];
    cell.isVoiceAnimating = [self.currentVoiceIndexPath isEqual:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.voiceItemDidClicked = ^(NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf stopAudio];
        strongSelf.currentVoiceIndexPath = indexPath;
        [strongSelf playAudioWithUrlString:strongSelf.dataSource[indexPath.row].sViocePath englishText:strongSelf.dataSource[indexPath.row].sentenceEn];
        [strongSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.alloc.init;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.alloc.init;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - LazyLoading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollsToTop = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

@end

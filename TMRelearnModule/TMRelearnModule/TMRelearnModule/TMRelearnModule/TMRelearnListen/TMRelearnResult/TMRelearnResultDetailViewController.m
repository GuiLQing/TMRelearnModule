//
//  TMRelearnResultDetailViewController.m
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnResultDetailViewController.h"
#import "TMRelearnResultDetailCell.h"
#import "TMRelearnResultDetailFooterView.h"
#import "PSG_ChainFunction.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TMRelearnListenViewController.h"

static NSString * const TMRelearnResultDetailCellIdentifier = @"TMRelearnResultDetailCellIdentifier";

@interface TMRelearnResultDetailViewController () <UITableViewDataSource, UITableViewDelegate, TMRelearnResultDetailFooterViewDelegate>

@property (nonatomic, assign) dispatch_once_t onceToken;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TMRelearnResultDetailViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TMRelearnResultDetailFooterView *footerView = [[TMRelearnResultDetailFooterView alloc] init];
    footerView.delegate = self;
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70.0f);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(footerView.mas_top);
    }];
    
    [self.view bringSubviewToFront:footerView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    self.tableView.rowHeight = TMRelearnResultDetailCellHeight;
}

#pragma mark - TMRelearnResultDetailFooterView

- (void)exitButtonDidClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reTrainingButtonDidClicked {
    for (TMRelearnKnowledgeModel *model in self.knowledgeDataSource) {
        model.score = 0;
        model.stuAnswer = @"";
    }
    TMRelearnListenViewController *listenVC = [[TMRelearnListenViewController alloc] init];
    listenVC.knowledgeDataSource = self.knowledgeDataSource;
    listenVC.isReTraining = YES;
    [self.navigationController pushViewController:listenVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.knowledgeDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMRelearnResultDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:TMRelearnResultDetailCellIdentifier];
    if (!cell) {
        cell = [[TMRelearnResultDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TMRelearnResultDetailCellIdentifier];
    }
    cell.model = self.knowledgeDataSource[indexPath.row];
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

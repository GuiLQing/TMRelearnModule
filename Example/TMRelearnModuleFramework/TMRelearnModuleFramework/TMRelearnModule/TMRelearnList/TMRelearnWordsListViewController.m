//
//  TMRelearnWordsListViewController.m
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnWordsListViewController.h"
#import <Masonry/Masonry.h>
#import "TMRelearnMacros.h"

@interface TMRelearnWordsListCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, assign) BOOL isShowSearch;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^searchButtonDidClicked)(NSIndexPath *indexPath);

@end

@implementation TMRelearnWordsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = UIView.alloc.init;
        self.backView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];

        self.searchButton = UIButton.alloc.init;
        [self.searchButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.contentView addSubview:self.searchButton];
        [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
            make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setIsShowSearch:(BOOL)isShowSearch {
    _isShowSearch = isShowSearch;

    self.textLabel.textColor = isShowSearch ? TM_HexColor(0xff6600) : TM_HexColor(0x111111);
    self.searchButton.hidden = !isShowSearch;
    self.backView.backgroundColor = isShowSearch ? TM_HexColor(0xffdfc9) : UIColor.whiteColor;
}

- (void)searchButtonAction {
    if (self.searchButtonDidClicked) {
        self.searchButtonDidClicked(self.indexPath);
    }
}

@end

static NSString * const TMRelearnWordsListCellIdentifier = @"TMRelearnWordsListCellIdentifier";

@interface TMRelearnWordsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation TMRelearnWordsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"再学习单词";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.knowledgeDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMRelearnWordsListCell *cell = [tableView dequeueReusableCellWithIdentifier:TMRelearnWordsListCellIdentifier];
    if (!cell) {
        cell = [[TMRelearnWordsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TMRelearnWordsListCellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.textLabel.text = self.knowledgeDataSource[indexPath.row].cwName;
    cell.isShowSearch = [self.currentIndexPath isEqual:indexPath];
    cell.searchButtonDidClicked = ^(NSIndexPath *indexPath) {
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = UIView.alloc.init;
    view.frame = (CGRect){CGPointZero, CGSizeMake(CGRectGetWidth(self.tableView.bounds), [self tableView:tableView heightForHeaderInSection:section])};
    view.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = UILabel.alloc.init;
    label.text = [NSString stringWithFormat:@"共%ld个单词", self.knowledgeDataSource.count];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = TM_HexColor(0x999999);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.left.equalTo(view.mas_left).offset(12.0f);
    }];
    
    return view;
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
    self.currentIndexPath = indexPath;
    [self.tableView reloadData];
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

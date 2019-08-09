//
//  TMRelearnManager.m
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnManager.h"
#import "TMRelearnWordsListViewController.h"

@implementation TMRelearnManager

+ (instancetype)defaultManager {
    static TMRelearnManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TMRelearnManager alloc] init];
    });
    return _manager;
}

- (void)pushToRelearnListVCBy:(UINavigationController *)navigationController dataSource:(id)dataSource {
    NSAssert([navigationController isKindOfClass:UINavigationController.class], @"push");
    TMRelearnWordsListViewController *listVC = TMRelearnWordsListViewController.alloc.init;
    listVC.knowledgeDataSource = [TMRelearnKnowledgeModel mj_objectArrayWithKeyValuesArray:dataSource];
    [navigationController pushViewController:listVC animated:YES];
}

@end

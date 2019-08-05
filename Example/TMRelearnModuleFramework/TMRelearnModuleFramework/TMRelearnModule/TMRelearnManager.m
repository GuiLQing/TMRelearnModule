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

- (void)pushToRelearnListVCBy:(UINavigationController *)navigationController jsonString:(nonnull NSString *)jsonString {
    NSAssert([navigationController isKindOfClass:UINavigationController.class], @"push");
    TMRelearnWordsListViewController *listVC = TMRelearnWordsListViewController.alloc.init;
    if (jsonString && ![jsonString isEqualToString:@""]) {
        listVC.knowledgeDataSource = [TMRelearnKnowledgeModel mj_objectArrayWithKeyValuesArray:jsonString];
    }
    [navigationController pushViewController:listVC animated:YES];
}

@end

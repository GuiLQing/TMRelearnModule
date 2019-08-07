//
//  TMRelearnWordsListViewController.h
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnBaseViewController.h"
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnWordsListViewController : TMRelearnBaseViewController

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *knowledgeDataSource;

@end

NS_ASSUME_NONNULL_END

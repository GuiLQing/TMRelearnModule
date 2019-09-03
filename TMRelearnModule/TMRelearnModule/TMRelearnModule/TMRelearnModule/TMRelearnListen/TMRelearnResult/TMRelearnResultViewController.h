//
//  TMRelearnResultViewController.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "TMRelearnBaseViewController.h"
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnResultViewController : TMRelearnBaseViewController

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *knowledgeDataSource;

@property (nonatomic, assign) NSTimeInterval timeLength;

@end

NS_ASSUME_NONNULL_END

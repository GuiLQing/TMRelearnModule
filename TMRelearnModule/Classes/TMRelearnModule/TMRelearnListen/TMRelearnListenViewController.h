//
//  TMRelearnListenViewController.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnBaseViewController.h"
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnListenViewController : TMRelearnBaseViewController

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *knowledgeDataSource;

@property (nonatomic, assign) BOOL isReTraining;

@end

NS_ASSUME_NONNULL_END

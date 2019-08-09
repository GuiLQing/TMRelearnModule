//
//  TMRelearnSpeakViewController.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnBaseViewController.h"
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnSpeakViewController : TMRelearnBaseViewController

@property (nonatomic, strong) NSMutableArray<TMRelearnKnowledgeModel *> *knowledgeDataSource;

@end

NS_ASSUME_NONNULL_END

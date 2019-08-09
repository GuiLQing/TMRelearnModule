//
//  TMRelearnWordsDetailViewController.h
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnBaseViewController.h"
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnWordsDetailViewController : TMRelearnBaseViewController

@property (nonatomic, strong) TMRelearnKnowledgeModel *wordsModel; //知识点详细释义模型

@end

NS_ASSUME_NONNULL_END

//
//  TMRelearnWordsDetailCell.h
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnWordsDetailCell : UITableViewCell

@property (nonatomic, strong) TMRelearnKnowledgeExampleSentenceModel *sentenceModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) void (^voiceItemDidClicked)(NSIndexPath *indexPath);

@property (nonatomic, assign) BOOL isVoiceAnimating;

@end

NS_ASSUME_NONNULL_END

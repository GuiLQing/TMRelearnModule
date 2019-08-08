//
//  TMRelearnListenCell.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnListenCell : UICollectionViewCell

@property (nonatomic, strong) TMRelearnKnowledgeModel *model;

@property (nonatomic, copy) void (^ensureDidClicked)(void);

@property (nonatomic, copy) void (^countDownDidClicked)(void);

- (void)updateCountDownViewProgress:(CGFloat)progress;

- (void)resetCountDownView;

@end

NS_ASSUME_NONNULL_END

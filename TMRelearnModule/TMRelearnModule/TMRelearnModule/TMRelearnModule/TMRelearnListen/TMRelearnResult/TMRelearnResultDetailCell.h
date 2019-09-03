//
//  TMRelearnResultDetailCell.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnKnowledgeModel.h"

static CGFloat TMRelearnResultDetailCellHeight = 50.0f;

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnResultDetailCell : UITableViewCell

@property (nonatomic, strong) TMRelearnKnowledgeModel *model;

@end

NS_ASSUME_NONNULL_END

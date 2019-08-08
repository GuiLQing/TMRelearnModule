//
//  TMRelearnSpeakCell.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnSpeakCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) TMRelearnKnowledgeModel *knowledgeModel;

@property (nonatomic, assign) BOOL isHighlight;

@end

NS_ASSUME_NONNULL_END

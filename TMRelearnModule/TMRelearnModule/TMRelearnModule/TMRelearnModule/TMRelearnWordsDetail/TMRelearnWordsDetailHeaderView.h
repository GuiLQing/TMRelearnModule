//
//  TMRelearnWordsDetailHeaderView.h
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/7.
//  Copyright © 2019 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMRelearnKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnWordsDetailHeaderView : UIView

- (instancetype)initWithWordsModel:(TMRelearnKnowledgeModel *)wordsModel;

@property (nonatomic, copy) void (^unVoiceItemDidClicked)(NSString *voicePath);

@property (nonatomic, copy) void (^usVoiceItemDidClicked)(NSString *voicePath);

- (void)updateUnVoiceAnimation:(BOOL)isAnimation;

- (void)updateUsVoiceAnimation:(BOOL)isAnimation;

@end

NS_ASSUME_NONNULL_END

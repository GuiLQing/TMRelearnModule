//
//  TMRelearnSpeakFooterView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMRelearnSpeakFooterViewDelegate <NSObject>

@optional

- (void)startButtonDidClicked:(BOOL)isToStart;

- (void)paraphraseButtonDidClicked;;

@end

@interface TMRelearnSpeakFooterView : UIView

@property (nonatomic, weak) id<TMRelearnSpeakFooterViewDelegate> delegate;

- (void (^)(BOOL isStarted))updateStartButtonSelected;

- (void (^)(BOOL isDisabled))updateStartButtonDisabled;

- (void (^)(BOOL isDisabled))updateParaphraseButtonDisabled;

@end

NS_ASSUME_NONNULL_END

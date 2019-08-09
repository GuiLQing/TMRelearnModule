//
//  TMRelearnResultDetailFooterView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMRelearnResultDetailFooterViewDelegate <NSObject>

@optional

- (void)exitButtonDidClicked;

- (void)reTrainingButtonDidClicked;

@end

@interface TMRelearnResultDetailFooterView : UIView

@property (nonatomic, weak) id<TMRelearnResultDetailFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

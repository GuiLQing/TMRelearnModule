//
//  TMRelearnWordsListFooterView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMRelearnWordsListFooterItemType) {
    TMRelearnWordsListFooterItemTypeSpeak,
    TMRelearnWordsListFooterItemTypeListen,
    TMRelearnWordsListFooterItemTypeTest,
};

@protocol TMRelearnWordsListFooterViewDelegate <NSObject>

@optional

- (void)footerItemDidClickedAtIndex:(TMRelearnWordsListFooterItemType)index;

@end

@interface TMRelearnWordsListFooterView : UIView

@property (nonatomic, weak) id<TMRelearnWordsListFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

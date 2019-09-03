//
//  TMRelearnListenFooterView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMRelearnListenFooterItemType) {
    TMRelearnListenFooterItemTypeLast,
    TMRelearnListenFooterItemTypeNext,
};

@protocol TMRelearnListenFooterViewDelegate <NSObject>

@optional

- (void)footerItemDidClickedAtIndex:(TMRelearnListenFooterItemType)index;

@end

@interface TMRelearnListenFooterView : UIView

@property (nonatomic, weak) id<TMRelearnListenFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

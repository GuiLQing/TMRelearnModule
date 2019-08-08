//
//  TMRelearnDisplayLink.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnDisplayLink : NSObject

@property (nonatomic, copy) void (^completeCallback)(void);
@property (nonatomic, copy) void (^progressCallback)(CGFloat progress);
@property (nonatomic, copy) void (^remaindTimeIntervalCallback)(NSTimeInterval remaindTimeInterval);

- (void)restartDisplayLinkWithDuration:(NSTimeInterval)duration;

- (void)stopDisplayLink;

@end

NS_ASSUME_NONNULL_END

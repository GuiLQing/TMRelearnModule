//
//  TMRelearnManager.h
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnManager : NSObject

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *serveUrl;

+ (instancetype)defaultManager;

- (void)pushToRelearnListVCBy:(UINavigationController *)navigationController dataSource:(id)dataSource;

@property (nonatomic, copy) void (^pushToRelearnExercisesVC)(UINavigationController *navigationController, id knowledge);

@end

NS_ASSUME_NONNULL_END

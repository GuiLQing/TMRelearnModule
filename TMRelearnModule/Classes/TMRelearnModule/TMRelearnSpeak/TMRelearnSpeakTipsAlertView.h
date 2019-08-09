//
//  TMRelearnSpeakTipsAlertView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMWordsStudyTipsTriangleMode) {
    TMWordsStudyTipsTriangleModeLeft,
    TMWordsStudyTipsTriangleModeRight,
};

@interface TMRelearnSpeakTipsAlertView : UIView

+ (TMRelearnSpeakTipsAlertView *)showWordsStudyTipsAlertViewInView:(UIView *)superView tips:(NSString *)tips triangleMode:(TMWordsStudyTipsTriangleMode)triangleMode position:(CGPoint)position anchorPoint:(CGPoint)anchorPoint;

@end

NS_ASSUME_NONNULL_END

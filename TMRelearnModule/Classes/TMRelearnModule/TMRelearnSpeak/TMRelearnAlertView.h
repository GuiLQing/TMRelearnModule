//
//  TMRelearnAlertView.h
//  TMRelearnModule
//
//  Created by lg on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnAlertView : UIView

+ (TMRelearnAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message ensure:(void (^)(void))ensure cancel:(void (^)(void))cancel;

+ (TMRelearnAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message ensureTitle:(NSString *)ensureTitle cancelTitle:(NSString *)cancelTitle ensure:(void (^)(void))ensure cancel:(void (^)(void))cancel;

@end

NS_ASSUME_NONNULL_END

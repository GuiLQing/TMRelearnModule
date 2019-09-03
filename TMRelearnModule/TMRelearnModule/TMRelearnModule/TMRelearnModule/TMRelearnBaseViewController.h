//
//  TMRelearnBaseViewController.h
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnBaseViewController : UIViewController

- (void)setLoadingViewShow:(BOOL)show;
- (void)setNoDataViewShow:(BOOL)show;
- (void)setLoadErrorViewShow:(BOOL)show;

- (void)againLoadData;

@end

NS_ASSUME_NONNULL_END

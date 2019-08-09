//
//  UIImage+TMResource.h
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TMResource)

+ (UIImage *)tm_imageNamed:(NSString *)name;

+ (UIImage *)tm_imagePathName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

//
//  UIImage+TMResource.m
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "UIImage+TMResource.h"
#import "TMRelearnManager.h"

@implementation UIImage (TMResource)

+ (UIImage *)tm_imageNamed:(NSString *)name {
    name = [@"Task" stringByAppendingPathComponent:name];
    return [self tm_imagePathWithName:name bundle:@"LGTeachingMaterialFramework" targetClass:TMRelearnManager.class];
}

+ (UIImage *)tm_imagePathName:(NSString *)name {
    return [self tm_imageNamed:name];
}

+ (UIImage *)tm_imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass {
    
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *currentBundle = [NSBundle bundleForClass:targetClass];
    NSString *name = [NSString stringWithFormat:@"%@@%zdx",imageName,scale];
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundle];
    NSString *path = [currentBundle pathForResource:name ofType:@"png" inDirectory:dir];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        name = [NSString stringWithFormat:@"%@",imageName];
        path = [currentBundle pathForResource:name ofType:@"png" inDirectory:dir];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image) {
        name = [NSString stringWithFormat:@"%@@1x",imageName];
        path = [currentBundle pathForResource:name ofType:@"png" inDirectory:dir];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image) {
        name = [NSString stringWithFormat:@"%@@2x",imageName];
        path = [currentBundle pathForResource:name ofType:@"png" inDirectory:dir];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image) {
        name = [NSString stringWithFormat:@"%@@3x",imageName];
        path = [currentBundle pathForResource:name ofType:@"png" inDirectory:dir];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

@end

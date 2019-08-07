//
//  UIImage+TMResource.m
//  TMRelearnModule
//
//  Created by 彭石桂 on 2019/8/8.
//  Copyright © 2019 GUI. All rights reserved.
//

#import "UIImage+TMResource.h"

@implementation NSBundle (AP_Resource)

+ (instancetype)tm_defaultBundle {
    static NSBundle *_defaultBundle = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _defaultBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"TMRelearnManager")] pathForResource:@"TMRelearnModule" ofType:@"bundle"]];
    });
    return _defaultBundle;
}

+ (NSString *)tm_bundlePathWithName:(NSString *)name {
    return [NSBundle.tm_defaultBundle.resourcePath stringByAppendingPathComponent:name];
}

@end

@implementation UIImage (TMResource)

+ (UIImage *)tm_imageNamed:(NSString *)name {
    NSString *namePath = name;
    return [UIImage imageNamed:[NSBundle ap_bundlePathWithName:namePath]];
}

+ (UIImage *)tm_imagePathName:(NSString *)name {
    NSString *namePath = name;
    return [UIImage imageWithContentsOfFile:[NSBundle ap_bundlePathWithName:namePath]];
}

@end

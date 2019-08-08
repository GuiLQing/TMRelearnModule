//
//  TMRelearnMacros.h
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#ifndef TMRelearnMacros_h
#define TMRelearnMacros_h

//判断iPhone X系列
#define TM_IS_IPHONEX \
^(){\
BOOL iPhoneX = NO;\
if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
return iPhoneX;\
}\
if (@available(iOS 11.0, *)) {\
UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];\
if (mainWindow.safeAreaInsets.bottom > 0.0) {\
iPhoneX = YES;\
}\
}\
return iPhoneX;\
}()

#define TM_SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define TM_SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

//状态栏、导航栏高度
#define TM_STATUS_NEAT_BANG_HEIGHT (TM_IS_IPHONEX ? 24 : 0)    //齐刘海高度
#define TM_STATUS_BAR_HEIGHT (TM_IS_IPHONEX ? 44 : 20)
#define TM_NAVIGATION_BAR_HEIGHT (44)
#define TM_STATUS_AND_NAVIGATION_BAR_HEIGHT ((TM_STATUS_BAR_HEIGHT) + (TM_NAVIGATION_BAR_HEIGHT))

//底部栏高度
#define TM_TABBAR_HEIGHT (TM_IS_IPHONEX ? 83 : 49)
// 底部安全区域远离高度
#define TM_BOTTOM_SAFE_HEIGHT   (CGFloat)(TM_IS_IPHONEX ? (34) : (0))
//iPhone X底部home键高度
#define TM_BOTTOM_HOME_HEIGHT   (CGFloat)(TM_IS_IPHONEX ? (10) : (0))

#define TM_IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define TM_IsObjEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define TM_HandleParams(_ref)  (TM_IsObjEmpty(_ref) ? @"" : _ref)

#define TM_HexColor(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]

static inline NSString * TMFilterHTML(NSString *htmlString) {
    NSString *string = htmlString;
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
}

#endif /* TMRelearnMacros_h */

//
//  TMRelearnMacros.h
//  TMRelearnModuleFramework
//
//  Created by lg on 2019/8/6.
//  Copyright © 2019 lg. All rights reserved.
//

#ifndef TMRelearnMacros_h
#define TMRelearnMacros_h

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

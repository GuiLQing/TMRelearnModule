//
//  TMRelearnKnowledgeModel.m
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnKnowledgeModel.h"

@implementation TMRelearnKnowledgeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cxCollection" : NSStringFromClass(TMRelearnKnowledgeParaphraseModel.class)};
}

@end

@implementation TMRelearnKnowledgeParaphraseModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"meanCollection" : NSStringFromClass(TMRelearnKnowledgeDetailParaphraseModel.class)};
}

@end

@implementation TMRelearnKnowledgeDetailParaphraseModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"senCollection" : NSStringFromClass(TMRelearnKnowledgeExampleSentenceModel.class)};
}

@end

@implementation TMRelearnKnowledgeExampleSentenceModel

@end

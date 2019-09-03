//
//  TMRelearnKnowledgeModel.h
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMWordsStatus) {
    TMWordsStatusNormal,
    TMWordsStatusPassed,
    TMWordsStatusNotPass,
};

@interface TMRelearnKnowledgeModel : NSObject

/** 知识点 编码 */
@property (nonatomic, copy) NSString *cwCode;
/** 知识点 名称 */
@property (nonatomic, copy) NSString *cwName;
/** 英式 意思 */
@property (nonatomic, copy) NSString *unPText;
/** 英式发音 */
@property (nonatomic, copy) NSString *unPVoice;
/** 美式 意思 */
@property (nonatomic, copy) NSString *usPText;
/** 美式发音 */
@property (nonatomic, copy) NSString *usPVoice;
/** 中文释义简要 */
@property (nonatomic, copy) NSString *cxSPmean;
/** 各个解析 */
@property (nonatomic, strong) NSArray *cxCollection;

@property (nonatomic, assign) TMWordsStatus status;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) NSString *stuAnswer;

@end

@interface TMRelearnKnowledgeParaphraseModel : NSObject

/** 意思 */
@property (nonatomic, copy) NSString *cxChinese;
/** 英文 */
@property (nonatomic, copy) NSString *cxEnglish;

@property (nonatomic, copy) NSString *morphology;

@property (nonatomic, strong) NSArray *meanCollection;

@end

@interface TMRelearnKnowledgeDetailParaphraseModel : NSObject

/** 中文意思 */
@property (nonatomic, copy) NSString *chineseMeaning;
/** 英文意思 */
@property (nonatomic, copy) NSString *englishMeaning;
/** 句子释义 */
@property (nonatomic, strong) NSArray *senCollection;

@property (nonatomic, strong) NSArray *coltCollection;

@property (nonatomic, strong) NSArray *rltCollection;

@property (nonatomic, strong) NSArray *classicCollection;

@property (nonatomic, strong) NSArray *baikeCollection;

@end

@interface TMRelearnKnowledgeExampleSentenceModel : NSObject

@property (nonatomic, copy) NSString *sentenceEn;

@property (nonatomic, copy) NSString *sTranslation;

@property (nonatomic, copy) NSString *sViocePath;

@end

NS_ASSUME_NONNULL_END

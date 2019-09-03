//
//  TMRelearnRequest.h
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMRelearnRequest : NSObject

+ (void)tm_DecryptPostRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

+ (void)tm_DecryptPostRequestWithPath:(NSString *)path params:(NSDictionary *)params serverAddress:(NSString * _Nullable)serverAddress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

+ (void)tm_DecryptGetRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

+ (void)tm_DecryptGetRequestWithPath:(NSString *)path params:(NSDictionary *)params serverAddress:(NSString * _Nullable)serverAddress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end

@interface TMRelearnRequest (Request)

+ (void)tm_requestKnowledgeCoursewareListWithKnowledgeCode:(NSString *)knowledgeCode success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

+ (void)tm_requestSingleKnowledgeCoursewareWithKnowledge:(NSString *)knowledge success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

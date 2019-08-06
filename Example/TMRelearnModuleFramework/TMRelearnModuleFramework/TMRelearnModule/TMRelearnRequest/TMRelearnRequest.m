//
//  TMRelearnRequest.m
//  LGAfterschoolPlanFramework
//
//  Created by lg on 2019/8/5.
//  Copyright © 2019 lg. All rights reserved.
//

#import "TMRelearnRequest.h"
#import <YJNetManager/YJNetManager.h>
#import "TMRelearnManager.h"
#import "TMRelearnMacros.h"

@implementation TMRelearnRequest

+ (void)tm_DecryptPostRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self tm_DecryptPostRequestWithPath:path params:params serverAddress:nil success:success failure:failure];
}

+ (void)tm_DecryptPostRequestWithPath:(NSString *)path params:(NSDictionary *)params serverAddress:(NSString * _Nullable)serverAddress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    if (!serverAddress || ![serverAddress isEqualToString:@""]) {
        serverAddress = [TMRelearnManager defaultManager].serveUrl;
    }
    path = [serverAddress stringByAppendingPathComponent:path];
    [YJNetManager.defaultManager
     .setRequest(path)
     .setParameters(params).
     setRequestType(YJRequestTypeMD5POST) startRequestWithSuccess:^(id  _Nonnull response) {
         [self et_requestSuccessWithDataTask:nil responseObject:response serverAddress:serverAddress path:path params:nil success:success failure:failure];
     } failure:^(NSError * _Nonnull error) {
         if (failure) failure(error);
     }];
}

+ (void)tm_DecryptGetRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self tm_DecryptGetRequestWithPath:path params:params serverAddress:nil success:success failure:failure];
}

+ (void)tm_DecryptGetRequestWithPath:(NSString *)path params:(NSDictionary *)params serverAddress:(NSString * _Nullable)serverAddress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    if (!serverAddress || ![serverAddress isEqualToString:@""]) {
        serverAddress = [TMRelearnManager defaultManager].serveUrl;
    }
    path = [serverAddress stringByAppendingPathComponent:path];
    [YJNetManager.defaultManager
     .setRequest(path)
     .setParameters(params).
     setRequestType(YJRequestTypeMD5GET) startRequestWithSuccess:^(id  _Nonnull response) {
         [self et_requestSuccessWithDataTask:nil responseObject:response serverAddress:serverAddress path:path params:nil success:success failure:failure];
     } failure:^(NSError * _Nonnull error) {
         if (failure) failure(error);
     }];
}

+ (void)et_requestSuccessWithDataTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject serverAddress:(NSString *)address path:(NSString *)path params:(NSDictionary *)params success:(void (^)(id response))success failure:(void(^)(NSError *error))failure {
    NSError *error = nil;
    id json = nil;
    BOOL isValidJSONObject = [NSJSONSerialization isValidJSONObject:responseObject];
    if (isValidJSONObject) {
        json = [responseObject copy];
    } else {
        if (responseObject) {
            json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        }
    }
    
    if (success && !error && ([[json allKeys] containsObject:@"Status"] && ([json[@"Status"] integerValue] == 1 || [json[@"Status"] integerValue] == 0))) {
        success(json);
    } else if (failure) {
        failure(error);
    }
}

@end

@implementation TMRelearnRequest (Request)

+ (void)tm_requestKnowledgeCoursewareListWithKnowledgeCode:(NSString *)knowledgeCode success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{
                             @"knowledgeCode" : TM_HandleParams(knowledgeCode),
                             };
    [self tm_DecryptPostRequestWithPath:@"FreeStudyCloudApi/DecryptResources/GetCoursewareList" params:params serverAddress:TMRelearnManager.defaultManager.serveUrl success:success failure:failure];
}

+ (void)tm_requestSingleKnowledgeCoursewareWithKnowledge:(NSString *)knowledge success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{
                             @"knowledge" : TM_HandleParams(knowledge),
                             @"levelCode" : @"",
                             @"UserID" : TM_HandleParams(TMRelearnManager.defaultManager.userID),
                             };
    [self tm_DecryptGetRequestWithPath:@"FreeStudyCloudApi/DecryptResources/GetCourseware" params:params serverAddress:TMRelearnManager.defaultManager.serveUrl success:success failure:failure];
}

@end

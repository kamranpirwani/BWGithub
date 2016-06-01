//
//  BWProviderUtils.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWProviderUtils.h"

@implementation BWProviderUtils

+ (NSOperationQueue *)networkingSerialQueue {
    static NSOperationQueue *serialQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = [[NSOperationQueue alloc] init];
        serialQueue.maxConcurrentOperationCount = 1;
    });
    return serialQueue;
}

+ (AFHTTPSessionManager *)defaultHttpSessionManager {
    static AFHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        [sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"kamranpirwani" password:@"5eb7ba0f8ed014623dcdf82cc9a953cdf4cf922a"];
        [sessionManager.requestSerializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    });
    return sessionManager;
}

@end

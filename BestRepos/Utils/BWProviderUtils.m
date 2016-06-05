//
//  BWProviderUtils.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWProviderUtils.h"
#import "BWUtils.h"
#import "BWGithubAuthCredentials.h"

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
        BWGithubAuthCredentials *authCredentials = [[BWGithubAuthCredentials alloc] init];
        [sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:authCredentials.username password:authCredentials.password];
        //We specify to use the GitHub v3 API in the event they change the API in the future
        [sessionManager.requestSerializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    });
    return sessionManager;
}

@end

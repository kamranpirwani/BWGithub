//
//  BWAppController.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWAppController.h"
#import "BWGithubProviderProtocol.h"
#import "BWGithubProvider.h"
#import "BWGithubMockProvider.h"
#import "BWServiceLocator.h"
#import "BWProviderUtils.h"
#import <AFNetworking.h>

#define ENABLE_MOCK_PROVIDER 0

@implementation BWAppController

+ (void)initializeApplication {
    [self initalizeProviders];
}

+ (void)initalizeProviders {
    id<BWGithubProviderProtocol> githubProvider = nil;
#if ENABLE_MOCK_PROVIDER && DEBUG
    githubProvider = [[BWGithubMockProvider alloc] init];
#else
    githubProvider = [[BWGithubProvider alloc] initWithQueue:[BWProviderUtils networkingSerialQueue]];
#endif
    [[BWServiceLocator sharedInstance] addService:githubProvider withProtocol:@protocol(BWGithubProviderProtocol)];
}

@end

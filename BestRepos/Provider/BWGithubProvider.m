//
//  BWGithubProvider.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubProvider.h"
#import "BWGithubParser.h"
#import "BWUtils.h"
#import "BWGithubRepositoryModel_Internal.h"
#import "BWGithubContributorModel.h"

static NSString *BWGithubProviderQueryKey = @"q";
static NSString *BWGithubProviderSortKey = @"sort";
static NSString *BWGithubProviderOrderKey = @"order";
static NSString *BWGithubProviderPerPageKey = @"per_page";

static NSInteger const kBWGithubProviderPerPageCount = 100;

@implementation BWGithubProvider

- (void)searchForRepositoryWithQuery:(BWGithubSearchQuery *)searchQuery
                            callback:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    
    BOOL validParamaters = (searchQuery != nil && callback != nil);
    [BWUtils assertCondition:validParamaters
                     message:@"The search query and callback must be non-nil"
                       class:[self class] method:_cmd];
    //exit early in production
    if (!validParamaters) {
        return;
    }
    
    NSString *requestMethod = @"GET";
    NSString *path = @"https://api.github.com/search/repositories";
    
    NSString *defaultSearchQuery = @"stars:>=0";
    NSString *searchQueryString = nil;
    
    if (searchQuery.keywords.length > 0) {
        searchQueryString = searchQuery.keywords;
    } else {
        searchQueryString = defaultSearchQuery;
    }
    
    NSDictionary *params = @{
                             BWGithubProviderQueryKey : searchQueryString,
                             BWGithubProviderSortKey : searchQuery.sortFieldString,
                             BWGithubProviderOrderKey : searchQuery.sortOrderString,
                             BWGithubProviderPerPageKey :  @(kBWGithubProviderPerPageCount)
                             };
    
    [self requestWithMethod:requestMethod
                       path:path
                 parameters:params
                   callback:^(id response, NSError *error) {
                       NSArray<BWGithubRepositoryModel *> *repositories = nil;
                       if (!error) {
                           repositories = [BWGithubParser handleGetMostPopularRepositories:response];
                       }
                       if (callback) {
                           callback(error, repositories);
                       }
                   }];
}

- (void)getTopContributorsFromRepository:(BWGithubRepositoryModel *)repository
                                callback:(void(^)(NSError *error, NSArray<BWGithubContributorModel *> *contributors))callback {
    
    [BWUtils assertCondition:(callback != nil)
                     message:@"The callback must be non-nil"
                       class:[self class] method:_cmd];
    
    NSString *requestMethod = @"GET";
    NSString *path = repository.contributorsUrl;
    NSDictionary *params = nil;
    
    [self requestWithMethod:requestMethod
                       path:path
                 parameters:params
                   callback:^(id response, NSError *error) {
                       NSArray<BWGithubContributorModel *> *contributors = nil;
                       if (!error) {
                           contributors = [BWGithubParser handleGetTopContributorsFromRepository:response];
                       }
                       if (callback) {
                           callback(error, contributors);
                       }
                   }];
}

- (void)getUserProfileFromBarebonesUserModel:(BWGithubBarebonesUserModel *)user
                                    callback:(void (^)(NSError *error, BWGithubUserModel *completeUser))callback {
    [BWUtils assertCondition:(callback != nil)
                     message:@"The callback must be non-nil"
                       class:[self class] method:_cmd];
    
    NSString *requestMethod = @"GET";
    NSString *path = user.profileUrl;
    NSDictionary *params = nil;
    
    [self requestWithMethod:requestMethod
                       path:path
                 parameters:params
                   callback:^(id response, NSError *error) {
                       BWGithubUserModel *completeUser = nil;
                       if (!error) {
                           completeUser = [BWGithubParser handleGetUserProfileFromBarebonesUserModel:response];
                       }
                       if (callback) {
                           callback(error, completeUser);
                       }
                   }];
}

@end

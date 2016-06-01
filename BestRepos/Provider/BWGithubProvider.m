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


@implementation BWGithubProvider

- (void)getMostPopularRepositoriesAndTheirTopContributors:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    __weak typeof(self) weakSelf = self;
    [self getMostPopularRepositories:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        //dispatch back to the background thread
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_group_t serviceGroup = dispatch_group_create();
            
            for (BWGithubRepositoryModel *repository in repositories) {
                //increment task
                dispatch_group_enter(serviceGroup);
                [weakSelf getTopContributorsFromRepository:repository callback:^(NSError *error, NSArray<BWGithubContributorModel *> *contributors) {
                    //decrement task
                    dispatch_group_leave(serviceGroup);
                    repository.topContributors = contributors;
                }];
            }
            //wait until all of our network calls have completed
            dispatch_group_wait(serviceGroup,DISPATCH_TIME_FOREVER);
            //dispatch back to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(error, repositories);
                }
            });
        });
    }];
}

- (void)getMostPopularRepositories:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    
    [BWUtils assertCondition:(callback != nil)
                     message:@"The callback must be non-nil"
                       class:[self class] method:_cmd];
    
    NSString *requestMethod = @"GET";
    NSString *path = @"https://api.github.com/search/repositories";
    NSDictionary *params = @{
                             BWGithubProviderQueryKey : @"stars:>1",
                             BWGithubProviderSortKey : @"stars",
                             BWGithubProviderOrderKey : @"desc"
                             };
    
    [self requestWithMethod:requestMethod
                       path:path
                 parameters:params
                   callback:^(id response, NSError *error) {
                       NSArray<BWGithubRepositoryModel *> *repositories = nil;
                       if (!error) {
                           repositories = [BWGithubParser handleMostPopularRepositoriesFetch:response];
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
                           contributors = [BWGithubParser handleTopContributorsFromRepositoryFetch:response];
                       }
                       if (callback) {
                           callback(error, contributors);
                       }
                   }];
}


@end

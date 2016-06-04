//
//  BWGithubService.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubService.h"
#import "BWGithubProviderProtocol.h"
#import "BWServiceLocator.h"
#import "BWUtils.h"
#import "BWGithubRepositoryModel_Internal.h"
#import "BWGithubContributorModel.h"

typedef NS_ENUM(NSInteger, BWGithubServiceErrorCode) {
    kBWGithubServiceErrorCodeUnauthorized = -1101
};

@implementation BWGithubService {
    id<BWGithubProviderProtocol> _provider;
}

static BWGithubService *_singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[BWGithubService alloc] init];
    });
    return _singleton;
}

#pragma mark - Designated Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        _provider = [[BWServiceLocator sharedInstance] getServiceWithProtocol:@protocol(BWGithubProviderProtocol)];
    }
    return self;
}

#pragma mark - Pubic API

- (void)searchForRepositoryWithQuery:(BWGithubSearchQuery *)searchQuery
                            callback:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    __weak typeof(self) weakSelf = self;
    [_provider searchForRepositoryWithQuery:searchQuery callback:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        //exit out early if there's an error
        if (error) {
            if (callback) {
                callback(error, nil);
                return;
            }
        }
        [weakSelf handleTopContributorAggegationWithError:error repositories:repositories andCallback:callback];
    }];
}

- (void)getUserProfileFromBarebonesUserModel:(BWGithubBarebonesUserModel *)user
                                    callback:(void (^)(NSError *error, BWGithubUserModel *completeUser))callback {
    [_provider getUserProfileFromBarebonesUserModel:user callback:callback];
}

#pragma mark - Private API

- (void)handleTopContributorAggegationWithError:(NSError *)error
                                   repositories:(NSArray<BWGithubRepositoryModel *> *)repositories
                                    andCallback:(void(^)())callback {
    /**
     * Dispatch back to the background thread to retrieve the remaining top contributors
     * Additionally, we don't want to block the main thread, as the dispatch group will
     * block the thread until we have finished our operation
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self populateAllRepositoriesWithTopContributors:repositories withCallback:^{
            //dispatch back to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(error, repositories);
                }
            });
        }];
    });
}

- (void)populateAllRepositoriesWithTopContributors:(NSArray<BWGithubRepositoryModel *> *)repositories withCallback:(void(^)())callback {
    //create a group to keep track of all our tasks
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    for (BWGithubRepositoryModel *repository in repositories) {
        //increment task
        dispatch_group_enter(serviceGroup);
        [_provider getTopContributorsFromRepository:repository callback:^(NSError *error, NSArray<BWGithubContributorModel *> *contributors) {
            //decrement task
            dispatch_group_leave(serviceGroup);
            repository.topContributors = contributors;
        }];
    }
    
    //wait until all of our network calls have completed
    dispatch_group_wait(serviceGroup,DISPATCH_TIME_FOREVER);
    if (callback) {
        callback();
    }
}

- (NSString *)getStringFromErrorCode:(BWGithubServiceErrorCode)errorCode {
    NSString *errorReason = nil;
    switch (errorCode) {
        case kBWGithubServiceErrorCodeUnauthorized:
            errorReason = @"You must provide a valid username and password in ";
            break;
            
        default:
            break;
    }
    
    return errorReason;
}

@end

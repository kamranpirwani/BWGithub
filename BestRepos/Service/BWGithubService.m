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

- (instancetype)init {
    self = [super init];
    if (self) {
        _provider = [[BWServiceLocator sharedInstance] getServiceWithProtocol:@protocol(BWGithubProviderProtocol)];
    }
    return self;
}

- (void)getMostPopularRepositoriesAndTheirTopContributors:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    __weak typeof(_provider) weakProvider = _provider;
    [_provider getMostPopularRepositories:^(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories) {
        //dispatch back to the background thread
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_group_t serviceGroup = dispatch_group_create();
            
            for (BWGithubRepositoryModel *repository in repositories) {
                //increment task
                dispatch_group_enter(serviceGroup);
                [weakProvider getTopContributorsFromRepository:repository callback:^(NSError *error, NSArray<BWGithubContributorModel *> *contributors) {
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

@end

//
//  BWGithubMockProvider.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubMockProvider.h"
#import "BWUtils.h"
#import "BWGithubParser.h"

@implementation BWGithubMockProvider

- (void)getMostPopularRepositories:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback {
    
    [BWUtils assertCondition:(callback != nil)
                     message:@"The callback must be non-nil"
                       class:[self class] method:_cmd];
    
    NSDictionary *jsonDictionary = [BWUtils dictionaryFromJSONFileNamed:@"GET_most_starred_repositories"];
    NSArray<BWGithubRepositoryModel *> *repositories = nil;
    if (jsonDictionary) {
        repositories = [BWGithubParser handleMostPopularRepositoriesFetch:jsonDictionary];
    }
    
    if (callback) {
        callback(nil, repositories);
    }
}

- (void)getTopContributorsFromRepository:(BWGithubRepositoryModel *)repository
                                callback:(void(^)(NSError *error, NSArray<BWGithubContributorModel *> *contributors))callback {
    
    [BWUtils assertCondition:(callback != nil)
                     message:@"The callback must be non-nil"
                       class:[self class] method:_cmd];
    
    NSDictionary *jsonDictionary = [BWUtils dictionaryFromJSONFileNamed:@"GET_top_contributors"];
    NSArray<BWGithubContributorModel *> *contributors = nil;
    if (jsonDictionary) {
        contributors = [BWGithubParser handleTopContributorsFromRepositoryFetch:jsonDictionary];
    }
    
    if (callback) {
        callback(nil, contributors);
    }
}

@end

//
//  BWGithubParser.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubParser.h"
#import "BWGitHubRepositoryModel_Internal.h"
#import "BWGithubBarebonesUserModel_Internal.h"
#import "BWGithubContributorModel_Internal.h"

@implementation BWGithubParser

static NSString *const kBWGithubParserCommonIdKey = @"id";
static NSString *const kBWGithubParserCommonLoginKey = @"login";
static NSString *const kBWGithubParserCommonAvatarUrlKey = @"avatar_url";

static NSString *const kBWGithubParserRepositoryItemKey = @"items";
static NSString *const kBWGithubParserRepositoryOwnerKey = @"owner";
static NSString *const kBWGithubParserRepositoryNameKey = @"name";
static NSString *const kBWGithubParserRepositoryFullNameKey = @"full_name";
static NSString *const kBWGithubParserRepositoryHtmlUrlKey = @"html_url";
static NSString *const kBWGithubParserRepositoryProjectDescriptionKey = @"description";
static NSString *const kBWGithubParserRepositoryContributorsUrlKey = @"contributors_url";
static NSString *const kBWGithubParserRepositoryForkCountKey = @"forks";
static NSString *const kBWGithubParserRepositoryStarredCountKey = @"stargazers_count";
static NSString *const kBWGithubParserRepositoryWatchedCountKey = @"watchers_count";

static NSString *const kBWGithubParserContributorContributionsKey = @"contributions";


+ (NSArray<BWGithubRepositoryModel *> *)handleMostPopularRepositoriesFetch:(NSDictionary *)response {
    if (!response) {
        return nil;
    }
    //TODO: Add type checking

    NSMutableArray<BWGithubRepositoryModel *> *repositoriesArray = [NSMutableArray array];
    
    NSArray *repositories = [response objectForKey:kBWGithubParserRepositoryItemKey];
    for (NSDictionary *repositoryDictionary in repositories) {
        BWGithubRepositoryModel *repositoryModel = [[BWGithubRepositoryModel alloc] init];

        NSUInteger identifier = [[repositoryDictionary objectForKey:kBWGithubParserCommonIdKey] integerValue];
        repositoryModel.identifier = identifier;
        
        BWGithubBarebonesUserModel *owner = [[BWGithubBarebonesUserModel alloc] init];
        NSDictionary *ownerDictionary = [repositoryDictionary objectForKey:kBWGithubParserRepositoryOwnerKey];
        [self hydrateUserModel:owner fromResponse:ownerDictionary];
        repositoryModel.owner = owner;
        
        NSString *name = [repositoryDictionary objectForKey:kBWGithubParserRepositoryNameKey];
        repositoryModel.name = name;
        
        NSString *fullName = [repositoryDictionary objectForKey:kBWGithubParserRepositoryFullNameKey];
        repositoryModel.fullName = fullName;
        
        NSString *htmlUrl = [repositoryDictionary objectForKey:kBWGithubParserRepositoryHtmlUrlKey];
        repositoryModel.htmlUrl = htmlUrl;
        
        NSString *projectDescription = [repositoryDictionary objectForKey:kBWGithubParserRepositoryProjectDescriptionKey];
        repositoryModel.projectDescription = projectDescription;
        
        NSString *contributorsUrl = [repositoryDictionary objectForKey:kBWGithubParserRepositoryContributorsUrlKey];
        repositoryModel.contributorsUrl = contributorsUrl;
        
        NSUInteger forkCount = [[repositoryDictionary objectForKey:kBWGithubParserRepositoryForkCountKey] integerValue];
        repositoryModel.forkCount = forkCount;
        
        NSUInteger starredCount = [[repositoryDictionary objectForKey:kBWGithubParserRepositoryStarredCountKey] integerValue];
        repositoryModel.starredCount = starredCount;
        
        NSUInteger watchersCount = [[repositoryDictionary objectForKey:kBWGithubParserRepositoryWatchedCountKey] integerValue];
        repositoryModel.watchersCount = watchersCount;
        
        [repositoriesArray addObject:repositoryModel];
    }

    return repositoriesArray;
}

+ (NSArray<BWGithubContributorModel *> *)handleTopContributorsFromRepositoryFetch:(NSArray *)response {
    if (!response) {
        return nil;
    }
    
    //TODO: Add type checking
    
    NSMutableArray<BWGithubContributorModel *> *contributorsArray = [NSMutableArray array];

    for (NSDictionary *contributorDictionary in response) {
        BWGithubContributorModel *contributorModel = [[BWGithubContributorModel alloc] init];
        [self hydrateUserModel:contributorModel fromResponse:contributorDictionary];
        NSUInteger contributions = [[contributorDictionary objectForKey:kBWGithubParserContributorContributionsKey] integerValue];
        contributorModel.contributions = contributions;
        [contributorsArray addObject:contributorModel];
    }

    return contributorsArray;
}

+ (void)hydrateUserModel:(BWGithubBarebonesUserModel *)userModel fromResponse:(NSDictionary *)ownerDictionary {
    //TODO: Add type checking
    NSUInteger identifier = [[ownerDictionary objectForKey:kBWGithubParserCommonIdKey] integerValue];
    userModel.identifier = identifier;

    NSString *login = [ownerDictionary objectForKey:kBWGithubParserCommonLoginKey];
    userModel.login = login;

    NSString *avatarUrl = [ownerDictionary objectForKey:kBWGithubParserCommonAvatarUrlKey];
    userModel.avatarUrl = avatarUrl;
    
}


@end

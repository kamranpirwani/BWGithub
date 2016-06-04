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
#import "NSDictionary+BWTypeValidation.h"
#import "BWGithubUserModel_Internal.h"

@implementation BWGithubParser

static NSString *const kBWGithubParserCommonIdKey = @"id";
static NSString *const kBWGithubParserCommonLoginKey = @"login";
static NSString *const kBWGithubParserCommonAvatarUrlKey = @"avatar_url";
static NSString *const kBWGithubParserCommonUrlKey = @"url";
static NSString *const kBWGithubParserCommonNameKey = @"name";

static NSString *const kBWGithubParserRepositoryItemKey = @"items";
static NSString *const kBWGithubParserRepositoryOwnerKey = @"owner";
static NSString *const kBWGithubParserRepositoryFullNameKey = @"full_name";
static NSString *const kBWGithubParserRepositoryHtmlUrlKey = @"html_url";
static NSString *const kBWGithubParserRepositoryProjectDescriptionKey = @"description";
static NSString *const kBWGithubParserRepositoryContributorsUrlKey = @"contributors_url";
static NSString *const kBWGithubParserRepositoryForkCountKey = @"forks";
static NSString *const kBWGithubParserRepositoryStarredCountKey = @"stargazers_count";
static NSString *const kBWGithubParserRepositoryLanguageKey = @"language";

static NSString *const kBWGithubParserContributorContributionsKey = @"contributions";

static NSString *const kBWGithubParserUserTypeKey = @"type";
static NSString *const kBWGithubParserUserPublicRepositoriesKey = @"public_repos";
static NSString *const kBWGithubParserUserFollowersKey = @"followers";
static NSString *const kBWGithubParserUserFollowingKey = @"following";
static NSString *const kBWGithubParserUserLocationKey = @"location";
static NSString *const kBWGithubParserUserBioKey = @"bio";


+ (NSArray<BWGithubRepositoryModel *> *)handleGetMostPopularRepositories:(NSDictionary *)response {
    if (!response) {
        return nil;
    }

    NSMutableArray<BWGithubRepositoryModel *> *repositoriesArray = [NSMutableArray array];
    
    NSArray *repositories = [response getArrayForKey:kBWGithubParserRepositoryItemKey defaultValue:nil];
    for (NSDictionary *repositoryDictionary in repositories) {
        BWGithubRepositoryModel *repositoryModel = [[BWGithubRepositoryModel alloc] init];

        NSUInteger identifier = [[repositoryDictionary getNumberForKey:kBWGithubParserCommonIdKey defaultValue:nil] integerValue];
        repositoryModel.identifier = identifier;
        
        BWGithubBarebonesUserModel *owner = [[BWGithubBarebonesUserModel alloc] init];
        NSDictionary *ownerDictionary = [repositoryDictionary getDictionaryForKey:kBWGithubParserRepositoryOwnerKey defaultValue:nil];
        [self hydrateUserModel:owner fromResponse:ownerDictionary];
        repositoryModel.owner = owner;
        
        NSString *name = [repositoryDictionary getStringForKey:kBWGithubParserCommonNameKey defaultValue:nil];
        repositoryModel.name = name;
        
        NSString *fullName = [repositoryDictionary getStringForKey:kBWGithubParserRepositoryFullNameKey defaultValue:nil];
        repositoryModel.fullName = fullName;
        
        NSString *htmlUrl = [repositoryDictionary getStringForKey:kBWGithubParserRepositoryHtmlUrlKey defaultValue:nil];
        repositoryModel.htmlUrl = htmlUrl;
        
        NSString *projectDescription = [repositoryDictionary getStringForKey:kBWGithubParserRepositoryProjectDescriptionKey defaultValue:nil];
        repositoryModel.projectDescription = projectDescription;
        
        NSString *contributorsUrl = [repositoryDictionary getStringForKey:kBWGithubParserRepositoryContributorsUrlKey defaultValue:nil];
        repositoryModel.contributorsUrl = contributorsUrl;
        
        NSUInteger forkCount = [[repositoryDictionary getNumberForKey:kBWGithubParserRepositoryForkCountKey defaultValue:nil] integerValue];
        repositoryModel.forkCount = forkCount;
        
        NSUInteger starredCount = [[repositoryDictionary getNumberForKey:kBWGithubParserRepositoryStarredCountKey defaultValue:nil] integerValue];
        repositoryModel.starredCount = starredCount;
        
        NSString *language = [repositoryDictionary getStringForKey:kBWGithubParserRepositoryLanguageKey defaultValue:nil];
        repositoryModel.language = language;
        
        [repositoriesArray addObject:repositoryModel];
    }

    return repositoriesArray;
}

+ (NSArray<BWGithubContributorModel *> *)handleGetTopContributorsFromRepository:(NSArray *)response {
    if (!response) {
        return nil;
    }
    
    NSMutableArray<BWGithubContributorModel *> *contributorsArray = [NSMutableArray array];

    for (NSDictionary *contributorDictionary in response) {
        BWGithubContributorModel *contributorModel = [[BWGithubContributorModel alloc] init];
        [self hydrateUserModel:contributorModel fromResponse:contributorDictionary];
        NSUInteger contributions = [[contributorDictionary getNumberForKey:kBWGithubParserContributorContributionsKey defaultValue:nil] integerValue];
        contributorModel.contributions = contributions;
        [contributorsArray addObject:contributorModel];
    }

    return contributorsArray;
}

+ (void)hydrateUserModel:(BWGithubBarebonesUserModel *)userModel fromResponse:(NSDictionary *)ownerDictionary {
    NSUInteger identifier = [[ownerDictionary getNumberForKey:kBWGithubParserCommonIdKey defaultValue:nil] integerValue];
    userModel.identifier = identifier;

    NSString *login = [ownerDictionary getStringForKey:kBWGithubParserCommonLoginKey defaultValue:nil];
    userModel.login = login;

    NSString *avatarUrl = [ownerDictionary getStringForKey:kBWGithubParserCommonAvatarUrlKey defaultValue:nil];
    userModel.avatarUrl = avatarUrl;
    
    NSString *profileUrl = [ownerDictionary getStringForKey:kBWGithubParserCommonUrlKey defaultValue:nil];
    userModel.profileUrl = profileUrl;
}

+ (BWGithubUserModel *)handleGetUserProfileFromBarebonesUserModel:(NSDictionary *)response {
    if (!response) {
        return nil;
    }
    
    BWGithubUserModel *userModel = [[BWGithubUserModel alloc] init];
    [self hydrateUserModel:userModel fromResponse:response];
    
    NSString *type = [response getStringForKey:kBWGithubParserUserTypeKey defaultValue:nil];
    userModel.type = type;
    
    NSString *name = [response getStringForKey:kBWGithubParserCommonNameKey defaultValue:nil];
    userModel.name = name;
    
    NSUInteger numberOfPublicRepositories = [[response getNumberForKey:kBWGithubParserUserPublicRepositoriesKey defaultValue:nil] integerValue];
    userModel.numberOfPublicRepositories = numberOfPublicRepositories;
    
    NSUInteger followers = [[response getNumberForKey:kBWGithubParserUserFollowersKey defaultValue:nil] integerValue];
    userModel.followers = followers;
    
    NSUInteger following = [[response getNumberForKey:kBWGithubParserUserFollowingKey defaultValue:nil] integerValue];
    userModel.following = following;
    
    NSString *location = [response getStringForKey:kBWGithubParserUserLocationKey defaultValue:nil];
    userModel.location = location;
    
    NSString *bio = [response getStringForKey:kBWGithubParserUserBioKey defaultValue:nil];
    userModel.bio = bio;
    
    
    return userModel;
}

@end

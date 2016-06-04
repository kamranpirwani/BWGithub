//
//  BWGithubParser.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWGithubRepositoryModel;
@class BWGithubContributorModel;
@class BWGithubUserModel;

@interface BWGithubParser : NSObject

+ (NSArray<BWGithubRepositoryModel *> *)handleGetMostPopularRepositories:(NSDictionary *)response;
+ (NSArray<BWGithubContributorModel *> *)handleGetTopContributorsFromRepository:(NSDictionary *)response;
+ (BWGithubUserModel *)handleGetUserProfileFromBarebonesUserModel:(NSDictionary *)response;

@end

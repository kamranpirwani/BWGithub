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

/**
 * @class BWGithubParser
 * @brief The responsibility of this class is to validate and parse all responses contained in the corresponding provider 
 *        classes
 */
@interface BWGithubParser : NSObject

/**
 * Validate and parse the most popular repositories from the given payload
 */
+ (NSArray<BWGithubRepositoryModel *> *)handleGetMostPopularRepositories:(NSDictionary *)response;

/**
 * Validate and parse the top contributors from the given payload
 */
+ (NSArray<BWGithubContributorModel *> *)handleGetTopContributorsFromRepository:(NSDictionary *)response;

/**
 * Validate and parse the corresponding user's profile information
 */
+ (BWGithubUserModel *)handleGetUserProfileFromBarebonesUserModel:(NSDictionary *)response;

@end

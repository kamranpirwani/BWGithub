//
//  BWGithubService.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWGithubRepositoryModel.h"
#import "BWGithubContributorModel.h"
#import "BWGithubSearchQuery.h"
#import "BWGithubUserModel.h"

/**
 * @class BWGithubService
 * @brief The responsibility of this class is to provide the consumer with a singleton object,
 *        assisting in performing fetches for relevant pieces of GitHub data
 * @note This class provides a high abstraction layer for the consumer, and allows them to fetch relevant
 *       data without being aware of how the API works under the hood. For example, the top contirbutors in the
 *       repositories are actually a seperate network call, but the repository model ALWAYS has this field filled out,
 *       as we perform both calls and merge the data under the hood.
 */
@interface BWGithubService : NSObject

+ (instancetype)sharedInstance;

/**
 * A method used to perform a search on the GitHub API for repositories matching the search query
 * @param searchQuery the search query we will use to search GitHub
 * @param callback The response for this request, provifing an error message and repositories array(if applicable)
 */
- (void)searchForRepositoryWithQuery:(BWGithubSearchQuery *)searchQuery
                            callback:(void(^)(NSString *errorString, NSArray<BWGithubRepositoryModel *> *repositories))callback;

/**
 * A method used to query for a users profile information
 * @param user A slim user model, typically retrieved from a repository search
 * @param callback The response for this request, providing an error message and complete user model(if applicable)
 */
- (void)getUserProfileFromBarebonesUserModel:(BWGithubBarebonesUserModel *)user
                                    callback:(void (^)(NSString *errorString, BWGithubUserModel *completeUser))callback;

@end

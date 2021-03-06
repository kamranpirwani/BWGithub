//
//  BWGithubProviderProtocol.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWGithubRepositoryModel;
@class BWGithubContributorModel;
@class BWGithubSearchQuery;
@class BWGithubBarebonesUserModel;
@class BWGithubUserModel;

/**
 * @protocol BWGithubProviderProtocol
 * @brief Adds a layer of abstraction over our providers, so we can swap out the mock/real providers
 *        without forming any strong dependencies on the class type
 */
@protocol BWGithubProviderProtocol <NSObject>

@required

- (void)searchForRepositoryWithQuery:(BWGithubSearchQuery *)searchQuery
                            callback:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback;

- (void)getTopContributorsFromRepository:(BWGithubRepositoryModel *)repository
                                callback:(void(^)(NSError *error, NSArray<BWGithubContributorModel *> *contributors))callback;

- (void)getUserProfileFromBarebonesUserModel:(BWGithubBarebonesUserModel *)user
                                    callback:(void (^)(NSError *error, BWGithubUserModel *completeUser))callback;

@end

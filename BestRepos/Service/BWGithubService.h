//
//  BWGithubService.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWGithubRepositoryModel;
@class BWGithubContributorModel;

@interface BWGithubService : NSObject

+ (instancetype)sharedInstance;

/**
 * A convenience method which returns the top 100 starred repositories, along with their top contributors
 * @note This method allows the consumer to retrieve all of their relevant data in a single call. The consumer isn't even
 *       aware when interfacing with the API that we actually need to make several network calls to get all of this data
 */
- (void)getMostPopularRepositoriesAndTheirTopContributors:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback;

@end

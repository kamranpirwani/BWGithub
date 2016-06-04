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

@interface BWGithubService : NSObject

+ (instancetype)sharedInstance;

- (void)searchForRepositoryWithQuery:(BWGithubSearchQuery *)searchQuery
                            callback:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback;

- (void)getUserProfileFromBarebonesUserModel:(BWGithubBarebonesUserModel *)user
                                    callback:(void (^)(NSError *error, BWGithubUserModel *completeUser))callback;

@end

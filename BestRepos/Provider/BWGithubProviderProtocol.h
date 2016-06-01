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

@protocol BWGithubProviderProtocol <NSObject>

@required

- (void)getMostPopularRepositories:(void(^)(NSError *error, NSArray<BWGithubRepositoryModel *> *repositories))callback;

- (void)getTopContributorsFromRepository:(BWGithubRepositoryModel *)repository
                                callback:(void(^)(NSError *error, NSArray<BWGithubContributorModel *> *contributors))callback;

@end

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

@interface BWGithubParser : NSObject

+ (NSArray<BWGithubRepositoryModel *> *)handleMostPopularRepositoriesFetch:(NSDictionary *)response;
+ (NSArray<BWGithubContributorModel *> *)handleTopContributorsFromRepositoryFetch:(NSDictionary *)response;

@end

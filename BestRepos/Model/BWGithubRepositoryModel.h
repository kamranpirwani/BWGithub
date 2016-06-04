//
//  BWGithubRepositoryModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWGithubBarebonesUserModel.h"
#import "BWGithubContributorModel.h"

@interface BWGithubRepositoryModel : NSObject

@property(nonatomic, readonly) NSUInteger identifier;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *fullName;
@property(nonatomic, readonly) BWGithubBarebonesUserModel *owner;
@property(nonatomic, readonly) NSString *htmlUrl;
@property(nonatomic, readonly) NSString *projectDescription;
@property(nonatomic, readonly) NSString *contributorsUrl;
@property(nonatomic, readonly) NSString *language;

@property(nonatomic, readonly) NSUInteger forkCount;
@property(nonatomic, readonly) NSUInteger starredCount;

@property(nonatomic, readonly) NSArray<BWGithubContributorModel *> *topContributors;

@end

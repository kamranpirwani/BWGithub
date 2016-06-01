//
//  BWGithubRepositoryModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubRepositoryModel.h"

@interface BWGithubRepositoryModel ()

@property(nonatomic, readwrite) NSUInteger identifier;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSString *fullName;
@property(nonatomic, readwrite) BWGithubBarebonesUserModel *owner;
@property(nonatomic, readwrite) NSString *htmlUrl;
@property(nonatomic, readwrite) NSString *projectDescription;
@property(nonatomic, readwrite) NSString *contributorsUrl;

@property(nonatomic, readwrite) NSUInteger forkCount;
@property(nonatomic, readwrite) NSUInteger starredCount;
@property(nonatomic, readwrite) NSUInteger watchersCount;

@property(nonatomic, readwrite) NSArray<BWGithubContributorModel *> *topContributors;

@end

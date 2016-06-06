//
//  BWGithubRepositoryModel_Internal.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/31/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubRepositoryModel.h"

/**
 * The purpose of this class is to serve as an extension, providing readwrite access only to
 * classes that create instances of this model. For example, the parser and unit tests classes
 * need these headers to set these attributes. The consumers of this model will only have read only
 * access to all of the attributes
 */
@interface BWGithubRepositoryModel ()

@property(nonatomic, readwrite) NSUInteger identifier;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSString *fullName;
@property(nonatomic, readwrite) BWGithubBarebonesUserModel *owner;
@property(nonatomic, readwrite) NSString *htmlUrl;
@property(nonatomic, readwrite) NSString *projectDescription;
@property(nonatomic, readwrite) NSString *contributorsUrl;
@property(nonatomic, readwrite) NSString *language;

@property(nonatomic, readwrite) NSUInteger forkCount;
@property(nonatomic, readwrite) NSUInteger starredCount;

@property(nonatomic, readwrite) NSArray<BWGithubContributorModel *> *topContributors;

@end

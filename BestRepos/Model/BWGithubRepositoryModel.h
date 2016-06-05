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

/**
 * @class BWGithubRepositoryModel 
 * @brief The purpose of this class is to serve as a model for Github Repositories
 * @note The topContributors properly typically comes back in a different network call,
 *        but because of the way our service is constructed, we are always guaranteed to
 *        have this information anytime we have a valid model object
 */
@interface BWGithubRepositoryModel : NSObject

/**
 * The unique identifier for the repository
 */
@property(nonatomic, readonly) NSUInteger identifier;

/**
 * The name for the repository
 */
@property(nonatomic, readonly) NSString *name;

/**
 * A full name for the repository, prefixed with the owner name
 */
@property(nonatomic, readonly) NSString *fullName;

/**
 * The owner of the repository
 */
@property(nonatomic, readonly) BWGithubBarebonesUserModel *owner;

/**
 * The html url cooresponding to this repository
 */
@property(nonatomic, readonly) NSString *htmlUrl;

/**
 * The description for this repository
 */
@property(nonatomic, readonly) NSString *projectDescription;

/**
 * The relevant url to look up the contributors for this repository
 */
@property(nonatomic, readonly) NSString *contributorsUrl;

/**
 * The programming language for the repository
 */
@property(nonatomic, readonly) NSString *language;

/**
 * The number of users who have forked the repository
 */
@property(nonatomic, readonly) NSUInteger forkCount;

/**
 * The number of users who have starred the repository
 */
@property(nonatomic, readonly) NSUInteger starredCount;

/**
 * The top contributors for the repository
 */
@property(nonatomic, readonly) NSArray<BWGithubContributorModel *> *topContributors;

@end

//
//  BWGithubUserModel.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWGithubBarebonesUserModel.h"

/**
 * @class BWGithubUserModel
 * @brief The purpose of this class is to serve as a complete user model
 *        as have all of the user's relevant profile information
 *
 * @note We currently only form the complete user model when explicitly following
 *       the user profile link and fetching their profile
 */
@interface BWGithubUserModel : BWGithubBarebonesUserModel

/**
 * The type of account the user has
 */
@property(nonatomic, readonly) NSString *type;

/**
 * The users name - if provided
 */
@property(nonatomic, readonly) NSString *name;

/**
 * The number of public repositories the user has created
 */
@property(nonatomic, readonly) NSUInteger numberOfPublicRepositories;

/**
 * The number of followers the user has
 */
@property(nonatomic, readonly) NSUInteger followers;

/**
 * The number of users we are following
 */
@property(nonatomic, readonly) NSUInteger following;

/**
 * The users specified location on their profile
 */
@property(nonatomic, readonly) NSString *location;

/**
 * The users biography on their profile
 */
@property(nonatomic, readonly) NSString *bio;

@end
